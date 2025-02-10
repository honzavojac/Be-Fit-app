import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/data.dart';
import '../data_classes.dart';
import 'fitness_event.dart';
import 'fitness_state.dart';

// BLOC
class FitnessBloc extends Bloc<FitnessEvent, FitnessState> {
  FitnessBloc() : super(FitnessInitial()) {
    // add(LoadFitnessData());

    on<LoadFitnessData>(onLoadFitnessData);
    on<UpdateSelectedSplitIndex>(_onUpdateSelectedSplitIndex);
    on<UpdateSplitStartedCompleted>(_onUpdateSplitStartedCompleted);
  }

  void onLoadFitnessData(LoadFitnessData event, Emitter<FitnessState> emit) async {
    List<MySplit> splits = sqfliteSplitList;
    List<Muscle> muscles = sqfliteMuscleList;
    List<Exercise> exercises = sqfliteExerciseList;
    List<ExerciseData> exerciseData = sqfliteExerciseDataList;
    List<SelectedMuscle> selectedMuscles = sqfliteSelectedMuscleList;
    List<SelectedExercise> selectedExercises = sqfliteSelectedExerciseList;
    List<SplitStartedCompleted> splitStartedCompletedList = sqfliteSplitStartedCompletedList;

    Map<int, MySplit> splitMap = {for (var split in splits) split.supabaseIdSplit!: split};
    Map<int, Muscle> muscleMap = {for (var muscle in muscles) muscle.supabaseIdMuscle!: muscle};
    Map<int, Exercise> exerciseMap = {for (var exercise in exercises) exercise.supabaseIdExercise!: exercise};
    Map<int, List<SelectedMuscle>> selectedMuscleMap = {};
    Map<int, List<SelectedExercise>> selectedExerciseMap = {};
    Map<int, List<ExerciseData>> exerciseDataMap = {};
    SplitStartedCompleted? splitStartedCompleted;

    selectedMuscleMap = initSelectedMuscle(selectedMuscles);
    selectedExerciseMap = initSelectedExercise(selectedExercises);
    splitStartedCompleted = getSplitStartedCompleted(splitStartedCompletedList);
    exerciseDataMap = initExerciseData(exerciseData, splitStartedCompleted);
    int? selectedSplitIndex;

    if (splitStartedCompleted != null) {
      selectedSplitIndex = splits.indexWhere(
        (split) => split.supabaseIdSplit == splitStartedCompleted!.splitId,
      );
    }

    // Vytvoření FitnessLoaded stavu s vybraným indexem
    emit(FitnessLoaded(
      splits: splits,
      muscles: muscles,
      exercises: exercises,
      exerciseData: exerciseData,
      splitIndex: 0,
      selectedSplitIndex: selectedSplitIndex ?? 0,
      splitMap: splitMap,
      muscleMap: muscleMap,
      exerciseMap: exerciseMap,
      selectedMuscleMap: selectedMuscleMap,
      selectedExerciseMap: selectedExerciseMap,
      splitStartedCompleted: splitStartedCompleted,
      exerciseDataMap: exerciseDataMap,
    ));
  }

  void _onUpdateSelectedSplitIndex(UpdateSelectedSplitIndex event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      emit(currentState.copyWith(selectedSplitIndex: event.selectedSplitIndex));
    }
  }

  void _onUpdateSplitStartedCompleted(UpdateSplitStartedCompleted event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;

      print("UpdateSplitStartedCompleted called with: ${event.splitStartedCompleted}");

      emit(currentState.copyWith(splitStartedCompleted: event.splitStartedCompleted));

      print("New state: ${(state as FitnessLoaded).splitStartedCompleted}");
    }
  }

  SplitStartedCompleted? getSplitStartedCompleted(List<SplitStartedCompleted> splitStartedCompletedList) {
    for (var startedCompleted in splitStartedCompletedList) {
      if (startedCompleted.ended == false) {
        return startedCompleted;
      }
    }
    return null;
  }
}

Map<int, List<SelectedMuscle>> initSelectedMuscle(List<SelectedMuscle> selectedMuscles) {
  Map<int, List<SelectedMuscle>> selectedMuscleMap = {};

  for (var selectedMuscle in selectedMuscles) {
    selectedMuscleMap.putIfAbsent(selectedMuscle.splitIdSplit!, () => []);
    selectedMuscleMap[selectedMuscle.splitIdSplit]!.add(selectedMuscle);
  }

  return selectedMuscleMap;
}

Map<int, List<SelectedExercise>> initSelectedExercise(List selectedExercises) {
  Map<int, List<SelectedExercise>> selectedExerciseMap = {};

  for (var selectedExercise in selectedExercises) {
    int muscleId = selectedExercise.idSelectedMuscle!;

    if (!selectedExerciseMap.containsKey(muscleId)) {
      selectedExerciseMap[muscleId] = [];
    }

    // Přidej idExercise do seznamu
    selectedExerciseMap[muscleId]!.add(selectedExercise);
  }
  return selectedExerciseMap;
}

Map<int, List<ExerciseData>> initExerciseData(List<ExerciseData> exerciseData, SplitStartedCompleted? splitStartedCompleted) {
  Map<int, List<ExerciseData>> exerciseDataMap = {};

  for (var exerciseDataItem in exerciseData) {
    if (splitStartedCompleted != null && exerciseDataItem.idStartedCompleted == splitStartedCompleted.supabaseIdStartedCompleted) {
      exerciseDataMap.putIfAbsent(exerciseDataItem.exercisesIdExercise!, () => []);

      exerciseDataMap[exerciseDataItem.exercisesIdExercise]!.add(exerciseDataItem);
    }
  }

  return exerciseDataMap;
}
