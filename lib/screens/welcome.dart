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
          Image.asset(
            "lib/assets/images/wallpaper.jfif",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.6),
          ),
          Align(
              alignment: Alignment(0.0, -0.3),
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 3 / 15,
                child: Image.asset(
                  "lib/assets/images/grind-logo.png",
                  width: MediaQuery.of(context).size.width * 3 / 5,
                  fit: BoxFit.fitWidth,
                ),
              )),
          Positioned(bottom: 30, child: GoogleSignInButton())
        ],
      ),
    );
  }
}
