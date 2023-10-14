

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
    return const Center(
      child: Text('Záznam tréninku'),
    );
  }
}
