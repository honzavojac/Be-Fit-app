import '../data_classes.dart';

// EVENTS
abstract class FitnessEvent {}

class LoadFitnessData extends FitnessEvent {}

class Increment extends FitnessEvent {}

class Decrement extends FitnessEvent {}

class UpdateSelectedSplitIndexBloc extends FitnessEvent {
  final int selectedSplitIndex;
  UpdateSelectedSplitIndexBloc(this.selectedSplitIndex);
}

class UpdateSplitStartedCompletedBloc extends FitnessEvent {
  final SplitStartedCompleted? splitStartedCompleted;
  final bool explicitNull;
  UpdateSplitStartedCompletedBloc(this.splitStartedCompleted, this.explicitNull);
}

class UpdateExerciseDataBloc extends FitnessEvent {
  final Map<int, List<ExerciseData>>? exerciseDataMap;
  UpdateExerciseDataBloc(this.exerciseDataMap);
}

class UpdateExerciseMapBloc extends FitnessEvent {
  final Exercise exercise;
  UpdateExerciseMapBloc(this.exercise);
}

class CreateExerciseDataBloc extends FitnessEvent {
  final Exercise exercise;
  CreateExerciseDataBloc(
    this.exercise,
  );
}

class UpdateSelectedExerciseBloc extends FitnessEvent {
  // final SelectedExercise selectedExercise;
  final int selectedMuscleId;
  final Exercise exercise;

  UpdateSelectedExerciseBloc(this.selectedMuscleId, this.exercise);
}

class AddNewExerciseBloc extends FitnessEvent {
  final String exerciseName;
  final Muscle muscle;
  AddNewExerciseBloc(this.exerciseName, this.muscle);
}

class AddNewSplitBloc extends FitnessEvent {
  final String nameOfSplit;
  final List<Muscle> selectedMuscles;
  AddNewSplitBloc(this.nameOfSplit, this.selectedMuscles);
}

class AddNewMuscleBloc extends FitnessEvent {
  final String nameOfMuscle;
  AddNewMuscleBloc(this.nameOfMuscle);
}

class UpdateExerciseBloc extends FitnessEvent {
  final Exercise exercise;
  UpdateExerciseBloc(this.exercise);
}

class UpdateMuscleBloc extends FitnessEvent {
  final Muscle muscle;
  UpdateMuscleBloc(this.muscle);
}

class UpdateSplitBloc extends FitnessEvent {
  final MySplit split;
  UpdateSplitBloc(this.split);
}

class UpdateSelectedMuscleBloc extends FitnessEvent {
  final SelectedMuscle selectedMuscle;
  final int oldSupabaseSplitId;
  UpdateSelectedMuscleBloc(this.selectedMuscle, this.oldSupabaseSplitId);
}

class LogoutEventBloc extends FitnessEvent {}
