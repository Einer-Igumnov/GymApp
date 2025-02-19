import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grehuorigehuorge/constants.dart';
import '../widgets/horizontalSelector.dart';
import './createExercise.dart';
import 'createTraining.dart';
import '../widgets/beautifulTap.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key, required this.uid, required this.currentUserUid});

  final String uid;
  final String currentUserUid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = ""; // имя пользователя
  String profilePictureLink = ""; // ссылка на фотографию профиля
  Map<String, dynamic> userParams = {}; // другие параметры

  void loadUserData() async {
    // Загружаю данные пользователя
    var userData = await FirebaseFirestore.instance
        .collection("user-data")
        .doc(widget.currentUserUid)
        .get();
    setState(() {
      username = userData["username"];
      profilePictureLink = userData["profilePicture"];
      userParams = userData["params"];
      print(userParams);
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  var selectedType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                color: const Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            profilePictureLink,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(width: 30),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45.0 * userParams.length,
                    child: ListView.builder(
                        // создаю список всех параметров и показываю их
                        itemCount: userParams.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = userParams.keys.elementAt(index);
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4.0),
                            title: Text(
                              key,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            trailing: Text(
                              userParams[key],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          );
                        }),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          SizedBox(
            height: 45,
            child: HorizontalSelector(
                // класс выбора того, что будет показываться ниже
                textBoxes: const ["Exercises", "Trainings", "Training plans"],
                onChanged: (index) {
                  setState(() {
                    selectedType = index;
                  });
                },
                enabledColor: const Color.fromARGB(255, 234, 196, 61),
                disabledColor: const Color.fromARGB(255, 38, 38, 39),
                height: 45),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height - 450,
            child: selectedType == 0
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
                                          color: const Color.fromARGB(
                                              255, 38, 38, 39),
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
                            var userExerciseIds = snapshot.data?['trainings'];
                            print(userExerciseIds.length);
                            return ListView.builder(
                                itemCount: userExerciseIds.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('training-data')
                                          .doc(userExerciseIds[index])
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.hasData &&
                                            snapshot2.data != null) {
                                          return SizedBox(
                                              height: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          40) /
                                                      2.0 +
                                                  135,
                                              child: Stack(children: [
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            40,
                                                    height:
                                                        (MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    40) /
                                                                2.0 +
                                                            95,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 50),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 38, 38, 39),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
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
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                                width: 20),
                                                            Text(
                                                              "${snapshot2.data?["name"]}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )),
                                                Positioned(
                                                  top: (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              40) /
                                                          2.0 +
                                                      55,
                                                  right: 30,
                                                  child: Row(children: [
                                                    FloatingActionButton
                                                        .extended(
                                                            backgroundColor:
                                                                myMainColor,
                                                            onPressed: () {},
                                                            label: const Text(
                                                              "View",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                    const SizedBox(width: 10),
                                                    FloatingActionButton
                                                        .extended(
                                                            backgroundColor:
                                                                Colors.pink,
                                                            onPressed:
                                                                () async {
                                                              if (snapshot2.data?[
                                                                              "likesAccounts"]
                                                                          [
                                                                          widget
                                                                              .currentUserUid] !=
                                                                      Null &&
                                                                  snapshot2.data?[
                                                                              "likesAccounts"]
                                                                          [
                                                                          widget
                                                                              .currentUserUid] ==
                                                                      1) {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "training-data")
                                                                    .doc(userExerciseIds[
                                                                        index])
                                                                    .update({
                                                                  "likesNum":
                                                                      FieldValue
                                                                          .increment(
                                                                              -1),
                                                                  "likesAccounts.${widget.currentUserUid}":
                                                                      0
                                                                });
                                                              } else {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "training-data")
                                                                    .doc(userExerciseIds[
                                                                        index])
                                                                    .update({
                                                                  "likesNum":
                                                                      FieldValue
                                                                          .increment(
                                                                              1),
                                                                  "likesAccounts.${widget.currentUserUid}":
                                                                      1
                                                                });
                                                              }
                                                            },
                                                            icon: Icon(
                                                              snapshot2.data?["likesAccounts"][widget
                                                                              .currentUserUid] !=
                                                                          Null &&
                                                                      snapshot2.data?["likesAccounts"][widget
                                                                              .currentUserUid] ==
                                                                          1
                                                                  ? Icons
                                                                      .favorite_rounded
                                                                  : Icons
                                                                      .favorite_outline_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: Text(
                                                              "${snapshot2.data?["likesNum"]}",
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                  ]),
                                                )
                                              ]));
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
                    : const Text(""),
          )
        ],
      ),
      floatingActionButton: widget.currentUserUid == widget.uid
          ? FloatingActionButton(
              // кнопка добавления
              onPressed: () {
                if (selectedType == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateExercisePage(uid: widget.currentUserUid)));
                } else if (selectedType == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateTrainingPage(uid: widget.currentUserUid)));
                }
              },
              backgroundColor: const Color.fromARGB(255, 234, 196, 61),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
