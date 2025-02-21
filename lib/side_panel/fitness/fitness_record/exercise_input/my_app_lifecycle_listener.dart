import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/fitness_bloc.dart';
import '../../../../bloc/fitness_event.dart';
import '../../../../data_classes.dart';

class MyAppLifecycleListener extends StatefulWidget {
  final Widget child;
  final Map<int, List<ExerciseData>> exerciseDataMap;
  final List<ExerciseData> exerciseData;
  final Exercise exercise;

  const MyAppLifecycleListener({
    Key? key,
    required this.child,
    required this.exerciseDataMap,
    required this.exerciseData,
    required this.exercise,
  }) : super(key: key);

  @override
  _MyAppLifecycleListenerState createState() => _MyAppLifecycleListenerState();
}

class _MyAppLifecycleListenerState extends State<MyAppLifecycleListener> with WidgetsBindingObserver {
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
      saveData();
      print("🛑 Aplikace je neaktivní (např. při příchozím hovoru)");
    } else if (state == AppLifecycleState.detached) {
      print("🔌 Aplikace je ukončena");
      saveData();
    }
  }

  void saveData() {
    List<ExerciseData> exerciseData = widget.exerciseData;
    Map<int, List<ExerciseData>> exerciseDataMap = widget.exerciseDataMap;
    Exercise exercise = widget.exercise;

    exerciseDataMap[widget.exercise.supabaseIdExercise!] = exerciseData;
    context.read<FitnessBloc>().add(UpdateExerciseDataBloc(exerciseDataMap));
    context.read<FitnessBloc>().add(UpdateExerciseMapBloc(exercise));

    print("data byla uložena");
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
