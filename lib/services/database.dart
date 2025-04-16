import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department.dart'; // Import your Department model

class DatabaseService {
  final String? uid;
  DatabaseService([this.uid]);
  //Collection Reference

  final CollectionReference
  usersCollection = // Changed to usersCollection for clarity
      FirebaseFirestore.instance.collection('users');

  final CollectionReference departmentCollection = FirebaseFirestore.instance
      .collection('departments');

  Future updateUserData(
    String fName,
    String lName,
    String department,
    String year,
  ) async {
    return await usersCollection.doc(uid).set({
      "fName": fName,
      "lName": lName,
      "department": department,
      "year": year,
    });
  }

  // ---------------------------------------------------------------------------
  //  Department Related Methods
  // ---------------------------------------------------------------------------

  /// Creates a list of [Department] objects from a Firestore [QuerySnapshot].
  List<Department> _departmentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data =
          doc.data() as Map<String, dynamic>; // Correct way to get data
      return Department.fromFirestore(doc); // Use the factory constructor
    }).toList();
  }

  ///  Gets a stream of [Department] objects from Firestore.
  Stream<List<Department>> get departments {
    return departmentCollection.snapshots().map(_departmentListFromSnapshot);
  }

  // ---------------------------------------------------------------------------
  //  User Related Methods
  // ---------------------------------------------------------------------------
  // Get user data as a stream
  Stream<QuerySnapshot> get userDataStream {
    return usersCollection.snapshots();
  }

  // Get user data for a specific user.
  Stream<DocumentSnapshot> getUserStream() {
    return usersCollection.doc(uid).snapshots();
  }
}
