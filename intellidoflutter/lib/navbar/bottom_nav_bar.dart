import 'package:flutter/material.dart';
import 'package:intellidoflutter/pages/HomePage.dart';
import 'package:intellidoflutter/pages/ChatBotPage.dart';
import 'package:intellidoflutter/pages/ProfilePage.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0), // Add bottom padding
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Add side margins if desired
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chatbot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  break;
                case 1:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatBotPage()));
                  // Navigate to Chatbot Page
                  break;
                case 2:
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage()));
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
