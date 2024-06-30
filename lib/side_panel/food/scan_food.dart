import 'package:flutter/material.dart';

class ScanFood extends StatefulWidget {
  const ScanFood({super.key});

  @override
  State<ScanFood> createState() => ScanFoodState();
}

class ScanFoodState extends State<ScanFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Food"),
      ),
      body: Container(),
    );
  }
}
