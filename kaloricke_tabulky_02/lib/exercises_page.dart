// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ExerciseAppBar extends StatelessWidget {
  const ExerciseAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Exercise'),
    );
  }
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen();

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'bude tady obrazovka kde se bude dát podívat na progres u cviků list containerů cviků, cviky se budou řadit podle poslední změny a budou mít 3 druhy ikon - routoucí(zelenou),klesající(červenou) a stoupající/rostoucí(bílá)'),
    );
  }
}
