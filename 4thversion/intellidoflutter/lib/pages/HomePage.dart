import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellidoflutter/navbar/bottom_nav_bar.dart';
import 'package:intellidoflutter/navbar/todo_bottom_sheet.dart';
import 'package:intellidoflutter/pages/TaskDetailsPage.dart';
import 'package:intellidoflutter/main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AuthScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.displayName ?? '[Display Name]',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Tasks:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .where('user', isEqualTo: FirebaseFirestore.instance.collection('users').doc(user?.uid))
                    .where('archived', isEqualTo: false) // Only show tasks that are not archived
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'It\'s time to do it!',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'What do you want to do?',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 76, 0, 253)
                              ),
                              child: Text('Add a task', style: TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final tasks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        taskId: task.id,
                        taskName: task['title'],
                        taskDescription: task['details'],
                        isComplete: task['complete'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

class TaskCard extends StatelessWidget {
  final String taskId;
  final String taskName;
  final String taskDescription;
  final bool isComplete;

  const TaskCard({
    Key? key,
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.isComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: isComplete,
          onChanged: (bool? value) async {
            await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
              'complete': value,
              'archived': value, // Archive the task when completed
            });
          },
        ),
        title: Text(taskName),
        onTap: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskDetailsPage(
              taskId: taskId,
              title: taskName,
              description: taskDescription,
            ),
          ));
          if (result == true) {
            // If task was updated, you can add additional logic here if needed
          }
        },
      ),
    );
  }
}
