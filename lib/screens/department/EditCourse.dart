import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCourse extends StatefulWidget {
  final String departmentId;
  final String courseId;
  final Map<String, dynamic> courseData;

  const EditCourse({
    super.key,
    required this.departmentId,
    required this.courseId,
    required this.courseData,
  });

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  // Consistent color palette
  final Color primaryColor = const Color(0xFF007C7B); // Teal
  final Color backgroundColor = const Color(0xFFF4F7F9); // Soft Gray
  final Color cardColor = Colors.white;
  final Color successColor = const Color(0xFF4CAF50); // Green
  final Color errorColor = const Color(0xFFF44336); // Red
  final Color textColorPrimary = const Color(0xFF212121); // Dark Gray
  final Color textColorSecondary = Colors.black87;
  final Color inputFieldFillColor = Colors.grey.shade100;
  final Color inputFieldBorderColor = Colors.grey.shade400;
  final Color focusedInputBorderColor = Colors.teal.shade700;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.courseData['name']);
    _descriptionController = TextEditingController(text: widget.courseData['description']);
  }

  Future<void> _updateCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('departments')
            .doc(widget.departmentId)
            .collection('courses')
            .doc(widget.courseId)
            .update({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("✅ Course updated successfully!", style: TextStyle(color: Colors.white)),
              backgroundColor: successColor,
            ),
          );
          Navigator.pop(context);
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("⚠️ Error updating course: $error", style: TextStyle(color: Colors.white)),
              backgroundColor: errorColor,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
      value!.trim().isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColorSecondary),
        prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        filled: true,
        fillColor: inputFieldFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: inputFieldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusedInputBorderColor, width: 1.6),
        ),
      ),
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameFocusNode = FocusNode();
    final descriptionFocusNode = FocusNode();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Course"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0, // Consistent with EditDepartment
        centerTitle: true, // Consistent with EditDepartment and AddCourse
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20), // Increased padding for consistency
        child: Card(
          elevation: 3, // Consistent card elevation
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Consistent card shape
          color: cardColor, // Explicitly set card color
          child: Padding(
            padding: const EdgeInsets.all(20), // Consistent padding inside the card
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Edit Course Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColorPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: "Course Name",
                    controller: _nameController,
                    icon: Icons.book_outlined,
                    textInputAction: TextInputAction.next,
                    focusNode: nameFocusNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(descriptionFocusNode),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Description",
                    controller: _descriptionController,
                    icon: Icons.description_outlined,
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    focusNode: descriptionFocusNode,
                    onFieldSubmitted: (_) => _updateCourse(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateCourse,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.save_alt_rounded), // Using a more appropriate icon
                      label: Text(
                        _isLoading ? "Saving..." : "Update Course",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2, // Maintain subtle elevation
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}