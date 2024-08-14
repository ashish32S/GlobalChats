import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/Dashboard_Screen.dart';
import 'package:globalchat/screens/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    //check  user login status
    Future.delayed(const Duration(seconds: 3), () {
      if (user == null) {
        openLogin();
      } else {
        openDashboard();
      }
    });

    super.initState();
  }

  void openDashboard() {
    Provider.of<Userprovider>(context, listen: false).getUserDetails();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const DashboardScreen();
    }));
  }

  void openLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              child: Image.asset("assets/images/splash.png"),
            ),
          ),
        ],
      ),
    );
  }
}
