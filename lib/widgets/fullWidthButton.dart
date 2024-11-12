import 'package:flutter/material.dart';
import './beautifulTap.dart';

class FullWidthButton extends StatefulWidget {
  const FullWidthButton(
      {super.key,
      required this.text,
      required this.color,
      required this.textColor,
      required this.onPressed});

  final String text;
  final Color? color;
  final Color? textColor;
  final Function onPressed;

  @override
  State<FullWidthButton> createState() => _FullWidthButtonState();
}

class _FullWidthButtonState extends State<FullWidthButton> {
  final bool _isDown = false;
  @override
  Widget build(BuildContext context) {
    return BeautifulTap(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 60,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.textColor),
          ))),
    );
  }
}
