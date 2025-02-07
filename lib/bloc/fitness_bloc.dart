import 'package:flutter_bloc/flutter_bloc.dart';
import 'fitness_event.dart';
import 'fitness_state.dart';

class FitnessBloc extends Bloc<FitnessEvent, FitnessState> {
  FitnessBloc() : super(FitnessInitial()) {
    // Inkrementace
    on<Increment>((event, emit) {
      emit(FitnessUpdated(state.counter + 1, state.selectedSplitIndex));
    });

    // Dekrementace
    on<Decrement>((event, emit) {
      emit(FitnessUpdated(state.counter - 1, state.selectedSplitIndex));
    });

    // Změna vybrané hodnoty z dropdownu
    on<SelectedSplit>((event, emit) {
      emit(FitnessUpdated(
        state.counter,
        event.selectedSplitIndex,
      ));
    });
  }
}
