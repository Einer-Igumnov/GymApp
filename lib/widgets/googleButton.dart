import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/homeScreen.dart';
import './beautifulTap.dart';
import '../screens/registartion.dart';
import '../screens/profile.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  void onButtonPressed() async {
    UserCredential? user = await signInWithGoogle();
    if (user == null) {
      return;
    }
    String uid = user.user!.uid;
    var document =
        await FirebaseFirestore.instance.collection("user-data").doc(uid).get();

    print(uid);

    if (!document.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrationPage(
                  uid: uid,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  currentUserUid: uid,
                )),
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('SignInFailed $e');
      throw Exception('SignInFailed $e');
    }
  }

  final bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return BeautifulTap(
        onTap: () {
          onButtonPressed();
        },
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
        ));
  }
}
