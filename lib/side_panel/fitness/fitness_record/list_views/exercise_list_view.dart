import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';

import '../../../../bloc/fitness_bloc.dart';
import '../../../../bloc/fitness_state.dart';
import '../../../../providers/colors_provider.dart';
import '../../../../variables.dart';
import 'exercise_data_list_view.dart';

Widget ExerciseListViewBuilder(int supabaseIdSelectedMuscle, Map<int, List<SelectedExercise>> selectedExerciseMap, Map<int, Exercise> exerciseMap) {
  // print(object)
  return BlocBuilder<FitnessBloc, FitnessState>(
    builder: (context, state) {
      if (state is FitnessLoaded) {
        Map<int, List<ExerciseData>> exerciseDataMap = state.exerciseDataMap;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selectedExerciseMap[supabaseIdSelectedMuscle]!.length,
          itemBuilder: (context, exerciseIndex) {
            int supabaseIdExercise = selectedExerciseMap[supabaseIdSelectedMuscle]![exerciseIndex].idExercise!;
            Exercise exercise = exerciseMap[supabaseIdExercise]!;
            List<ExerciseData>? exerciseData = exerciseDataMap[supabaseIdExercise];
            return GestureDetector(
              onTap: () async {
                // setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  // height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorsProvider.getColor2(context),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center, // Center the container content
                              child: Text(
                                exercise.nameOfExercise!.toUpperCase(),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsProvider.getColor8(context)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                        child: Container(
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: zaobleni,
                            color: Color.fromARGB(125, 0, 0, 0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                                child: Container(
                                  // width: 76,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "set".tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "exercise_weight".tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "reps".tr(),
                                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                color: ColorsProvider.getColor8(context),
                              ),
                              (state.splitStartedCompleted != null && exerciseData != null)
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                        child: ExerciseDataListViewBuilder(exerciseData),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      return Container();
    },
  );
}
