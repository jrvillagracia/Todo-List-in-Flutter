import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBotMessage extends StatefulWidget {
  final List messages;
  const ChatBotMessage({super.key, required this.messages});

  @override
  State<ChatBotMessage> createState() => _ChatBotMessageState();
}

class _ChatBotMessageState extends State<ChatBotMessage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        var message = widget.messages[index]["message"];
        var isUserMessage = widget.messages[index]["isUserMessage"];
        var text = message != null && message.text != null ? message.text.text[0] : "";

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: isUserMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isUserMessage)
                CircleAvatar(
                  child: Text('B', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.grey,
                ),
              if (isUserMessage)
                Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isUserMessage
                      ? Colors.grey.shade300
                      : Colors.grey.shade300,
                ),
                constraints: BoxConstraints(maxWidth: width * 2 / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: const TextStyle(color: Colors.black)),
                    if (!isUserMessage)
                      IconButton(
                        icon: Icon(Icons.star_border),
                        onPressed: () {
                          _addToTasks(text);
                        },
                      ),
                  ],
                ),
              ),
              if (!isUserMessage)
                Spacer(),
              if (isUserMessage)
                CircleAvatar(
                  child: Text('Y', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.grey,
                ),
            ],
          ),
        );
      },
    );
  }

  void _addToTasks(String text) async {
    await FirebaseFirestore.instance.collection('tasks').add({
      'title': 'From Chatbot',
      'details': text,
      'complete': false,
      'archived': false,
      'user': FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid)
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added to Home Page')));
  }
}
