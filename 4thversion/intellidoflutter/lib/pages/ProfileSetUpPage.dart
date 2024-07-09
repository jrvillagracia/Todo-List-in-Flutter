import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:intellidoflutter/pages/HomePage.dart';
import 'package:intellidoflutter/widgets/image_picker.dart';

class ProfileSetUpPage extends StatefulWidget {
  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {
  final nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _imageData;

  Future<void> _pickImage() async {
    Uint8List? imageData = await pickImage(ImageSource.gallery);
    if (imageData != null) {
      setState(() {
        _imageData = imageData;
      });
    }
  }

  Future<void> _uploadImage(User user) async {
    if (_imageData != null) {
      final storageRef =
          _storage.ref().child('user_photos').child('${user.uid}.jpg');
      final uploadTask = storageRef.putData(_imageData!);
      final snapshot = await uploadTask.whenComplete(() {});
      final photoURL = await snapshot.ref.getDownloadURL();

      // Save photo URL in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoURL': photoURL,
      });

      // Update the user's profile
      await user.updatePhotoURL(photoURL);
      await user.reload();
    }
  }

  Future<void> completeProfile() async {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          // Update the user's display name in Firebase Auth
          await user.updateDisplayName(name);
          await user.reload();

          // Save display name in Firestore
          await _firestore.collection('users').doc(user.uid).update({
            'displayName': name,
            'photoURL': '', // This will be updated after the image upload
          });

          // Upload image if available
          await _uploadImage(user);

          // Navigate to the main app screen
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      } catch (e) {
        // Handle errors here
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } else {
      // Show an error message or prompt user to enter a name
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile Set Up',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        _imageData != null ? MemoryImage(_imageData!) : null,
                    child: IconButton(
                      icon: Icon(Icons.add, size: 40, color: Colors.grey),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your Name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      nameController.clear();
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Color.fromARGB(255, 76, 0, 253),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: completeProfile,
                  child: Text(
                    'Complete Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
