import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDepartmentScreen extends StatefulWidget {
  const AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController coursesController = TextEditingController();

  void addDepartment() async {
    final name = nameController.text.trim();
    final courses = coursesController.text.split(',').map((e) => e.trim()).toList();

    if (name.isNotEmpty) {
      await FirebaseFirestore.instance.collection('departments').add({
        'name': name,
        'studentCount': 0,
        'courses': courses,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Department added.")));
      nameController.clear();
      coursesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Department')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Department Name'),
            ),
            TextField(
              controller: coursesController,
              decoration: InputDecoration(labelText: 'Courses (comma-separated)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addDepartment,
              child: Text('Add Department'),
            ),
          ],
        ),
      ),
    );
  }
}
