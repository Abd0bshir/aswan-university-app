
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create User Obj based firebase uid
  Users? _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change User stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user!));
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException (Sign In): ${e.message}");
      return Future.error(e.message!);
    } catch (e) {
      print("Error (Sign In): ${e.toString()}");
      return Future.error("An unexpected error occurred during sign in.");
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password,
      {String? firstName,
        String? lastName,
        String? department,
        String? year}) async {
    // Make the new parameters optional
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Ensure user is not null before proceeding
      if (user != null) {
        // Use a more descriptive name for the collection, like "users"
        CollectionReference usersCollection = _firestore.collection('users');

        // Set the document ID to the user's UID
        DocumentReference userDoc = usersCollection.doc(user.uid);

        // Use set() to create the document. If the document doesn't exist, it will be created.
        await userDoc.set({
          'email': email,
          'firstName': firstName, // Include the new fields
          'lastName': lastName,
          'department': department,
          'year': year,
          // Add other user data here
        });
        print("User document created successfully in Firestore!");
        return _userFromFirebaseUser(user);
      } else {
        print("User is null after authentication.");
        return Future.error("User is null after authentication.");
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException (Register): ${e.message}");
      return Future.error(e.message!);
    } catch (e) {
      print("Error creating user document in Firestore: ${e.toString()}");
      return Future.error("An unexpected error occurred during registration.");
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

