import 'package:au/models/department.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_department_screen.dart'; // استيراد شاشة التعديل

class DepartmentDetailsScreen extends StatelessWidget {
  final DocumentSnapshot departmentDoc;

  const DepartmentDetailsScreen({super.key, required this.departmentDoc, required Department department});

  @override
  Widget build(BuildContext context) {
    final name = departmentDoc['name'] as String? ?? 'N/A';
    final studentCount = departmentDoc['studentCount'] as int? ?? 0;
    final coursesData = departmentDoc['courses'];
    final List<String> courses = coursesData is List ? List<String>.from(coursesData) : [];
    final description = departmentDoc['description'] as String? ?? 'No description available.';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDepartmentScreen(departmentDoc: departmentDoc, department: null,),
                ),
              ).then((value) {
                // يمكنك هنا إعادة تحميل بيانات القسم إذا تم تعديله
                if (value == true) {
                  // قم بتنفيذ منطق إعادة التحميل إذا لزم الأمر
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Department details refreshed.')),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.people, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Students Count: $studentCount', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Courses:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            if (courses.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('No courses listed for this department.', style: TextStyle(color: Colors.grey)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Color(0xFF007C7B)),
                      title: Text(course),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}