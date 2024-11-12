import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  final ValueChanged<Color> onColorSelected;

  ColorPalette({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            onColorSelected(color); // Pass selected color back
            //Navigator.of(context).pop(); // Close the dialog
          },
          child: CircleAvatar(
            backgroundColor: color,
            radius: 20,
          ),
        );
      }).toList(),
    );
  }
}
