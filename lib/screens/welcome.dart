// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import '../widgets/googleButton.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
              alignment: Alignment(0.0, -0.3),
              child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2 + 60,
                  child: Column(
                    children: [
                      Image.asset(
                        "lib/assets/images/app_logo.png",
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        "Welcome to GymApp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))),
          Positioned(bottom: 30, child: GoogleSignInButton())
        ],
      ),
    );
  }
}
