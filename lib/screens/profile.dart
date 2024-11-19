import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/horizontalSelector.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key, required this.uid, required this.currentUserUid});

  final String uid;
  final String currentUserUid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = ""; // имя пользователя
  String profilePictureLink = ""; // ссылка на фотографию профиля
  Map<String, dynamic> userParams = {}; // другие параметры

  void loadUserData() async {
    // Загружаю данные пользователя
    var userData = await FirebaseFirestore.instance
        .collection("user-data")
        .doc(widget.currentUserUid)
        .get();
    setState(() {
      username = userData["username"];
      profilePictureLink = userData["profilePicture"];
      userParams = userData["params"];
      print(userParams);
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
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 38, 39),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            profilePictureLink,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                      const SizedBox(width: 30),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45.0 * userParams.length,
                    child: ListView.builder(
                        // создаю список всех параметров и показываю их
                        itemCount: userParams.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = userParams.keys.elementAt(index);
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4.0),
                            title: Text(
                              key,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            trailing: Text(
                              userParams[key],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          );
                        }),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          SizedBox(
            height: 45,
            child: HorizontalSelector(
                // класс выбора того, что будет показываться ниже
                textBoxes: const [
                  "Exercises",
                  "Trainings",
                  "Training plans",
                  "Posts"
                ],
                onChanged: (index) {},
                enabledColor: const Color.fromARGB(255, 234, 196, 61),
                disabledColor: const Color.fromARGB(255, 38, 38, 39),
                height: 45),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // кнопка добавления
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 234, 196, 61),
        child: const Icon(Icons.add),
      ),
    );
  }
}
