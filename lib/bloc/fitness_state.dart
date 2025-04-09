import '../data_classes.dart';

// STATE
abstract class FitnessState {}

class FitnessInitial extends FitnessState {}

class FitnessError extends FitnessState {
  final String message;
  FitnessError(this.message);
}

class FitnessLoaded extends FitnessState {
  final List<MySplit> splits;
  final List<Muscle> muscles;
  final List<Exercise> exercises;
  final List<ExerciseData> exerciseData;
  final int splitIndex;
  final int selectedSplitIndex;
  final Map<int, MySplit> splitMap;
  final Map<int, Muscle> muscleMap;
  final Map<int, Exercise> exerciseMap;
  final Map<int, List<SelectedMuscle>> selectedMuscleMap;
  final Map<int, List<SelectedExercise>> selectedExerciseMap;
  final SplitStartedCompleted? splitStartedCompleted;
  final Map<int, List<ExerciseData>> exerciseDataMap;
  final Map<int, List<SplitStartedCompleted>> splitStartedCompletedMap;
  final Map<int, Map<int, List<ExerciseData>>> oldExerciseDataMap;
  final List<SplitStartedCompleted> splitStartedCompletedList;
  final Map<int, List<Exercise>> muscleExerciseMap;

  FitnessLoaded({
    required this.splits,
    required this.muscles,
    required this.exercises,
    required this.exerciseData,
    required this.splitIndex,
    required this.selectedSplitIndex,
    required this.splitMap,
    required this.muscleMap,
    required this.exerciseMap,
    required this.selectedMuscleMap,
    required this.selectedExerciseMap,
    required this.splitStartedCompleted,
    required this.exerciseDataMap,
    required this.splitStartedCompletedMap,
    required this.oldExerciseDataMap,
    required this.splitStartedCompletedList,
    required this.muscleExerciseMap,
  });

  FitnessLoaded copyWith({
    List<MySplit>? splits,
    List<Muscle>? muscles,
    List<Exercise>? exercises,
    List<ExerciseData>? exerciseData,
    int? splitIndex,
    int? selectedSplitIndex,
    Map<int, MySplit>? splitMap,
    Map<int, Muscle>? muscleMap,
    Map<int, Exercise>? exerciseMap,
    Map<int, List<SelectedMuscle>>? selectedMuscleMap,
    Map<int, List<SelectedExercise>>? selectedExerciseMap,
    SplitStartedCompleted? splitStartedCompleted,
    Map<int, List<ExerciseData>>? exerciseDataMap,
    bool explicitNull = false,
    Map<int, List<SplitStartedCompleted>>? splitStartedCompletedMap,
    Map<int, Map<int, List<ExerciseData>>>? oldExerciseDataMap,
    List<SplitStartedCompleted>? splitStartedCompletedList,
    Map<int, List<Exercise>>? muscleExerciseMap,
  }) {
    return FitnessLoaded(
      splits: splits ?? this.splits,
      muscles: muscles ?? this.muscles,
      exercises: exercises ?? this.exercises,
      exerciseData: exerciseData ?? this.exerciseData,
      splitIndex: splitIndex ?? this.splitIndex,
      selectedSplitIndex: selectedSplitIndex ?? this.selectedSplitIndex,
      splitMap: splitMap ?? this.splitMap,
      muscleMap: muscleMap ?? this.muscleMap,
      exerciseMap: exerciseMap ?? this.exerciseMap,
      selectedMuscleMap: selectedMuscleMap ?? this.selectedMuscleMap,
      selectedExerciseMap: selectedExerciseMap ?? this.selectedExerciseMap,
      splitStartedCompleted: explicitNull ? null : (splitStartedCompleted ?? this.splitStartedCompleted),
      exerciseDataMap: exerciseDataMap ?? this.exerciseDataMap,
      splitStartedCompletedMap: splitStartedCompletedMap ?? this.splitStartedCompletedMap,
      oldExerciseDataMap: oldExerciseDataMap ?? this.oldExerciseDataMap,
      splitStartedCompletedList: splitStartedCompletedList ?? this.splitStartedCompletedList,
      muscleExerciseMap: muscleExerciseMap ?? this.muscleExerciseMap,
    );
  }
}
