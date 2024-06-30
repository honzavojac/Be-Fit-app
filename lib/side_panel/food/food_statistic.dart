import 'package:flutter/material.dart';

class foodStatistic extends StatefulWidget {
  const foodStatistic({super.key});

  @override
  State<foodStatistic> createState() => _foodStatisticState();
}

class _foodStatisticState extends State<foodStatistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food statistic"),
      ),
      body: Container(),
    );
  }
}
