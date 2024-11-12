import 'package:flutter/material.dart';

typedef Callback = void Function();

class BeautifulTap extends StatefulWidget {
  const BeautifulTap({super.key, required this.child, required this.onTap});

  final Widget? child;
  final Callback onTap;

  @override
  State<BeautifulTap> createState() => _BeautifulTapState();
}

class _BeautifulTapState extends State<BeautifulTap> {
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
          widget.onTap();
        },
        child: Focus(
            child: Opacity(opacity: _isDown ? 0.9 : 1.0, child: widget.child)));
  }
}
