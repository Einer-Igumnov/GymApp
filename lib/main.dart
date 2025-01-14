import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'school_lessons.dart';
import 'screens/profile.dart';
import 'screens/exercise.dart';
import 'screens/trainingSlideScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        // home: const ExercisePage(
        //   exerciseId: "12345",
        //   exerciseParams: {"sets": 5, "reps": 10, "weight": 50},
        //   exerciseIndex: 11,
        //   exerciseNum: 12,
        // )
        home: const TrainingSlidePage(trainingId: "1245332"));
  }
}
