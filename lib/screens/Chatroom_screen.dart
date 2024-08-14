import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  String ChatRoomName;
  String ChatRoomId;

  ChatroomScreen(
      {super.key, required this.ChatRoomName, required this.ChatRoomId});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();

  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      return;
    }
    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender_id": Provider.of<Userprovider>(context, listen: false).userId,
      "sender_name": Provider.of<Userprovider>(context, listen: false).userName,
      "chatroom_id": widget.ChatRoomId,
      "timestamp": FieldValue.serverTimestamp()
    };
    try {
      await db.collection("messages").add(messageToSend);
    } catch (e) {}
    messageText.text = "";
  }

  Widget singleChatItems(
      {required String sender_name,
      required String text,
      required String sender_id}) {
    return Column(
      crossAxisAlignment:
          sender_id == Provider.of<Userprovider>(context, listen: false).userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Text(
          sender_name,
          style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        const SizedBox(height: 3),
        Container(
            decoration: BoxDecoration(
                color: sender_id ==
                        Provider.of<Userprovider>(context, listen: false).userId
                    ? Colors.grey
                    : Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            )),
        const SizedBox(height: 8)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ChatRoomName),
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: db
                  .collection("messages")
                  .where("chatroom_id", isEqualTo: widget.ChatRoomId)
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text('Some error has occur ');
                }
                var allMessages = snapshot.data?.docs ?? [];
                if (allMessages.length < 1) {
                  return const Center(child: Text("No messages here"));
                }

                return ListView.builder(
                    reverse: true,
                    itemCount: allMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: singleChatItems(
                              sender_name: allMessages[index]["sender_name"],
                              text: allMessages[index]["text"],
                              sender_id: allMessages[index]["sender_id"]));
                    });
              },
            )),
            Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageText,
                      decoration: const InputDecoration(
                        hintText: "write message here...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: sendMessage,
                      child: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
