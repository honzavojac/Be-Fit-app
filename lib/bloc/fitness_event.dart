import '../data_classes.dart';

class Increment extends FitnessEvent {}

class Decrement extends FitnessEvent {}

// EVENTS
abstract class FitnessEvent {}

class LoadFitnessData extends FitnessEvent {}

class UpdateSelectedSplitIndex extends FitnessEvent {
  final int selectedSplitIndex;
  UpdateSelectedSplitIndex(this.selectedSplitIndex);
}

class UpdateSplitStartedCompleted extends FitnessEvent {
  final SplitStartedCompleted? splitStartedCompleted;
  final bool explicitNull;
  UpdateSplitStartedCompleted(this.splitStartedCompleted, this.explicitNull);
}

class UpdateExerciseData extends FitnessEvent {
  final Map<int, List<ExerciseData>>? exerciseDataMap;
  UpdateExerciseData(this.exerciseDataMap);
}

class UpdateExerciseMap extends FitnessEvent {
  final Exercise exercise;
  UpdateExerciseMap(this.exercise);
}

class CreateExerciseData extends FitnessEvent {
  final Exercise exercise;
  CreateExerciseData(
    this.exercise,
  );
}

class UpdateSelectedExercise extends FitnessEvent {
  // final SelectedExercise selectedExercise;
  final int selectedMuscleId;
  final Exercise exercise;

  UpdateSelectedExercise(this.selectedMuscleId, this.exercise);
}

class AddNewExercise extends FitnessEvent {
  final String exerciseName;
  final Muscle muscle;
  AddNewExercise(this.exerciseName, this.muscle);
}

class AddNewSplit extends FitnessEvent {
  final String nameOfSplit;
  final List<Muscle> selectedMuscles;
  AddNewSplit(this.nameOfSplit, this.selectedMuscles);
}

class AddNewMuscle extends FitnessEvent {
  final String nameOfMuscle;
  AddNewMuscle(this.nameOfMuscle);
}

class UpdateExercise extends FitnessEvent {
  final Exercise exercise;
  UpdateExercise(this.exercise);
}

class UpdateMuscle extends FitnessEvent {
  final Muscle muscle;
  UpdateMuscle(this.muscle);
}

class UpdateSplit extends FitnessEvent {
  final MySplit split;
  UpdateSplit(this.split);
}
