import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department.dart';

class DatabaseService {
  final String? uid;
  DatabaseService([this.uid]);

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference departmentCollection = FirebaseFirestore.instance.collection('departments');

  // 🔥 لحل الخطأ
  Stream<DocumentSnapshot> get userDataStream {
    return usersCollection.doc(uid).snapshots();
  }

  Future<void> updateUserData(String fName, String lName, String department, String year) async {
    return await usersCollection.doc(uid).set({
      "fName": fName,
      "lName": lName,
      "department": department,
      "year": year,
    });
  }

  List<Department> _departmentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Department.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Department>> get departments {
    return departmentCollection.snapshots().map(_departmentListFromSnapshot);
  }

  Future<void> addDepartment(String name, String description) async {
    await departmentCollection.add({
      'name': name,
      'description': description,
    });
  }

  Future<void> deleteDepartment(String departmentId) async {
    await departmentCollection.doc(departmentId).delete();
  }

  Future<void> addCourseToDepartment(String departmentId, String name, String description) async {
    final coursesCollection = departmentCollection.doc(departmentId).collection('courses');
    await coursesCollection.add({
      'name': name,
      'description': description,
    });
  }
}
