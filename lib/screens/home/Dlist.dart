import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/department.dart';
import 'department_Tile.dart';

class DepartmentList extends StatelessWidget {
  const DepartmentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final departments = Provider.of<List<Department>?>(context); // Use List<Department>?

    if (departments == null) {
      return const Center(child: Text('Loading Departments...')); // Handle null case
    }

    if (departments.isEmpty) {
      return const Center(child: Text('No departments found.')); // Handle empty case
    }

    return ListView.builder(
      itemCount: departments.length ,
      itemBuilder: (context, index) {
        final department = departments[index]; // Get the individual department
        return DepartmentTile(department: department); // Pass the correct department
      },
    );
  }
}