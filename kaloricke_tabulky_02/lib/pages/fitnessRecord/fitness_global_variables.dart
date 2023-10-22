import 'package:flutter/material.dart';

class fitnessGlobalVariables extends ChangeNotifier {
  List<String> _data = [
    'Back, biceps, triceps',
    'Pull',
    'Legs',
  ];
  late String selectedValue;
  List<String> get data => _data;
}
