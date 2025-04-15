import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grehuorigehuorge/screens/profile.dart';
import 'package:grehuorigehuorge/screens/trainingSlideScreen.dart';
import '../widgets/fullWidthButton.dart';
import '../widgets/inputContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/imagePickerContainer.dart';
import '../constants.dart';
import '../methods/firebaseMethods.dart';
import '../screens/homeScreen.dart';
import '../widgets/beautifulTap.dart';
import 'dart:io';
import './viewPlan.dart';
import 'package:collection/collection.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.currentUserUid, required this.uid});

  final String currentUserUid;
  final String uid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String currentMessage = "";
  final _controller = TextEditingController();

  String chatName = "";

  @override
  void initState() {
    var userIds = [widget.uid, widget.currentUserUid];
    userIds.sort(compareNatural);
    setState(() {
      chatName = "${userIds[0]}-${userIds[1]}";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user-data')
                .doc(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data?["username"],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              );
            }),
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user-data')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      snapshot.data?["profilePicture"],
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ));
              }),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 190,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat-data")
                      .doc(chatName)
                      .collection("messages")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Row(
                              mainAxisAlignment:
                                  data["author"] == widget.currentUserUid
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                /*
                            SizedBox(
                              width: 10,
                            ),
                            Image.network(
                              seli != 1
                                  ? "images/avatars/${snapshot.data.documents[index]['ava']}b.png"
                                  : "images/avatars/hack.png",
                              height: 70,
                            ),
                            SizedBox(
                              width: 10,
                            ),*/
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: data["author"] ==
                                              widget.currentUserUid
                                          ? myMainColor
                                          : mySecondaryColor,
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                            alignment: const Alignment(0, 0),
                                            child: Text(
                                              "   ${data["text"]}   ",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ))
                                      ],
                                    ))
                              ]);
                        }).toList(),
                      );
                    } else {
                      return const Text("");
                    }
                  },
                ),
              )),
          Positioned(
            bottom: 10,
            child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: mySecondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: Center(
                    child: Row(
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 130,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              hintText: "Write a message..."),
                          onChanged: (val) {
                            currentMessage = val;
                          },
                        )),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () async {
                          int messageTime =
                              DateTime.now().millisecondsSinceEpoch;
                          await FirebaseFirestore.instance
                              .collection("chat-data")
                              .doc(chatName)
                              .collection("messages")
                              .doc("$messageTime")
                              .set({
                            "time": messageTime,
                            "text": currentMessage,
                            "type": "text",
                            "author": widget.currentUserUid
                          });
                          await FirebaseFirestore.instance
                              .collection("user-data")
                              .doc(widget.currentUserUid)
                              .collection("chat-list")
                              .doc(widget.uid)
                              .set({"time": messageTime});
                          await FirebaseFirestore.instance
                              .collection("user-data")
                              .doc(widget.uid)
                              .collection("chat-list")
                              .doc(widget.currentUserUid)
                              .set({"time": messageTime});
                          _controller.clear();
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: myMainColor,
                        ))
                  ],
                ))),
          )
        ],
      ),
    );
  }
}
