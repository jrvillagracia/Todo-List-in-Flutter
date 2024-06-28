import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;

  const TaskDetailsPage({
    Key? key,
    required this.taskId,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
  }

  Future<void> updateTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
        'title': titleController.text.trim(),
        'details': descriptionController.text.trim(),
      });
      Navigator.pop(context, true);  // Indicate that the task was updated
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).delete();
      Navigator.pop(context, true);  // Indicate that the task was deleted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task is Successfully Deleted'),
        ),
      );
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Task'),
                  content: Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                deleteTask();
              }
            },
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                updateTask();
              }
              setState(() {
                isEditing = !isEditing;
              });
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
              'Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: isEditing,
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: isEditing,
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEditing ? updateTask : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color.fromARGB(255, 76, 0, 253),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Update Task', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
