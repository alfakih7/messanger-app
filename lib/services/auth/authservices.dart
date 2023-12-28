import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //instance for firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign user in method
  Future<UserCredential> signInWithEmailAndPassword(
      String email, Password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: Password);
      //add a new document for the users in users collecgion if it deosnt already exist
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    }
    //catch any errors
    on Exception catch (e) {
      throw Exception(e.hashCode);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential usercredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
//after creating the user , create a new document for the user in the users collection
      _firestore.collection('users').doc(usercredential.user!.uid).set({
        'uid': usercredential.user!.uid,
        'email': email,
      });
      return usercredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out method
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
