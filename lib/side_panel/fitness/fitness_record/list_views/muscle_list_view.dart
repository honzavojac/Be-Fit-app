import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';

import '../../../../bloc/fitness_bloc.dart';
import '../../../../bloc/fitness_state.dart';
import '../../../../providers/colors_provider.dart';
import '../../../../variables.dart';
import 'exercise_list_view.dart';

Widget MuscleListViewBuilder() {
  return BlocBuilder<FitnessBloc, FitnessState>(
    builder: (context, state) {
      if (state is FitnessLoaded) {
        List<MySplit> splits = state.splits;
        Map<int, Exercise> exerciseMap = state.exerciseMap;
        int selectedSplitIndex = state.selectedSplitIndex;

        int splitIndex = splits[selectedSplitIndex].supabaseIdSplit!;
        Map<int, List<SelectedMuscle>> selectedMuscleMap = state.selectedMuscleMap;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: selectedMuscleMap[splitIndex]!.length,
          itemBuilder: (context, index) {
            int musclesIdMuscle = selectedMuscleMap[splitIndex]![index].musclesIdMuscle!;
            Muscle muscle = state.muscleMap[musclesIdMuscle]!;
            int supabaseIdSelectedMuscle = selectedMuscleMap[splitIndex]![index].supabaseIdSelectedMuscle!;

            Map<int, List<SelectedExercise>> selectedExerciseMap = {};
            selectedExerciseMap = state.selectedExerciseMap;

            if (selectedExerciseMap.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsProvider.getColor2(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            // color: ColorsProvider.getColor2(context),
                            borderRadius: zaobleni,
                          ),
                          child: Center(
                            child: Text(
                              "${muscle.nameOfMuscle}".toUpperCase(),
                              style: TextStyle(
                                color: ColorsProvider.getColor8(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                // letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 10,
                        ),
                        child: Container(
                          child: Text(
                            "No exercises",
                            style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: BoxDecoration(color: ColorsProvider.getColor2(context), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            // color: ColorsProvider.getColor2(context),
                            borderRadius: zaobleni,
                          ),
                          child: Center(
                            child: Text(
                              "${muscle.nameOfMuscle}".toUpperCase(),
                              style: TextStyle(
                                color: ColorsProvider.getColor8(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 12,
                        ),
                      ),
                      ExerciseListViewBuilder(supabaseIdSelectedMuscle, selectedExerciseMap, exerciseMap),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
      return Container();
    },
  );
}
