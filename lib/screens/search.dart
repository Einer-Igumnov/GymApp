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
import '../widgets/horizontalSelector.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.currentUserUid});

  final String currentUserUid;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var currentSearchText = "";

  var selectedType = 0;

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
          "Explore",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Column(children: [
        InputContainer(
            color: mySecondaryColor,
            hintText: "Search...",
            icon: Icons.search_rounded,
            textChanged: (text) {
              setState(() {
                currentSearchText = text;
              });
            }),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 45,
          child: HorizontalSelector(
              // класс выбора того, что будет показываться ниже
              textBoxes: const ["Training plans", "People"],
              onChanged: (index) {
                setState(() {
                  selectedType = index;
                });
              },
              enabledColor: myMainColor,
              disabledColor: mySecondaryColor,
              height: 45),
        ),
        const SizedBox(height: 20),
        SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: selectedType == 0
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('plan-data')
                        .orderBy('likes', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (!data["name"]
                                .toLowerCase()
                                .contains(currentSearchText.toLowerCase())) {
                              return Container();
                            }
                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height:
                                      MediaQuery.of(context).size.width / 2 -
                                          20,
                                  child: Stack(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          data["wallpaper"],
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40) /
                                              2.0,
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                        bottom: 0,
                                        child: Container(
                                          height: 110,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
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
                                          data["name"],
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
                                                .doc(data["creator"])
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
                                                          .collection(
                                                              'user-data')
                                                          .doc(widget
                                                              .currentUserUid)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot4) {
                                                        return IconButton(
                                                          icon: snapshot4.data?[
                                                                          "likedPlans"]
                                                                      [document
                                                                          .id] ==
                                                                  null
                                                              ? const Icon(
                                                                  Icons
                                                                      .favorite_outline_rounded,
                                                                  color: Colors
                                                                      .white)
                                                              : const Icon(
                                                                  Icons
                                                                      .favorite_rounded,
                                                                  color: Colors
                                                                      .pink,
                                                                ),
                                                          onPressed: () async {
                                                            if (snapshot4.data?[
                                                                        "likedPlans"]
                                                                    [document
                                                                        .id] ==
                                                                null) {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "user-data")
                                                                  .doc(widget
                                                                      .currentUserUid)
                                                                  .update({
                                                                "likedPlans.${document.id}":
                                                                    1,
                                                              });
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "plan-data")
                                                                  .doc(document
                                                                      .id)
                                                                  .update({
                                                                "likes": FieldValue
                                                                    .increment(
                                                                        1),
                                                              });
                                                            } else {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "user-data")
                                                                  .doc(widget
                                                                      .currentUserUid)
                                                                  .update({
                                                                "likedPlans.${document.id}":
                                                                    FieldValue
                                                                        .delete(),
                                                              });
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "plan-data")
                                                                  .doc(document
                                                                      .id)
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
                                                    "${data["likes"]}",
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
                                                                      document
                                                                          .id,
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
                          }).toList(),
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user-data')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            if (!data["username"]
                                .toLowerCase()
                                .contains(currentSearchText.toLowerCase())) {
                              return Container();
                            }
                            return BeautifulTap(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              uid: document.id,
                                              currentUserUid:
                                                  widget.currentUserUid)));
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
                                              data["profilePicture"],
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            )),
                                        const SizedBox(width: 20),
                                        Text(
                                          data["username"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 30),
                                      ],
                                    )));
                          }).toList(),
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  ))
      ]),
    );
  }
}
