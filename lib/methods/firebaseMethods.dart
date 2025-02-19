import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImage(String image, String path) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  Reference reference = storage.ref().child(
      "$path/${DateTime.now().millisecondsSinceEpoch}"); // в качестве имени файла выбираю значение времени в миллисекундах

  await reference.putFile(File(image)); // загружаю файл в облачное хранилище

  String url = await reference.getDownloadURL(); // получаю ссылку на файл
  return url;
}
