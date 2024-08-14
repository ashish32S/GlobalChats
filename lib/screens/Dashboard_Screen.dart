import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:globalchat/screens/Chatroom_screen.dart';
import 'package:globalchat/screens/Profile_Screen.dart';
import 'package:globalchat/screens/Splash_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var Scaffoldkey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> chatroomsList = [];
  List<String> chatRoomId = [];
  void getChatrooms() {
    try {
      db.collection("chatrooms").get().then((dataSnapshot) {
        for (var singleChatroomData in dataSnapshot.docs) {
          chatroomsList.add(singleChatroomData.data());
          chatRoomId.add(singleChatroomData.id.toString());
        }
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getChatrooms();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var userProvider = Provider.of<Userprovider>(context);
    return Scaffold(
        key: Scaffoldkey,
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Global Chat'),
          leading: InkWell(
            onTap: () {
              Scaffoldkey.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    (userProvider.userName != null &&
                            userProvider.userName.isNotEmpty)
                        ? userProvider.userName[0].toUpperCase()
                        : 'N/A',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ),
        drawer: Drawer(
            child: Container(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ProfileScreen();
                      }),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text(
                        (userProvider.userName != null &&
                                userProvider.userName.isNotEmpty)
                            ? userProvider.userName[0].toUpperCase()
                            : 'N/A',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(userProvider.userName,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  subtitle: Text(userProvider.userEmail)),
              const SizedBox(height: 20),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const ProfileScreen();
                    }),
                  );
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const SplashScreen();
                  }), (route) {
                    return false;
                  });
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              )
            ],
          ),
        )),
        body: ListView.builder(
            itemCount: chatroomsList.length,
            itemBuilder: (BuildContext context, int index) {
              String chatroomList = chatroomsList[index]["chatroom_name"] ?? "";
              return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatroomScreen(
                        ChatRoomName: chatroomList,
                        ChatRoomId: chatRoomId[index]);
                  }));
                },
                leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(chatroomList[0].toUpperCase()),
                    foregroundColor: Colors.white),
                title: Text(chatroomList),
                subtitle: Text(chatroomsList[index]["desc"] ?? ""),
              );
            }));
  }
}
