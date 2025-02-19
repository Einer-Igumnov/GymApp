import 'package:flutter/material.dart';
import '../widgets/fullWidthButton.dart';
import '../widgets/inputContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/imagePickerContainer.dart';
import '../constants.dart';
import '../methods/firebaseMethods.dart';
import '../screens/homeScreen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.uid});

  final String uid;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String username = "";
  bool isUsernameValid = false;

  void checkUsername() async {
    // Функция проверки, что имя не занято другим пользователем
    if (username.length < 3) {
      // проверяю, что длина имени хотябы 3
      setState(() {
        isUsernameValid = false;
      });
      return;
    }
    setState(() {
      isUsernameValid = true;
    });

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user-data')
        .get(); // задаю путь к данным пользователей
    for (var doc in querySnapshot.docs) {
      // проверяю, что имя пользователя не занято
      if (doc['username'] == username) {
        setState(() {
          isUsernameValid = false;
        });
        break;
      }
    }
  }

  var profilePicture; // путь к файлу выбранной аватарки

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Fill in account data",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: Stack(children: [
        Column(children: [
          const SizedBox(height: 20),
          InputContainer(
            color: const Color.fromARGB(255, 38, 38, 39),
            hintText: "Select username...",
            icon: Icons.account_circle_outlined,
            textChanged: (val) {
              username = val;
              checkUsername(); // обновляю значение валидности имени
            },
          ),
          Padding(
              padding: const EdgeInsets.only(left: 45, top: 10),
              child: Row(children: [
                Text(
                  isUsernameValid
                      ? "Valid username"
                      : "Invalid username", // отображаю, если имя пользователя не подходит
                  style: TextStyle(
                      fontSize: 15,
                      color: isUsernameValid ? Colors.green : Colors.red),
                )
              ])),
          const SizedBox(
            height: 40,
          ),
          ImagePickerContainer(
              onImageChanged: (val) {
                profilePicture = val;
              },
              height: MediaQuery.of(context).size.width - 120,
              width: MediaQuery.of(context).size.width - 120,
              color: const Color.fromARGB(255, 38, 38, 39)),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Click to pick your profile picture",
            style: TextStyle(fontSize: 17),
          ),
        ]),
        Positioned(
            bottom: 20,
            child: FullWidthButton(
                text: "Register",
                color: myMainColor,
                textColor: Colors.white,
                onPressed: () async {
                  if (!isUsernameValid || profilePicture == null) {
                    return;
                  }
                  String profilePictureUrl = await uploadImage(profilePicture,
                      "profilePictures"); // загружаю изображение в хранилище
                  print(profilePictureUrl);

                  await FirebaseFirestore.instance
                      .collection("user-data")
                      .doc(widget.uid)
                      .set({
                    "username": username,
                    "profilePicture": profilePictureUrl
                  }); // загружаю данные пользователя в базу данных

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage())); // перехожу на домашнюю страницу
                })),
      ]),
    );
  }
}
