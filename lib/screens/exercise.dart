import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage(
      {super.key,
      required this.exerciseId,
      required this.exerciseParams,
      required this.exerciseIndex,
      required this.exerciseNum});

  final String exerciseId;
  final Map<String, dynamic>
      exerciseParams; // параметры упражнения, меняющиеся в зависимости от тренировки
  final int exerciseIndex;
  final int exerciseNum;

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String exerciseName = "";
  String exerciseVideoLink = "";

  late VideoPlayerController _controller; // контроллер видео
  bool videoLoaded = false;

  void loadUserData() async {
    // получаем данные упражнения
    var exerciseData = await FirebaseFirestore.instance
        .collection("exercise-data")
        .doc(widget.exerciseId)
        .get();
    setState(() {
      exerciseName = exerciseData["name"];
      exerciseVideoLink = exerciseData["videoLink"];
      print(exerciseVideoLink);
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(exerciseData["videoLink"]))
            ..initialize().then((_) {
              setState(() {
                videoLoaded = true;
              });
              _controller.setLooping(true); // устанавливаю зацикливание
              _controller.play();
            });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      Center(
        child: videoLoaded
            ? AspectRatio(
                // виджет для сохранения пропорций видео
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      const Positioned(
        top: 50,
        child: Text(
          "Training",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32),
        ),
      ),
      const Positioned(
        top: 50,
        child: Text(
          "Training",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32),
        ),
      ),
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
                      width: (MediaQuery.of(context).size.width - 120) *
                          widget.exerciseIndex /
                          widget.exerciseNum,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 234, 196, 61),
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ]),
                ),
                const SizedBox(width: 10),
                Text(
                  "${widget.exerciseIndex}/${widget.exerciseNum}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                )
              ]))),
      Positioned(
          bottom: 0,
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 30,
                  child: Text(
                    exerciseName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                ),
                Positioned(
                    top: 70,
                    left: 15,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: const Icon(
                          Icons.replay,
                          color: Color.fromARGB(255, 234, 196, 61),
                        ),
                        title: Text(
                            "${widget.exerciseParams["sets"]} by ${widget.exerciseParams["reps"]}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                    )),
                widget.exerciseParams["weight"] != null
                    ? Positioned(
                        top: 110,
                        left: 15,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            leading: const Icon(
                              Icons.fitness_center_rounded,
                              color: Color.fromARGB(255, 234, 196, 61),
                            ),
                            title: Text("${widget.exerciseParams["weight"]} kg",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)),
                          ),
                        ))
                    : const Text("")
              ],
            ),
          ))
    ]));
  }
}
