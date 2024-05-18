import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch  (e) {
      _showErrorDialog(context, e.message.toString());
    }
    return null;
  }


  Future<User?> loginUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      _showErrorDialog(context, "Information about the user is not complete or accurate.");
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(
          msg: "Logged out successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on FirebaseAuthException catch  (e) {
      _showErrorDialog(context, e.message.toString());
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('user').doc(user.uid).delete();
        QuerySnapshot hitchhikingSnapshot = await FirebaseFirestore.instance
            .collection("hitchhiking")
            .where('user_id', isEqualTo: user.uid)
            .get();
        for (QueryDocumentSnapshot doc in hitchhikingSnapshot.docs) {
          await FirebaseFirestore.instance.collection("hitchhiking").doc(doc.id).delete();
        }
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    _showErrorDialog(context, errorMessage);
  }
}
