import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:au/models/department.dart';
import '../home/department_Tile.dart';
import 'DepartmentDetailsScreen.dart';
import 'edit_department_screen.dart'; // استيراد شاشة التعديل

class AllDepartmentsScreen extends StatelessWidget {
  const AllDepartmentsScreen({super.key});

  Future<void> _showDepartmentOptions(BuildContext context, Department department, DocumentSnapshot departmentDoc) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context); // إغلاق الـ BottomSheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDepartmentScreen(departmentDoc: departmentDoc, department: null,),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context); // إغلاق الـ BottomSheet
                // يمكنك هنا إضافة منطق حذف القسم
                _deleteDepartment(context, departmentDoc);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDepartment(BuildContext context, DocumentSnapshot departmentDoc) async {
    // يمكنك هنا إضافة مربع حوار تأكيد قبل الحذف
    await FirebaseFirestore.instance.collection('departments').doc(departmentDoc.id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Department deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('departments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No departments found.'));
          }

          final departments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final deptDoc = departments[index];
              final department = Department.fromFirestore(deptDoc);

              return DepartmentTile(
                department: department,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DepartmentDetailsScreen(departmentDoc: deptDoc, department: null,),
                    ),
                  );
                },
                onLongPress: () {
                  _showDepartmentOptions(context, department, deptDoc);
                },
              );
            },
          );
        },
      ),
    );
  }
}