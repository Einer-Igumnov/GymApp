import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'school_lessons.dart';
import 'screens/profile.dart';
import 'screens/exercise.dart';
import 'screens/trainingSlideScreen.dart';
import 'screens/createTraining.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
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
      home: const WelcomePage(),
    );
  }
}
