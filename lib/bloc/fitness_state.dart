abstract class FitnessState {
  final int counter;
  final int selectedSplitIndex;

  FitnessState(this.counter, this.selectedSplitIndex);
}

class FitnessInitial extends FitnessState {
  FitnessInitial() : super(0, 0);
}

class FitnessUpdated extends FitnessState {
  FitnessUpdated(int counter, int selectedSplitIndex) : super(counter, selectedSplitIndex);
}
