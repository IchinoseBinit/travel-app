import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/infrastructure/services/firebase/firebase_manager.dart';
import 'package:travel_app/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String tripId;
  final String tripTitle;

  ChatScreen({required this.tripId, required this.tripTitle});
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  String messageId = "";
  final messageController = TextEditingController();
  String chatRoomId = "";
  late Future oldMessageFuture;

  addMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final message = messageController.text.trim();
      final dateTime = DateTime.now();

      final content = {
        "message": message,
        "dateTime": DateTime.now().toIso8601String(),
        "sender": FirebaseAuth.instance.currentUser?.uid,
        "userName": FirebaseAuth.instance.currentUser?.displayName,
        "tripId": widget.tripId,
      };

      await FirebaseManager().addData(
        context,
        collectionId: "messages",
        map: content,
        // isPop: false
      );

      messageController.text = "";
      messageId = "";
    }
  }

  @override
  initState() {
    super.initState();
  }

  Widget buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseManager().getStreamWithWhere(
            collectionId: "messages",
            whereId: "tripId",
            whereValue: widget.tripId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          try {
            // print(snapshot.data.runtimeType.);
            final data = (snapshot.data as QuerySnapshot).docs;
            print(data.length);
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.08,
                top: 10,
              ),
              itemCount: data.length,
              // itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (context, index) {
                final message = data[index];
                return buildMessageTile(
                    message["message"],
                    message["sender"] == FirebaseAuth.instance.currentUser?.uid,
                    message["userName"] ?? "");
              },
            );
          } catch (ex) {
            print(ex.toString());
            return Text("something is wrong");
          }
        });
  }

  Widget buildMessageTile(String message, bool isSendByMe, String senderName) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment:
                isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: isSendByMe
                    ? const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      )
                    : const BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: isSendByMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          senderName,
          style: TextStyle(
            fontSize: 10,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripTitle),
        elevation: 3,
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              buildMessagesList(),
              Container(
                alignment: Alignment.bottomCenter,
                // color: Colors.white,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                      width: 0.5,
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.black87),
                            contentPadding: EdgeInsets.all(4),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await addMessage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.send),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
