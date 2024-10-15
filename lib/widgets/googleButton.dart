import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/homeScreen.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  void onButtonPressed() async {
    User? user = await signInWithGoogle();
    if (user == null) {
      return;
    }
    String uid = user.uid;
    var document =
        await FirebaseFirestore.instance.collection("user-data").doc(uid).get();

    if (document.exists) {
      // user log in - go to home page
    } else {
      // new user - go to account creation page
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<User?> signInWithGoogle() async {
    await Firebase.initializeApp();
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
          await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    return user;
  }

  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isDown = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _isDown = false;
          });
        },
        onTap: () {
          setState(() {
            _isDown = false;
          });
          onButtonPressed();
        },
        child: Focus(
            child: Opacity(
                opacity: _isDown ? 0.9 : 1.0,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 60,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(children: [
                    Positioned(
                        top: 12,
                        left: 15,
                        child: Image.asset(
                          "lib/assets/images/google_icon.png",
                          height: 36,
                          fit: BoxFit.fitHeight,
                        )),
                    const Center(
                      child: Text("Sign in with Google",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  ]),
                ))));
  }
}
