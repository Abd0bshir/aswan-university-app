import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  String id;
  String name;
  String description;

  Department({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Department.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Department(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
    };
  }
}
