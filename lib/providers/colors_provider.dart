import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/variables.dart';

Color colorOrange = Color.fromRGBO(255, 143, 0, 1);
Color colorBlue = Color.fromARGB(255, 0, 187, 255);
Color colorRed = Color.fromRGBO(255, 44, 44, 1);
Color colorYellow = Color.fromRGBO(255, 204, 0, 1);
Color colorGreen = Color.fromRGBO(21, 255, 0, 1);
Color colorPurple = Color.fromRGBO(200, 0, 255, 1);
Color colorWhite = Color.fromRGBO(255, 255, 255, 1);

class ColorsProvider extends ChangeNotifier {
  //amber texty
  static const Color color_1 = Color(0xF9FFC107);
  //amber[800] tlačítka, obrysy,linie
  static Color getColor2(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    switch (selectedAppColor) {
      case 0:
        return isDarkTheme ? colorOrange : Color.fromARGB(141, 0, 0, 0);
      case 1:
        return isDarkTheme ? colorBlue : Color.fromARGB(141, 0, 0, 0);
      case 2:
        return isDarkTheme ? colorRed : Color.fromARGB(141, 0, 0, 0);
      case 3:
        return isDarkTheme ? colorYellow : Color.fromARGB(141, 0, 0, 0);
      case 4:
        return isDarkTheme ? colorGreen : Color.fromARGB(141, 0, 0, 0);
      case 5:
        return isDarkTheme ? colorPurple : Color.fromARGB(141, 0, 0, 0);
      case 6:
        return isDarkTheme
            ? Color.fromRGBO(255, 255, 255, 1)
            : Color.fromARGB(141, 0, 0, 0);
      default:
        return isDarkTheme
            ? Color.fromRGBO(0, 0, 0, 1)
            : Color.fromARGB(141, 0, 0, 0);
    }
  }

  static Color getColor8(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? Colors.black : Color.fromARGB(146, 255, 255, 255);
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
