import 'package:au/models/department.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDepartmentScreen extends StatefulWidget {
  final DocumentSnapshot departmentDoc;

  const EditDepartmentScreen({super.key, required this.departmentDoc, required Department department});

  @override
  State<EditDepartmentScreen> createState() => _EditDepartmentScreenState();
}

class _EditDepartmentScreenState extends State<EditDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.departmentDoc['name'] ?? '';
    _descriptionController.text = widget.departmentDoc['description'] ?? '';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('departments')
            .doc(widget.departmentDoc.id)
            .update({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          // يمكنك إضافة المزيد من الحقول هنا لتعديلها
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Department updated successfully!')),
        );
        Navigator.pop(context, true); // إرجاع true للإشارة إلى أنه تم التعديل
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating department: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Department Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}