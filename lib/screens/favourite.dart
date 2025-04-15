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

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key, required this.currentUserUid});

  final String currentUserUid;

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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
          "Favourite",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user-data')
            .doc(widget.currentUserUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var userPlanIds = [];
            snapshot.data?['likedPlans'].keys
                .forEach((k) => userPlanIds.add(k));
            print(userPlanIds.runtimeType);
            return ListView.builder(
                itemCount: userPlanIds.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('plan-data')
                          .doc(userPlanIds[index])
                          .snapshots(),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData && snapshot2.data != null) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                height:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                child: Stack(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        snapshot2.data?["wallpaper"],
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        height:
                                            (MediaQuery.of(context).size.width -
                                                    40) /
                                                2.0,
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      bottom: 0,
                                      child: Container(
                                        height: 110,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey.shade800
                                                .withOpacity(0.5)),
                                      )),
                                  Positioned(
                                      bottom: 65,
                                      left: 20,
                                      child: Text(
                                        snapshot2.data?["name"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Positioned(
                                      bottom: 10,
                                      left: 20,
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('user-data')
                                              .doc(snapshot2.data?["creator"])
                                              .snapshots(),
                                          builder: (context, snapshot3) {
                                            return Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      snapshot3.data?[
                                                          "profilePicture"],
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                    )),
                                                const SizedBox(width: 10),
                                                Text(
                                                  snapshot3.data?["username"],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(width: 30),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('user-data')
                                                        .doc(widget
                                                            .currentUserUid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot4) {
                                                      return IconButton(
                                                        icon: snapshot4.data?[
                                                                        "likedPlans"]
                                                                    [
                                                                    userPlanIds[
                                                                        index]] ==
                                                                null
                                                            ? const Icon(
                                                                Icons
                                                                    .favorite_outline_rounded,
                                                                color: Colors
                                                                    .white)
                                                            : const Icon(
                                                                Icons
                                                                    .favorite_rounded,
                                                                color:
                                                                    Colors.pink,
                                                              ),
                                                        onPressed: () async {
                                                          if (snapshot4.data?[
                                                                      "likedPlans"]
                                                                  [userPlanIds[
                                                                      index]] ==
                                                              null) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "user-data")
                                                                .doc(widget
                                                                    .currentUserUid)
                                                                .update({
                                                              "likedPlans.${userPlanIds[index]}":
                                                                  1,
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "plan-data")
                                                                .doc(
                                                                    userPlanIds[
                                                                        index])
                                                                .update({
                                                              "likes": FieldValue
                                                                  .increment(1),
                                                            });
                                                          } else {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "user-data")
                                                                .doc(widget
                                                                    .currentUserUid)
                                                                .update({
                                                              "likedPlans.${userPlanIds[index]}":
                                                                  FieldValue
                                                                      .delete(),
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "plan-data")
                                                                .doc(
                                                                    userPlanIds[
                                                                        index])
                                                                .update({
                                                              "likes": FieldValue
                                                                  .increment(
                                                                      -1),
                                                            });
                                                          }
                                                        },
                                                      );
                                                    }),
                                                Text(
                                                  "${snapshot2.data?["likes"]}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(width: 30),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewPlanPage(
                                                                currentUserUid:
                                                                    widget
                                                                        .currentUserUid,
                                                                planId:
                                                                    userPlanIds[
                                                                        index],
                                                              )),
                                                    );
                                                  },
                                                  child: const Row(children: [
                                                    Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "View",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    )
                                                  ]),
                                                )
                                              ],
                                            );
                                          })),
                                ]),
                              ));
                        } else {
                          return Container();
                        }
                      });
                });
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
