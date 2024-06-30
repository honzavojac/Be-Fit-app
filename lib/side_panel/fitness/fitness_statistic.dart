import 'package:flutter/material.dart';

class fitnessStatistic extends StatefulWidget {
  const fitnessStatistic({super.key});

  @override
  State<fitnessStatistic> createState() => _fitnessStatisticState();
}

class _fitnessStatisticState extends State<fitnessStatistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness statistic"),
      ),
      body: Container(),
    );
  }
}
