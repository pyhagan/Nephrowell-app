import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // Instance of Firestore for data storage
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instance of FirebaseAuth for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  

  // Signup method
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      // Register user in Firebase Auth with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'username': username,
        'email': email,
        'uid': credential.user!.uid,
      });

      res = "Successful";
    } catch (e) {
      res = e.toString(); // Assign the error message to the response
      print(e.toString());
    }

    return res;
  }

  // Sign-in method
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      // Sign in user with email and password
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        res = "Successful";
      } else {
        res = "Sign-in failed";
      }
    } catch (e) {
      res = e.toString(); // Assign the error message to the response
      print(e.toString());
    }

    return res;
  }
}
