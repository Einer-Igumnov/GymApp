import 'package:flutter/material.dart';

typedef StringCallback = void Function(String val);

class InputContainer extends StatefulWidget {
  const InputContainer(
      {super.key,
      required this.color,
      required this.hintText,
      required this.icon,
      required this.textChanged});

  final Color? color;
  final String? hintText;
  final IconData? icon;
  final StringCallback textChanged;

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        width: MediaQuery.of(context).size.width - 40,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: Center(
            child: ListTile(
          leading: Icon(widget.icon),
          title: TextField(
            decoration: InputDecoration(hintText: widget.hintText),
            onChanged: (val) {
              widget.textChanged(val);
            },
          ),
        )));
  }
}
