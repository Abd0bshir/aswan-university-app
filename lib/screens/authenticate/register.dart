import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:au/screens/home/home.dart';
import 'package:au/services/auth.dart';
import 'package:au/shared/constants.dart';
import 'package:au/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  String? selectedDepartment;
  String? selectedYear;
  bool loading = false;
  bool _obscurePassword = true;

  final AuthService _auth = AuthService();
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

  Future<void> register() async {
    if (_formKey.currentState!.validate() && selectedDepartment != null && selectedYear != null) {
      setState(() => loading = true);
      try {
        await _auth.registerWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          department: selectedDepartment!,
          year: selectedYear!,
        );

        final query = await FirebaseFirestore.instance
            .collection('departments')
            .where('name', isEqualTo: selectedDepartment)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final depRef = query.docs.first.reference;
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            final snapshot = await transaction.get(depRef);
            final currentCount = snapshot['count'] ?? 0;
            transaction.update(depRef, {'count': currentCount + 1});
          });
        }

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered successfully!')));
      } catch (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Image(
                  image: AssetImage("images/logo.png"),
                  height: 180,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF007C7B)),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
                            child: TextFormField(
                              controller: firstNameController,
                              validator: (val) => val!.isEmpty ? "First Name" : null,
                              decoration: customInputDecoration.copyWith(
                                labelText: 'First Name',
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
                            child: TextFormField(
                              controller: lastNameController,
                              validator: (val) => val!.isEmpty ? "Last Name" : null,
                              decoration: customInputDecoration.copyWith(
                                labelText: 'Last Name',
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: TextFormField(
                        controller: emailController,
                        validator: (val) =>
                        val != null && val.contains('@') ? null : 'Enter valid email',
                        decoration: customInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        validator: (val) =>
                        val != null && val.length >= 8 ? null : 'Min 8 characters',
                        decoration: customInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
                            child: DropdownButtonFormField<String>(
                              value: selectedDepartment,
                              decoration: customInputDecoration.copyWith(
                                labelText: "Department",
                                prefixIcon: const Icon(Icons.school),
                              ),
                              items: departmentNames.map((name) {
                                return DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => selectedDepartment = val);
                              },
                              validator: (val) =>
                              val == null ? "Select Department" : null,
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
                            child: DropdownButtonFormField<String>(
                              value: selectedYear,
                              decoration: customInputDecoration.copyWith(
                                labelText: "Year",
                                prefixIcon: const Icon(Icons.calendar_month),
                              ),
                              items: ['1', '2', '3', '4'].map((year) {
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text('Year $year'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => selectedYear = val);
                              },
                              validator: (val) => val == null ? "Select Year" : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007C7B),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: register,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?", style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () => widget.toggleView(),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18, color: Color(0xFF007C7B)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
