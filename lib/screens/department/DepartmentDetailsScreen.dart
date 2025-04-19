import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddCourse.dart';
import 'EditCourse.dart';
import 'EditDepartment.dart';

class DepartmentCourses extends StatelessWidget {
  final String departmentId;

  const DepartmentCourses({super.key, required this.departmentId});

  // Consistent color palette
  static const Color primaryColor = Color(0xFF007C7B); // Teal
  static const Color backgroundColor = Color(0xFFF4F7F9); // Soft Gray
  static const Color cardColor = Colors.white;
  static const Color textColorPrimary = Color(0xFF212121); // Dark Gray
  static const Color textColorSecondary = Colors.black87;
  static const Color iconColor = primaryColor;
  static const Color loadingIndicatorColor = primaryColor;
  static const Color editIconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor, // Apply consistent background color
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: primaryColor, // Apply primary color to AppBar
        foregroundColor: Colors.white, // Ensure text and icons are visible
        elevation: 1, // Add a subtle shadow
        centerTitle: true, // Center the title for better aesthetics
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
          const SizedBox(width: 8), // Add some spacing on the right
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
            return const Center(child: CircularProgressIndicator(color: loadingIndicatorColor)); // Use primary color for indicator
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching courses: ${snapshot.error}", style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 60, color: iconColor.withOpacity(0.6)), // Use primary color for empty icon
                  const SizedBox(height: 16),
                  Text("No courses available", style: theme.textTheme.titleMedium?.copyWith(color: textColorSecondary.withOpacity(0.8))), // Use secondary text color
                  const SizedBox(height: 8),
                  Text("Tap the '+' button to add a new course.", style: theme.textTheme.bodySmall?.copyWith(color: textColorSecondary.withOpacity(0.6)), textAlign: TextAlign.center,),
                ],
              ),
            );
          } else {
            final courses = snapshot.data!.docs.map((doc) {
              return doc.data() as Map<String, dynamic>;
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add padding to the list
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseId = snapshot.data!.docs[index].id; // Get the document ID

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8), // Reduced horizontal margin for better use of space
                  elevation: 2,
                  color: cardColor, // Apply consistent card color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Icon(Icons.book, color: iconColor), // Use primary color for leading icon
                    title: Text(
                      course['name'] ?? 'Unnamed Course',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: textColorPrimary), // Use primary text color
                    ),
                    subtitle: Text(
                      course['description'] ?? 'No Description',
                      style: theme.textTheme.bodySmall?.copyWith(color: textColorSecondary),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: editIconColor),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Default but good to be explicit
    );
  }
}