import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  final String id;
  final String name;
  final String description;

  Department({required this.id, required this.name, required this.description});

  // Factory constructor to create a Department object from Firestore data
  factory Department.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Department(
      id: doc.id,
      name: data['name'] ?? 'Unnamed Department',
      description: data['description'] ?? 'No Description',
    );
  }
}
