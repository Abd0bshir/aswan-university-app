import 'package:flutter/material.dart';

import 'package:au/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:au/services/database.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'Dlist.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    return StreamProvider<QuerySnapshot?>.value(
      value: (uid != null) ? DatabaseService(uid!).userDataStream : null,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF007C7B),
          title: const Text("Home Page"),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // تفتح القائمة الجانبية
              },
            ),
          ),
        ),
        drawer : CustomDrawer(

        authService: authService,
      ),
        body: const DepartmentList(),
      ),
    );
  }
}
