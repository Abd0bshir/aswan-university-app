import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class DepartmentDropdown extends StatefulWidget {
  final Function(String) onChanged;
  const DepartmentDropdown({super.key, required this.onChanged});

  @override
  State<DepartmentDropdown> createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {
  String? selectedDepartment;
  List<String> departments = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }



  Future<void> fetchDepartments() async {
    final snapshot = await FirebaseFirestore.instance.collection('departments').get();
    final List<String> fetched = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      departments = fetched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedDepartment,
      items: departments.map((dept) {
        return DropdownMenuItem(
          value: dept,
          child: Text(dept),
        );
      }).toList(),
      onChanged: (val) {
        setState(() => selectedDepartment = val);
        widget.onChanged(val!);
      },
      decoration: const InputDecoration(labelText: "اختر القسم"),
    );
  }
}
