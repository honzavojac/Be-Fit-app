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
  UpdateSplitStartedCompleted(this.splitStartedCompleted);
}
