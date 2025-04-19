import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditDepartment extends StatefulWidget {
  final String departmentId;

  const EditDepartment({super.key, required this.departmentId});

  @override
  _EditDepartmentState createState() => _EditDepartmentState();
}

class _EditDepartmentState extends State<EditDepartment> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
  final Color loadingIndicatorColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    _loadDepartmentData();
  }

  Future<void> _loadDepartmentData() async {
    setState(() => _isLoading = true);
    try {
      var doc = await FirebaseFirestore.instance
          .collection('departments')
          .doc(widget.departmentId)
          .get();

      if (doc.exists) {
        _nameController.text = doc['name'] ?? '';
        _descriptionController.text = doc['description'] ?? '';
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("⚠️ Department data not found!", style: TextStyle(color: Colors.white)),
              backgroundColor: errorColor,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" Error loading data: $error", style: TextStyle(color: Colors.white)),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDepartment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance
            .collection('departments')
            .doc(widget.departmentId)
            .update({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("✅ Department updated successfully!", style: TextStyle(color: Colors.white)),
              backgroundColor: successColor,
            ),
          );
          Navigator.pop(context);
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Error updating: $error", style: TextStyle(color: Colors.white)), backgroundColor: errorColor),
          );
        }
      } finally {
        setState(() => _isLoading = false);
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
          borderSide: BorderSide(color: focusedInputBorderColor, width: 1.8),
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
        title: const Text("Edit Department"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 1, // Add a subtle shadow
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: loadingIndicatorColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          color: cardColor, // Explicitly set card color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Update Department Info",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColorPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: "Department Name",
                    controller: _nameController,
                    icon: Icons.apartment_outlined,
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
                    onFieldSubmitted: (_) => _updateDepartment(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateDepartment,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.save_alt_rounded),
                      label: Text(
                        _isLoading ? "Saving..." : "Update Department",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2, // Add a subtle shadow
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