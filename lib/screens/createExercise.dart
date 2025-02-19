import 'package:flutter/material.dart';
import '../widgets/fullWidthButton.dart';
import '../widgets/inputContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/imagePickerContainer.dart';
import '../constants.dart';
import '../methods/firebaseMethods.dart';
import '../screens/homeScreen.dart';
import 'package:file_picker/file_picker.dart';

class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({super.key, required this.uid});

  final String uid;

  @override
  State<CreateExercisePage> createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  var exerciseVideo;

  String exerciseName = "";

  bool uploadingStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Create an exercise",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Stack(children: [
        Column(children: [
          const SizedBox(height: 20),
          InputContainer(
            color: const Color.fromARGB(255, 38, 38, 39),
            hintText: "Select exercise name...",
            icon: Icons.abc,
            textChanged: (val) {
              exerciseName = val;
            },
          ),
          const SizedBox(
            height: 40,
          ),
          ImagePickerContainer(
              onImageChanged: (val) {
                exerciseVideo = val;
              },
              pickType: FileType.video,
              height: MediaQuery.of(context).size.width - 120,
              width: MediaQuery.of(context).size.width - 120,
              color: const Color.fromARGB(255, 38, 38, 39)),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click to pick exercise video",
            style: TextStyle(fontSize: 17),
          ),
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
                  if (exerciseName == "" ||
                      exerciseVideo == null ||
                      uploadingStatus) {
                    return;
                  }

                  setState(() {
                    uploadingStatus = true;
                  });

                  String exerciseVideoUrl =
                      await uploadImage(exerciseVideo, "videos");

                  String exerciseId =
                      "${DateTime.now().microsecondsSinceEpoch}";

                  await FirebaseFirestore.instance
                      .collection("exercise-data")
                      .doc(exerciseId)
                      .set({
                    "name": exerciseName,
                    "videoLink": exerciseVideoUrl
                  });

                  await FirebaseFirestore.instance
                      .collection("user-data")
                      .doc(widget.uid)
                      .update({
                    "exercises": FieldValue.arrayUnion([exerciseId])
                  });

                  Navigator.pop(context);
                })),
      ]),
    );
  }
}
