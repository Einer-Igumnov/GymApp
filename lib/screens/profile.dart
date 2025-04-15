import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grehuorigehuorge/constants.dart';
import 'package:grehuorigehuorge/screens/trainingSlideScreen.dart';
import '../widgets/horizontalSelector.dart';
import './createExercise.dart';
import 'chat.dart';
import 'createTraining.dart';
import '../widgets/beautifulTap.dart';
import './createPlan.dart';
import './viewPlan.dart';
import '../widgets/bottomNavBar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'welcome.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.uid,
      required this.currentUserUid,
      this.allowEdit = false});

  final String uid;
  final String currentUserUid;
  final bool allowEdit;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var selectedType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: !widget.allowEdit,
        actions: widget.allowEdit
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await GoogleSignIn().signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()));
                  },
                )
              ]
            : [],
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: mySecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user-data')
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return Row(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    snapshot.data?["profilePicture"],
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )),
                              const SizedBox(width: 30),
                              Text(
                                snapshot.data?["username"],
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ]);
                          })
                    ],
                  ),
                  !widget.allowEdit && widget.currentUserUid != widget.uid
                      ? Positioned(
                          right: 12.5,
                          top: 12.5,
                          child: FloatingActionButton(
                              elevation: 0,
                              backgroundColor: mySecondaryColor,
                              child: const Icon(Icons.mode_comment_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                              uid: widget.uid,
                                              currentUserUid:
                                                  widget.currentUserUid,
                                            )));
                              }),
                        )
                      : Container()
                ],
              )),
          const SizedBox(height: 20),
          widget.allowEdit
              ? SizedBox(
                  height: 45,
                  child: HorizontalSelector(
                      // класс выбора того, что будет показываться ниже
                      textBoxes: const [
                        "Training plans",
                        "Trainings",
                        "Exercises"
                      ],
                      onChanged: (index) {
                        setState(() {
                          selectedType = index;
                        });
                      },
                      enabledColor: myMainColor,
                      disabledColor: mySecondaryColor,
                      height: 45),
                )
              : Container(),
          widget.allowEdit ? const SizedBox(height: 20) : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height -
                290 +
                (widget.allowEdit ? 0 : 65),
            child: selectedType == 2
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user-data')
                        .doc(widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var userExerciseIds = snapshot.data?['exercises'];
                        print(userExerciseIds.length);
                        return ListView.builder(
                            itemCount: userExerciseIds.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('exercise-data')
                                      .doc(userExerciseIds[index])
                                      .snapshots(),
                                  builder: (context, snapshot2) {
                                    if (snapshot2.hasData &&
                                        snapshot2.data != null) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        height: 60,
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 10),
                                        decoration: BoxDecoration(
                                          color: mySecondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                            child: Row(children: [
                                          const SizedBox(width: 20),
                                          Text(
                                            "${snapshot2.data?["name"]}",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          )
                                        ])),
                                      );
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
                  )
                : selectedType == 1
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user-data')
                            .doc(widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            var userPlanIds = snapshot.data?['trainings'];
                            print(userPlanIds.length);
                            return ListView.builder(
                                itemCount: userPlanIds.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('training-data')
                                          .doc(userPlanIds[index])
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
                                                              trainingId:
                                                                  userPlanIds[
                                                                      index],
                                                            )));
                                              },
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 20),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            40,
                                                    height:
                                                        MediaQuery.of(context)
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
                                                                    .grey
                                                                    .shade800
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
                                                                color: Colors
                                                                    .white,
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
                                                                      width:
                                                                          10),
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
                                                                      width:
                                                                          10),
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
                                });
                          } else if (snapshot.hasError) {
                            return const CircularProgressIndicator();
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user-data')
                            .doc(widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            var userPlanIds = snapshot.data?['plans'];
                            print(userPlanIds.length);
                            return ListView.builder(
                                itemCount: userPlanIds.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('plan-data')
                                          .doc(userPlanIds[index])
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.hasData &&
                                            snapshot2.data != null) {
                                          return Padding(
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
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        snapshot2
                                                            .data?["wallpaper"],
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
                                                        height: 110,
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
                                                      bottom: 65,
                                                      left: 20,
                                                      child: Text(
                                                        snapshot2.data?["name"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Positioned(
                                                      bottom: 10,
                                                      left: 20,
                                                      child: StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'user-data')
                                                              .doc(snapshot2
                                                                      .data?[
                                                                  "creator"])
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot3) {
                                                            return Row(
                                                              children: [
                                                                ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child: Image
                                                                        .network(
                                                                      snapshot3
                                                                              .data?[
                                                                          "profilePicture"],
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  snapshot3
                                                                          .data?[
                                                                      "username"],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                const SizedBox(
                                                                    width: 30),
                                                                StreamBuilder(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'user-data')
                                                                        .doc(widget
                                                                            .currentUserUid)
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshot4) {
                                                                      return IconButton(
                                                                        icon: snapshot4.data?["likedPlans"][userPlanIds[index]] ==
                                                                                null
                                                                            ? const Icon(Icons.favorite_outline_rounded,
                                                                                color: Colors.white)
                                                                            : const Icon(
                                                                                Icons.favorite_rounded,
                                                                                color: Colors.pink,
                                                                              ),
                                                                        onPressed:
                                                                            () async {
                                                                          if (snapshot4.data?["likedPlans"][userPlanIds[index]] ==
                                                                              null) {
                                                                            await FirebaseFirestore.instance.collection("user-data").doc(widget.currentUserUid).update({
                                                                              "likedPlans.${userPlanIds[index]}": 1,
                                                                            });
                                                                            await FirebaseFirestore.instance.collection("plan-data").doc(userPlanIds[index]).update({
                                                                              "likes": FieldValue.increment(1),
                                                                            });
                                                                          } else {
                                                                            await FirebaseFirestore.instance.collection("user-data").doc(widget.currentUserUid).update({
                                                                              "likedPlans.${userPlanIds[index]}": FieldValue.delete(),
                                                                            });
                                                                            await FirebaseFirestore.instance.collection("plan-data").doc(userPlanIds[index]).update({
                                                                              "likes": FieldValue.increment(-1),
                                                                            });
                                                                          }
                                                                        },
                                                                      );
                                                                    }),
                                                                Text(
                                                                  "${snapshot2.data?["likes"]}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                const SizedBox(
                                                                    width: 30),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ViewPlanPage(
                                                                                planId: userPlanIds[index],
                                                                                currentUserUid: widget.currentUserUid,
                                                                              )),
                                                                    );
                                                                  },
                                                                  child: const Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .remove_red_eye_outlined,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          "View",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
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
          )
        ],
      ),
      floatingActionButton: widget.allowEdit
          ? Container(
              margin: const EdgeInsets.only(bottom: 85, right: 5),
              height: 55,
              width: 55,
              child: FloatingActionButton(
                // кнопка добавления
                onPressed: () {
                  if (selectedType == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateExercisePage(
                                uid: widget.currentUserUid)));
                  } else if (selectedType == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateTrainingPage(
                                uid: widget.currentUserUid)));
                  } else if (selectedType == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreatePlanPage(uid: widget.currentUserUid)));
                  }
                },
                backgroundColor: myMainColor,
                child: const Icon(Icons.add),
              ))
          : Container(),
    );
  }
}
