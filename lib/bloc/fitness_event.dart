abstract class FitnessEvent {}

class Increment extends FitnessEvent {}

class Decrement extends FitnessEvent {}

class SelectedSplit extends FitnessEvent {
  final int selectedSplitIndex;
  SelectedSplit(this.selectedSplitIndex);
}
