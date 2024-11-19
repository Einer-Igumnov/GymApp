import 'package:flutter/material.dart';
import './beautifulTap.dart';

typedef IndexCallback = void Function(int);

class HorizontalSelector extends StatefulWidget {
  const HorizontalSelector(
      {super.key,
      required this.textBoxes,
      required this.onChanged,
      required this.enabledColor,
      required this.disabledColor,
      required this.height});

  final List<String> textBoxes;
  final IndexCallback onChanged;
  final Color? disabledColor;
  final Color? enabledColor;
  final double height;

  @override
  State<HorizontalSelector> createState() => _HorizontalSelectorState();
}

class _HorizontalSelectorState extends State<HorizontalSelector> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.textBoxes.length,
        itemBuilder: (BuildContext context, int index) {
          return BeautifulTap(
              onTap: () {
                // при нажатии на кнопку, меняется выбранный элемент
                setState(() {
                  selectedIndex = index;
                  widget.onChanged(index); // посылаю callback
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: index == 0 ? 20 : 5, right: 5),
                height: widget.height,
                decoration: BoxDecoration(
                  color: index == selectedIndex
                      ? widget.enabledColor
                      : widget
                          .disabledColor, // меняю цвет в зависимости от выбранного
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "   ${widget.textBoxes[index]}   ",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ));
        });
  }
}
