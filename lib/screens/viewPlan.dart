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

class ViewPlanPage extends StatefulWidget {
  const ViewPlanPage(
      {super.key, required this.planId, required this.currentUserUid});

  final String planId;
  final String currentUserUid;

  @override
  State<ViewPlanPage> createState() => _ViewPlanPageState();
}

class _ViewPlanPageState extends State<ViewPlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('plan-data')
              .doc(widget.planId)
              .snapshots(),
          builder: (context, snapshot) {
            return Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 2.0,
                    child: Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            snapshot.data?["wallpaper"],
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.width) / 2.0,
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                          bottom: 0,
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade800.withOpacity(0.5)),
                          )),
                      Positioned(
                        bottom: 12,
                        left: 20,
                        child: Text(
                          snapshot.data?["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      )
                    ])),
                SizedBox(
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.width) / 2.0,
                    child: ListView(children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user-data')
                              .doc(snapshot.data?["creator"])
                              .snapshots(),
                          builder: (context, snapshot3) {
                            return BeautifulTap(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              uid: snapshot.data?["creator"],
                                              currentUserUid:
                                                  widget.currentUserUid)));
                                },
                                child: Container(
                                    height: 60,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                              snapshot3.data?["profilePicture"],
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            )),
                                        const SizedBox(width: 20),
                                        Text(
                                          snapshot3.data?["username"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 30),
                                      ],
                                    )));
                          }),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: mySecondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              snapshot.data?["description"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            )),
                      ),
                      const SizedBox(height: 40),
                      const Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            "Trainings:",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: (MediaQuery.of(context).size.width / 2) *
                              snapshot.data?["trainingIds"].length,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?["trainingIds"].length,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('training-data')
                                        .doc(snapshot.data?["trainingIds"]
                                            [index])
                                        .snapshots(),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.hasData &&
                                          snapshot2.data != null) {
                                        return BeautifulTap(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TrainingSlidePage(
                                                            trainingId: snapshot
                                                                        .data?[
                                                                    "trainingIds"]
                                                                [index],
                                                          )));
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 20),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      40,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      20,
                                                  child: Stack(children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          snapshot2.data?[
                                                              "wallpaper"],
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                          height: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  40) /
                                                              2.0,
                                                          fit: BoxFit.cover,
                                                        )),
                                                    Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 100,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: Colors
                                                                  .grey.shade800
                                                                  .withOpacity(
                                                                      0.5)),
                                                        )),
                                                    Positioned(
                                                        bottom: 55,
                                                        left: 20,
                                                        child: Text(
                                                          snapshot2
                                                              .data?["name"],
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    Positioned(
                                                        left: 0,
                                                        bottom: 15,
                                                        child: SizedBox(
                                                            width: 400,
                                                            child: Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .local_fire_department_outlined,
                                                                    color: Colors
                                                                            .yellow[
                                                                        700],
                                                                    size: 25),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "${snapshot2.data?["calories"]} Kcal",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                const SizedBox(
                                                                  width: 40,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .alarm_rounded,
                                                                  size: 25,
                                                                  color: Colors
                                                                          .yellow[
                                                                      700],
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "${snapshot2.data?["minutes"]} min",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                )
                                                              ],
                                                            ))),
                                                  ]),
                                                )));
                                      } else {
                                        return Container();
                                      }
                                    });
                              }))
                    ]))
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        child:
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
