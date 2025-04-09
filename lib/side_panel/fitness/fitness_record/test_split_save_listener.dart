import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/fitness_bloc.dart';
import '../../../../bloc/fitness_event.dart';
import '../../../../data_classes.dart';
import '../../../bloc/fitness_state.dart';

class TestSplitSaveListener extends StatefulWidget {
  final Widget child;
  final List<MySplit> splits;
  final Map<int, List<SelectedMuscle>> selectedMusclesMap; //
  final Map<int, List<SelectedExercise>> selectedExerciseMap; //

  final Map<int, Muscle> muscleMap;
  final Map<int, List<Exercise>> muscleExerciseMap;
  const TestSplitSaveListener({
    Key? key,
    required this.child,
    required this.splits,
    required this.selectedMusclesMap,
    required this.selectedExerciseMap,
    required this.muscleMap,
    required this.muscleExerciseMap,
  }) : super(key: key);

  @override
  _TestSplitSaveListenerState createState() => _TestSplitSaveListenerState();
}

class _TestSplitSaveListenerState extends State<TestSplitSaveListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.paused) {
    //   saveData();
    //   print("📴 Obrazovka zhasla nebo aplikace přešla na pozadí");
    // } else
    if (state == AppLifecycleState.resumed) {
      print("📱 Aplikace se vrátila do popředí");
    } else if (state == AppLifecycleState.inactive) {
      saveData(context);
      print("🛑 Aplikace je neaktivní (např. při příchozím hovoru)");
    } else if (state == AppLifecycleState.detached) {
      print("🔌 Aplikace je ukončena");
      saveData(context);
    }
  }

  void saveData(BuildContext context) {
    final state = context.read<FitnessBloc>().state;

    if (state is FitnessLoaded) {
      for (var split in widget.splits) {
        context.read<FitnessBloc>().add(UpdateSplitBloc(split, null));
      }
      widget.muscleMap.forEach(
        (key, value) {
          context.read<FitnessBloc>().add(UpdateMuscleBloc(value));
        },
      );
      List<int> supabaseExerciseIds = []; //proměnná pro kontrolu jestli se cvik už aktualizoval
      widget.muscleExerciseMap.forEach(
        (key, exerciseList) {
          exerciseList.forEach(
            (exercise) {
              if (!supabaseExerciseIds.contains(exercise.supabaseIdExercise)) {
                supabaseExerciseIds.add(exercise.supabaseIdExercise!);
                context.read<FitnessBloc>().add(UpdateExerciseBloc(exercise));
              }
            },
          );
        },
      );
      print(state.splitIndex);
      print("Ukládám data: ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
