import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:globalchat/screens/Splash_Screen.dart';

class SignupController {
  static Future<void> createAccount(
      {required context,
      required String email,
      required String password,
      required String name,
      required String country}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var userId = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        "name": name,
        "country": country,
        "email": email,
        "id": userId.toString()
      };
      try {
        await db.collection("users").doc(userId.toString()).set(data);
      } catch (e) {
        print(e);
      }

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const SplashScreen();
      }), (route) {
        return false;
      });
    } catch (e) {
      SnackBar messageSnackBar =
          SnackBar(backgroundColor: Colors.red, content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);

      print(e);
    }
  }
}