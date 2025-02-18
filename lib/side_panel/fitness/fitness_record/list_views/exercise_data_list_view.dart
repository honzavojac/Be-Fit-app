import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';

import '../../../../bloc/fitness_bloc.dart';
import '../../../../bloc/fitness_state.dart';
import '../../../../providers/colors_provider.dart';
import '../../../../variables.dart';

Widget ExerciseDataListViewBuilder(List<ExerciseData> _exerciseData) {
  // print(_exerciseData.first.reps);
  return ListView.builder(
    itemCount: _exerciseData.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      ExerciseData exerciseData = _exerciseData[index];
      String? reps = exerciseData.reps == null ? "" : exerciseData.reps.toString();
      String? weight = exerciseData.weight == null ? "" : exerciseData.weight.toString();
      int? difficulty = exerciseData.difficulty ?? 0;

      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
        child: Container(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "$weight",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: difficulty == 0
                      ? Colors.white
                      : difficulty == 1
                          ? Colors.green
                          : difficulty == 2
                              ? Colors.lightGreen
                              : difficulty == 3
                                  ? Colors.yellow
                                  : difficulty == 4
                                      ? Colors.orange
                                      : ColorsProvider.color_9,
                ),
              ),
              Text(
                "${reps.isEmpty ? "" : reps}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: difficulty == 0
                      ? Colors.white
                      : difficulty == 1
                          ? Colors.green
                          : difficulty == 2
                              ? Colors.lightGreen
                              : difficulty == 3
                                  ? Colors.yellow
                                  : difficulty == 4
                                      ? Colors.orange
                                      : ColorsProvider.color_9,
                ),
              ),
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
      );
    },
  );
}
