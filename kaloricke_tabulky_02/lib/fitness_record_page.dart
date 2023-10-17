// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Záznam tréninku'),
    );
  }
}

class FitnessRecordScreen extends StatelessWidget {
  const FitnessRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Text('Záznam tréninku'),
    ));
  }
}
