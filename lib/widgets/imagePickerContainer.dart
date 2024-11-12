import 'dart:typed_data';

import 'package:flutter/material.dart';
import './beautifulTap.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

typedef ImageCallback = void Function(String);

class ImagePickerContainer extends StatefulWidget {
  const ImagePickerContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.color,
      required this.onImageChanged});

  final double height;
  final double width;
  final Color? color;
  final ImageCallback onImageChanged;

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  bool picked = false;

  var uploadImage;

  selectImage() async {
    var result = await FilePicker.platform
        .pickFiles(type: FileType.image); // выбираю изображение
    if (result != null) {
      setState(() {
        picked = true;
        uploadImage = result.files.single.path; // получаю путь к файлу
        print(uploadImage);
        widget.onImageChanged(
            uploadImage); // отправляю callback о том что фотография изменилась
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeautifulTap(
        onTap: () {
          selectImage();
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: picked
                  ? Image.file(
                      File(uploadImage),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
            )));
  }
}
