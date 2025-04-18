import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourse extends StatefulWidget {
  final String departmentId;

  const AddCourse({super.key, required this.departmentId});

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addCourse() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('departments')
          .doc(widget.departmentId)
          .collection('courses')
          .add({
        'name': _nameController.text,
        'description': _descriptionController.text,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Course")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Course Name"),
                validator: (value) =>
                value!.isEmpty ? "Enter course name" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                validator: (value) =>
                value!.isEmpty ? "Enter course description" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCourse,
                child: Text("Add Course"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
