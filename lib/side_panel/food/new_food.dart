import 'package:flutter/material.dart';

class NewFood extends StatefulWidget {
  const NewFood({super.key});

  @override
  State<NewFood> createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Food"),
      ),
      body: Container(),
    );
  }
}
