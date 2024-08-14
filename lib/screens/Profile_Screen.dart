import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/ProfileEdit_Screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 50,
                child: Text(userProvider.userName[0],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold))),
            const SizedBox(height: 25),
            Text(userProvider.userName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userProvider.userEmail),
            const SizedBox(height: 18),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileEditScreen();
                  }));
                },
                child: const Text("Edit Profile"))
          ],
        ),
      ),
    );
  }
}
