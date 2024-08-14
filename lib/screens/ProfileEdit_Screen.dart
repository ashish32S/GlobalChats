
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController nameText = TextEditingController();
  Map<String, dynamic>? userData = {};
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    nameText.text = Provider.of<Userprovider>(context, listen: false).userName;

    // TODO: implement initState
    super.initState();
  }

  void updateData() {
    Map<String, dynamic>? dataUpdated = {
      "name": nameText.text,
    };
    db
        .collection("users")
        .doc(Provider.of<Userprovider>(context, listen: false).userId)
        .update(dataUpdated);
    Provider.of<Userprovider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<Userprovider>(context);
    var editProfileName = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          InkWell(
            onTap: () {
              if (editProfileName.currentState!.validate()) {
                updateData();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Form(
        key: editProfileName,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                  },
                  controller: nameText,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
