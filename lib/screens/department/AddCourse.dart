import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourse extends StatefulWidget {
  final String departmentId;

  const AddCourse({super.key, required this.departmentId});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF007C7B);
  final Color backgroundColor = const Color(0xFFF1F6F9);
  final Color cardColor = Colors.white;

  Future<void> _addCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance
            .collection('departments')
            .doc(widget.departmentId)
            .collection('courses')
            .add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Course added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Error adding course: $error"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
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
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 1.6),
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
        backgroundColor: primaryColor,
        title: const Text("Add New Course"),
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shadowColor: Colors.black12,
          color: cardColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Enter Course Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
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
                    label: "Course Description",
                    controller: _descriptionController,
                    icon: Icons.description_outlined,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    focusNode: descriptionFocusNode,
                    onFieldSubmitted: (_) => _addCourse(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _addCourse,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.add),
                      label: Text(
                        _isLoading ? "Adding..." : "Add Course",
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
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