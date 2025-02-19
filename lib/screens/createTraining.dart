import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../widgets/fullWidthButton.dart';
import '../widgets/inputContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/imagePickerContainer.dart';
import '../constants.dart';
import '../methods/firebaseMethods.dart';
import '../screens/homeScreen.dart';
import '../widgets/beautifulTap.dart';
import 'dart:io';

class CreateTrainingPage extends StatefulWidget {
  const CreateTrainingPage({super.key, required this.uid});

  final String uid;

  @override
  State<CreateTrainingPage> createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  String trainingName = "";
  String description = "";
  var profilePicture; // путь к файлу выбранной аватарки

  String currSets = "", currReps = "", currWeight = "";
  String currId = "", currName = "";

  bool uploadingStatus = false;

  var exercises = [];

  void setExerciseName(int index) async {
    var fbSnapshot = await FirebaseFirestore.instance
        .collection("exercise-data")
        .doc(currId)
        .get();
    currName = fbSnapshot["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Create Training",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Stack(children: [
        ListView(children: [
          const SizedBox(height: 20),
          InputContainer(
            color: const Color.fromARGB(255, 38, 38, 39),
            hintText: "Select training name...",
            icon: Icons.abc,
            textChanged: (val) {
              trainingName = val;
            },
          ),
          const SizedBox(height: 20),
          InputContainer(
            color: const Color.fromARGB(255, 38, 38, 39),
            hintText: "Write training description...",
            icon: Icons.edit_rounded,
            textChanged: (val) {
              description = val;
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ImagePickerContainer(
                  pickType: FileType.media,
                  onImageChanged: (val) {
                    profilePicture = val;
                  },
                  height: (MediaQuery.of(context).size.width - 60) * 0.5,
                  width: MediaQuery.of(context).size.width - 60,
                  color: const Color.fromARGB(255, 38, 38, 39))),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click to pick training wallpaper",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Training exercises:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 40),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 350,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(children: [
                      Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            "Add exercise",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
                    const SizedBox(height: 25),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 50,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('user-data')
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              var userExerciseIds = snapshot.data?['exercises'];
                              if (currId == "") {
                                currId = userExerciseIds[0];
                                setExerciseName(0);
                              }
                              print(userExerciseIds.length);
                              return PageView.builder(
                                  onPageChanged: (pageIndex) async {
                                    currId = userExerciseIds[pageIndex];
                                    var fbSnapshot = await FirebaseFirestore
                                        .instance
                                        .collection("exercise-data")
                                        .doc(currId)
                                        .get();
                                    currName = fbSnapshot["name"];
                                  },
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              height: 50,
                                              margin: const EdgeInsets.only(
                                                  left: 25, right: 25),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 48, 48, 49),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                  child: Row(children: [
                                                const SizedBox(width: 20),
                                                Text(
                                                  "${snapshot2.data?["name"]}",
                                                  style: const TextStyle(
                                                      fontSize: 18),
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
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Swipe to select",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        SizedBox(
                            width: 70,
                            child: TextField(
                              onChanged: (text) {
                                currSets = text;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Sets",
                                  contentPadding: EdgeInsets.only(left: 0)),
                            )),
                        const SizedBox(width: 20),
                        const Text(
                          "by",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                            width: 70,
                            child: TextField(
                              onChanged: (text) {
                                currReps = text;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Reps",
                                  contentPadding: EdgeInsets.only(left: 0)),
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(width: 30),
                      SizedBox(
                          width: 100,
                          child: TextField(
                            onChanged: (text) {
                              currWeight = text;
                            },
                            decoration: const InputDecoration(
                                hintText: "Weight",
                                contentPadding: EdgeInsets.only(left: 0)),
                          )),
                    ]),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                    bottom: 30,
                    right: 30,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          exercises.add({
                            "id": currId,
                            "name": currName,
                            "sets": currSets,
                            "reps": currReps,
                            "weight": currWeight
                          });
                        });
                      },
                      backgroundColor: myMainColor,
                      child: const Icon(Icons.add),
                    ))
              ])),
          const SizedBox(height: 40),
          SizedBox(
              height: exercises.length * 180,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 155,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 25),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 38, 38, 39),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(children: [
                          Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      exercises.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.red,
                                    size: 30,
                                  ))),
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(children: [
                                const SizedBox(width: 20),
                                Text(
                                  "${exercises[index]["name"]}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                )
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                const SizedBox(width: 20),
                                Icon(
                                  Icons.fitness_center_rounded,
                                  color: myMainColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${exercises[index]["weight"]}",
                                  style: const TextStyle(fontSize: 18),
                                )
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                const SizedBox(width: 20),
                                Icon(
                                  Icons.alarm_on_rounded,
                                  color: myMainColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${exercises[index]["sets"]} by ${exercises[index]["reps"]}",
                                  style: const TextStyle(fontSize: 18),
                                )
                              ]),
                            ],
                          )
                        ]));
                  })),
          SizedBox(height: MediaQuery.of(context).size.height / 2.0)
        ]),
        Positioned(
            bottom: 20,
            child: FullWidthButton(
                text: uploadingStatus ? "Uploading..." : "Create",
                color: uploadingStatus
                    ? const Color.fromARGB(255, 38, 38, 39)
                    : myMainColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (profilePicture == "" ||
                      trainingName == "" ||
                      description == "" ||
                      exercises.isEmpty ||
                      uploadingStatus) {
                    return;
                  }

                  setState(() {
                    uploadingStatus = true;
                  });

                  String profilePictureUrl = await uploadImage(profilePicture,
                      "trainingwallpapers"); // загружаю изображение в хранилище
                  print(profilePictureUrl);

                  var trainingId = "${DateTime.now().microsecondsSinceEpoch}";

                  await FirebaseFirestore.instance
                      .collection("training-data")
                      .doc(trainingId)
                      .set({
                    "name": trainingName,
                    "description": description,
                    "wallpaper": profilePictureUrl,
                    "creator": widget.uid,
                    "likesNum": 0,
                    "likesAccounts": {}
                  }); // загружаю данные пользователя в базу данных

                  for (int index = 0; index < exercises.length; index++) {
                    await FirebaseFirestore.instance
                        .collection("training-data")
                        .doc(trainingId)
                        .collection("exercises")
                        .add({
                      "exerciseId": exercises[index]["id"],
                      "sets": exercises[index]["sets"],
                      "weight": exercises[index]["weight"],
                      "reps": exercises[index]["reps"],
                    });
                  }

                  await FirebaseFirestore.instance
                      .collection("user-data")
                      .doc(widget.uid)
                      .update({
                    "trainings": FieldValue.arrayUnion([trainingId])
                  });

                  Navigator.pop(context); // перехожу на домашнюю страницу
                })),
      ]),
    );
  }
}
