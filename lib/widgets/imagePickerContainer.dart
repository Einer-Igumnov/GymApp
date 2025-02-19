import 'dart:typed_data';

import 'package:flutter/material.dart';
import './beautifulTap.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

typedef ImageCallback = void Function(String);

class ImagePickerContainer extends StatefulWidget {
  ImagePickerContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.color,
      required this.onImageChanged,
      this.pickType = FileType.image});

  final double height;
  final double width;
  final Color? color;
  final ImageCallback onImageChanged;
  var pickType = FileType.image;

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  bool picked = false;

  var uploadImage;
  late VideoPlayerController _controller;
  bool videoLoaded = false;

  selectImage() async {
    var result = await FilePicker.platform
        .pickFiles(type: widget.pickType); // выбираю изображение
    if (result != null) {
      setState(() {
        picked = true;
        uploadImage = result.files.single.path; // получаю путь к файлу
        print(uploadImage);
        widget.onImageChanged(
            uploadImage); // отправляю callback о том что фотография изменилась
        if (widget.pickType == FileType.video) {
          setState(() {
            _controller = VideoPlayerController.file(File(uploadImage))
              ..initialize().then((_) {
                setState(() {
                  videoLoaded = true;
                });
                _controller.setLooping(true); // устанавливаю зацикливание
                _controller.play();
              });
          });
        }
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
              height: !videoLoaded
                  ? widget.height
                  : widget.width / _controller.value.aspectRatio,
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.color,
              ),
              child: picked
                  ? (widget.pickType == FileType.image ||
                          widget.pickType == FileType.media
                      ? Image.file(
                          File(uploadImage),
                          fit: BoxFit.cover,
                        )
                      : AspectRatio(
                          // виджет для сохранения пропорций видео
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ))
                  : const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
            )));
  }
}
