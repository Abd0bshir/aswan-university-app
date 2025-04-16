import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:au/shared/constants.dart';

class DepartmentDropdown extends StatefulWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const DepartmentDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<DepartmentDropdown> createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {
  List<String> departmentNames = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final snapshot = await FirebaseFirestore.instance.collection('departments').get();
    setState(() {
      departmentNames = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedValue,
      items: departmentNames.map((name) {
        return DropdownMenuItem(
          value: name,
          child: Text(name),
        );
      }).toList(),
      onChanged: widget.onChanged,
      decoration: customInputDecoration.copyWith(
        labelText: 'Department',
        prefixIcon: const Icon(Icons.school),
      ),
      validator: (value) => value == null ? 'Please select department' : null,
      isExpanded: true,
    );
  }
}
