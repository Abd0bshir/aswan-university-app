import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:au/services/auth.dart';
import 'package:au/services/database.dart';
import '../../models/department.dart';
import '../department/DepartmentDetailsScreen.dart';
import 'department_Tile.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();
  String? uid;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      uid = user!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamProvider<QuerySnapshot?>.value(
      value: (uid != null) ? FirebaseFirestore.instance.collection('users').snapshots() : null,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF007C7B),
          title: Text(
            "Departments",
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        drawer: CustomDrawer(authService: authService),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('departments').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error fetching departments: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No departments available"));
            } else {
              final departments = snapshot.data!.docs.map((doc) {
                return Department.fromFirestore(doc);
              }).toList();

              return ListView.builder(
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  final department = departments[index];
                  return DepartmentTile(department: department);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
