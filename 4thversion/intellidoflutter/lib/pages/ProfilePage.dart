import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellidoflutter/navbar/bottom_nav_bar.dart';
import 'package:intellidoflutter/pages/HomePage.dart';
import 'package:intellidoflutter/navbar/todo_bottom_sheet.dart';
import 'package:intellidoflutter/pages/ProfileSetUpPage.dart';
import 'package:intellidoflutter/pages/total_number_list_page.dart'; // Import the new page

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var photoURL = userData.containsKey('photoURL') ? userData['photoURL'] : '';
          var displayName = userData.containsKey('displayName') ? userData['displayName'] : '[Display Name]';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  // backgroundColor: Colors.grey[300],
                  child: photoURL.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            photoURL,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),
                        )
                      : Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  displayName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileSetUpPage()),
                    );
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('tasks')
                      .where('user', isEqualTo: FirebaseFirestore.instance.collection('users').doc(user?.uid))
                      .where('complete', isEqualTo: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final completedTasks = snapshot.data!.docs;
                    return Card(
                      child: ListTile(
                        title: Text('Completed Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(completedTasks.length.toString()),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CompletedTasksPage(
                                completedTasks: completedTasks,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Card(
                  child: ListTile(
                    title: Text('Total Number List of Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TotalNumberListPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return TodoBottomSheet();
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 76, 0, 253),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}


class CompletedTasksPage extends StatelessWidget {
  final List<DocumentSnapshot> completedTasks;

  const CompletedTasksPage({Key? key, required this.completedTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: true,
                onChanged: null, // Disable the checkbox
              ),
              title: Text(task['title']),
              subtitle: Text(task['details']),
            ),
          );
        },
      ),
    );
  }
}
