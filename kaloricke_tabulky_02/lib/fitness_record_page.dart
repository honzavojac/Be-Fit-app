// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Záznam tréninku'),
    );
  }
}

class FitnessRecordScreen extends StatelessWidget {
  const FitnessRecordScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Záznam tréninku'),
    );
  }
}
