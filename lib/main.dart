import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'school_lessons.dart';

void main() async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDT2i-mQ4KJfvVdEPsKeumblaUw8d0Q9w8",
          authDomain: "gym-app-239.firebaseapp.com",
          projectId: "gym-app-239",
          storageBucket: "gym-app-239.appspot.com",
          messagingSenderId: "910705401159",
          appId: "1:910705401159:web:0fe383b568e1022a184062",
          measurementId: "G-NTH9RPGZXB"));
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
