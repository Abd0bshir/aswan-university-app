import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:au/services/auth.dart';
import '../profile/profile.dart';

class CustomDrawer extends StatefulWidget {
  final AuthService authService;

  const CustomDrawer({Key? key, required this.authService}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userData = doc.data() as Map<String, dynamic>?;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "${userData?['firstName'] ?? 'First'} ${userData?['lastName'] ?? 'Last'}",
            ),
            accountEmail: Text(userData?['email'] ?? 'email@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF007C7B)),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF007C7B),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () async {
              final updated = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const Profile()),
              );
              if (updated == true) {
                await fetchUserData(); // لو اتغيرت البيانات، نعيد تحميلها
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Courses"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text("Schedule"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.grade),
            title: const Text("Grades"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await widget.authService.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
