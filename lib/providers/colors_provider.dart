import 'package:flutter/material.dart';

class ColorsProvider extends ChangeNotifier {
  //amber texty
  static const Color color_1 = Color(0xF9FFC107);
  //amber[800] tlačítka, obrysy,linie
  static Color getColor2(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme
        ? Color.fromRGBO(255, 143, 0, 1) // Barva pro dark theme
        : Color.fromARGB(141, 0, 0, 0); // Barva pro light theme
  }

  static Color getColor8(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme
        ? Colors.black
        // Barva pro dark theme
        : Color.fromARGB(146, 255, 255, 255); // Barva pro light theme
  }

  static const Color color_2 = Color.fromARGB(255, 0, 0, 0);

  //white
  static const Color color_3 = Color(0xFFFFFFFF);
  //transparent
  static const Color color_4 = Color(0x00000000);
  //červená pro delete button
  static const Color color_5 = Color.fromARGB(164, 255, 17, 0);
  //white12
  static const Color color_6 = Color(0xB3FFFFFF);
  //black12
  static const Color color_7 = Color(0x1F000000);

  //black
  static const Color color_8 = Colors.black;
  static const Color color_9 = Colors.red;
  //black26
  static const Color color_10 = Colors.black26;
}
