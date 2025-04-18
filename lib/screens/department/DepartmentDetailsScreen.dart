import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddCourse.dart';
import 'EditCourse.dart';
import 'EditDepartment.dart';

class DepartmentCourses extends StatelessWidget {
  final String departmentId;

  const DepartmentCourses({super.key, required this.departmentId});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    const primaryColor = Color(0xFF007C7B); // Define your primary color

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: primaryColor, // Apply primary color to AppBar
        foregroundColor: Colors.white, // Ensure text and icons are visible
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white), // Ensure icon color contrasts
            tooltip: 'Edit Department',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDepartment(departmentId: departmentId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('departments')
            .doc(departmentId)
            .collection('courses')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor)); // Use primary color for indicator
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching courses: ${snapshot.error}", style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No courses available", style: theme.textTheme.bodyMedium?.copyWith(color: primaryColor))); // Use primary color for empty state
          } else {
            final courses = snapshot.data!.docs.map((doc) {
              return doc.data() as Map<String, dynamic>;
            }).toList();

            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseId = snapshot.data!.docs[index].id; // Get the document ID

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Icon(Icons.book, color: primaryColor), // Use primary color for leading icon
                    title: Text(
                      course['name'] ?? 'Unnamed Course',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: primaryColor), // Use primary color for title
                    ),
                    subtitle: Text(
                      course['description'] ?? 'No Description',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCourse(
                              departmentId: departmentId,
                              courseId: courseId, // Pass the course ID
                              courseData: course, // Pass the course data
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Course',
        backgroundColor: primaryColor, // Apply primary color to FAB
        foregroundColor: Colors.white, // Ensure icon color contrasts
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCourse(departmentId: departmentId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}