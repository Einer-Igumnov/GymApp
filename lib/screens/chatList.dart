import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grehuorigehuorge/screens/chat.dart';
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

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key, required this.currentUserUid});

  final String currentUserUid;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 80,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "Chats",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user-data')
              .doc(widget.currentUserUid)
              .collection("chat-list")
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user-data')
                          .doc(document.id)
                          .snapshots(),
                      builder: (context, snapshot1) {
                        if (snapshot1.hasData && snapshot1.data != null) {
                          return BeautifulTap(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                              uid: document.id,
                                              currentUserUid:
                                                  widget.currentUserUid,
                                            )));
                              },
                              child: Container(
                                  height: 60,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    color: mySecondaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            snapshot1.data?["profilePicture"],
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          )),
                                      const SizedBox(width: 20),
                                      Text(
                                        snapshot1.data?["username"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 30),
                                    ],
                                  )));
                        }
                        return Container();
                      });
                }).toList(),
              );
            } else {
              return const Text("");
            }
          },
        ));
  }
}
