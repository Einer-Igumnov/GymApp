import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/horizontalSelector.dart';
import './exercise.dart';

class TrainingSlidePage extends StatefulWidget {
  const TrainingSlidePage({super.key, required this.trainingId});

  final String trainingId;

  @override
  State<TrainingSlidePage> createState() => _TrainingSlidePageState();
}

class _TrainingSlidePageState extends State<TrainingSlidePage> {
  var exercises = [];

  int currentExercise = 1;

  void loadUserData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("training-data")
        .doc(widget.trainingId)
        .collection("exercises")
        .get();
    setState(() {
      exercises.addAll(snapshot.docs);
    });
    print(snapshot);
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: exercises.isEmpty
            ? const Center(child: Text("Loading..."))
            : Stack(alignment: Alignment.center, children: [
                PageView.builder(
                    itemCount: exercises.length,
                    controller: PageController(viewportFraction: 1),
                    onPageChanged: (pageIndex) {
                      setState(() {
                        currentExercise = pageIndex + 1;
                      });
                    },
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return ExercisePage(
                        exerciseId: exercises[itemIndex]["exerciseId"],
                        exerciseParams: {
                          "sets": exercises[itemIndex]["sets"],
                          "reps": exercises[itemIndex]["reps"],
                          "weight": exercises[itemIndex]["weight"]
                        },
                      );
                    }),
                Positioned(
                    top: 120,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(children: [
                          Container(
                            height: 7,
                            width: MediaQuery.of(context).size.width - 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(children: [
                              Container(
                                height: 7,
                                width:
                                    (MediaQuery.of(context).size.width - 120) *
                                        currentExercise /
                                        exercises.length,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 234, 196, 61),
                                    borderRadius: BorderRadius.circular(20)),
                              )
                            ]),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$currentExercise/${exercises.length}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ]))),
                const Positioned(
                  top: 50,
                  child: Text(
                    "Training",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 32),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.stop_rounded),
                    ))
              ]));
  }
}
