import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:au/services/auth.dart';
import '../department/DepartmentDetailsScreen.dart';
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

  final Color primaryColor = const Color(0xFF007C7B);

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "${userData?['firstName'] ?? 'First'} ${userData?['lastName'] ?? 'Last'}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              userData?['email'] ?? 'email@example.com',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Color(0xFF007C7B),
              ),
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              gradient: LinearGradient(
                colors: [primaryColor, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.person,
            label: 'Profile',
            onTap: () async {
              final updated = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const Profile()),
              );
              if (updated == true) {
                await fetchUserData();
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.book,
            label: 'Courses',
            onTap: () => _navigateToCourses(context),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            iconColor: Colors.red[600],
            onTap: () async {
              await widget.authService.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? primaryColor),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _navigateToCourses(BuildContext context) async {
    if (userData == null) return;
    final departmentName = userData?['department'] ?? '';
    if (departmentName.isEmpty) {
      _showMessage("User does not have an assigned department");
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('departments')
        .where('name', isEqualTo: departmentName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final departmentId = querySnapshot.docs.first.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DepartmentCourses(departmentId: departmentId),
        ),
      );
    } else {
      _showMessage("No department found with the name '$departmentName'");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
