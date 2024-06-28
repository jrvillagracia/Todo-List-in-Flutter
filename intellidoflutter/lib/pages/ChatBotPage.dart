import 'package:flutter/material.dart';
import 'package:intellidoflutter/pages/HomePage.dart';

class ChatBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 20),
            Text(
              'Chatbot',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  ChatMessage(isUser: false, text: 'How can I help you?'),
                  ChatMessage(isUser: true, text: 'Lorem ipsum dolor sit amet.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final bool isUser;
  final String text;

  const ChatMessage({Key? key, required this.isUser, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) CircleAvatar(child: Text('A')),
          if (!isUser) SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(text),
          ),
          if (isUser) SizedBox(width: 10),
          if (isUser) CircleAvatar(child: Text('A')),
        ],
      ),
    );
  }
}
