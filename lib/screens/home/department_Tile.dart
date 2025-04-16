import 'package:flutter/material.dart';
import 'package:au/models/department.dart';

class DepartmentTile extends StatelessWidget {
  const DepartmentTile({super.key, required this.department});
  final Department department;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material( // Use Material for inkwell effect and better visual integration
        elevation: 3, // Add a subtle elevation using Material
        borderRadius: BorderRadius.circular(20),
        child: InkWell( // Use InkWell for tap feedback
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // يمكنك إضافة تنقل هنا
            print("Tapped on ${department.name}");
            // Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentDetailsScreen(department: department)));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // The boxShadow is now handled by the Material widget
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF007C7B).withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.school, color: Color(0xFF007C7B), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF007C7B),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          department.description,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}