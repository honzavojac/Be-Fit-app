import 'package:flutter/material.dart';

class EditDeleteExerciseData extends StatefulWidget {
  const EditDeleteExerciseData({super.key});

  @override
  State<EditDeleteExerciseData> createState() => _EditDeleteExerciseDataState();
}

class _EditDeleteExerciseDataState extends State<EditDeleteExerciseData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit or delete exercise data"),
      ),
      body: Container(),
    );
  }
}
