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

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({super.key, required this.uid});

  final String uid;

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  String trainingName = "";
  String trainingDescription = "";
  var profilePicture; // путь к файлу выбранной аватарки

  bool uploadingStatus = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var trainings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Create Training Plan",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Stack(children: [
        ListView(children: [
          const SizedBox(height: 20),
          Container(
              height: 70,
              width: MediaQuery.of(context).size.width - 60,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: mySecondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: Center(
                  child: ListTile(
                leading: const Icon(Icons.abc),
                title: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Select training plan name...",
                  ),
                  onChanged: (val) {
                    trainingName = val;
                  },
                ),
              ))),
          const SizedBox(height: 20),
          Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 60,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: mySecondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: Center(
                  child: ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: SizedBox(
                    height: 70,
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 100,
                      decoration: const InputDecoration(
                        hintText: "Select training plan description...",
                      ),
                      onChanged: (val) {
                        trainingDescription = val;
                      },
                    )),
              ))),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ImagePickerContainer(
                  pickType: FileType.media,
                  onImageChanged: (val) {
                    profilePicture = val;
                  },
                  height: (MediaQuery.of(context).size.width - 60) * 0.5,
                  width: MediaQuery.of(context).size.width - 60,
                  color: mySecondaryColor)),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click to pick plan wallpaper",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Plan trainings:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 40),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.width / 2 + 100,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              decoration: BoxDecoration(
                color: mySecondaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(children: [
                Column(children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(children: [
                    Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Add training",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ))
                  ]),
                  const SizedBox(height: 25),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user-data')
                        .doc(widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var userTrainingIds = snapshot.data?['trainings'];
                        print(userTrainingIds.length);
                        return SizedBox(
                            height: MediaQuery.of(context).size.width / 2 - 20,
                            child: PageView.builder(
                                itemCount: userTrainingIds.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('training-data')
                                          .doc(userTrainingIds[index])
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
                                                        height: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            80,
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
                                                        snapshot2.data?["name"],
                                                        style: const TextStyle(
                                                            color: Colors.white,
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
                                                  Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child:
                                                          FloatingActionButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            trainings.add(
                                                                userTrainingIds[
                                                                    index]);
                                                          });
                                                        },
                                                        backgroundColor:
                                                            myMainColor,
                                                        child: const Icon(
                                                            Icons.add),
                                                      )),
                                                ]),
                                              ));
                                        } else {
                                          return Container();
                                        }
                                      });
                                }));
                      } else if (snapshot.hasError) {
                        return const CircularProgressIndicator();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const Text(
                    "Swipe to select",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ]),
              ])),
          const SizedBox(height: 20),
          SizedBox(
              height: trainings.length *
                  (MediaQuery.of(context).size.width / 2 + 20),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trainings.length,
                  itemBuilder: (context, index0) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('training-data')
                            .doc(trainings[index0])
                            .snapshots(),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData && snapshot2.data != null) {
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
                                          snapshot2.data?["wallpaper"],
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
                                          height: 100,
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
                                        bottom: 55,
                                        left: 20,
                                        child: Text(
                                          snapshot2.data?["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
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
                                                    color: Colors.yellow[700],
                                                    size: 25),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${snapshot2.data?["calories"]} Kcal",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 40,
                                                ),
                                                Icon(
                                                  Icons.alarm_rounded,
                                                  size: 25,
                                                  color: Colors.yellow[700],
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "${snapshot2.data?["minutes"]} min",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ))),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            setState(() {
                                              trainings.removeAt(index0);
                                            });
                                          },
                                          backgroundColor: Colors.red,
                                          child:
                                              const Icon(Icons.delete_rounded),
                                        )),
                                  ]),
                                ));
                          } else {
                            return Container();
                          }
                        });
                  })),
          SizedBox(height: MediaQuery.of(context).size.height / 2.0)
        ]),
        Positioned(
            bottom: 20,
            child: FullWidthButton(
                text: uploadingStatus ? "Uploading..." : "Create",
                color: uploadingStatus ? mySecondaryColor : myMainColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (profilePicture == "" ||
                      trainingName == "" ||
                      trainings.isEmpty ||
                      trainingDescription == "" ||
                      uploadingStatus) {
                    return;
                  }

                  setState(() {
                    uploadingStatus = true;
                  });

                  String profilePictureUrl = await uploadImage(profilePicture,
                      "planwallpapers"); // загружаю изображение в хранилище
                  print(profilePictureUrl);

                  var planId = "${DateTime.now().microsecondsSinceEpoch}";

                  await FirebaseFirestore.instance
                      .collection("plan-data")
                      .doc(planId)
                      .set({
                    "name": trainingName,
                    "wallpaper": profilePictureUrl,
                    "creator": widget.uid,
                    "description": trainingDescription,
                    "trainingIds": trainings,
                    "likes": 0,
                  }); // загружаю данные пользователя в базу данных

                  await FirebaseFirestore.instance
                      .collection("user-data")
                      .doc(widget.uid)
                      .update({
                    "plans": FieldValue.arrayUnion([planId])
                  });

                  Navigator.pop(context); // перехожу на домашнюю страницу
                })),
      ]),
    );
  }
}
