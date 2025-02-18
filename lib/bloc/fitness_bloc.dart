import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/data.dart';

import '../data_classes.dart';
import 'fitness_event.dart';
import 'fitness_state.dart';
import 'package:collection/collection.dart';

// BLOC
class FitnessBloc extends Bloc<FitnessEvent, FitnessState> {
  FitnessBloc() : super(FitnessInitial()) {
    // add(LoadFitnessData());

    on<LoadFitnessData>(_onLoadFitnessData);
    on<UpdateSelectedSplitIndex>(_onUpdateSelectedSplitIndex);
    on<UpdateSplitStartedCompleted>(_onUpdateSplitStartedCompleted);
    on<UpdateExerciseData>(_onUpdateExerciseData);
    on<UpdateExerciseMap>(_onUpdateExerciseMap);
    on<CreateExerciseData>(_onCreateExerciseData);
    on<UpdateSelectedExercise>(_onUpdateSelectedExercise);
    on<AddNewExercise>(_onAddExercise);
    on<AddNewSplit>(_onAddSplit);
    on<AddNewMuscle>(_onAddMuscle);
    on<UpdateSplit>(_onUpdateSplit);
    on<UpdateMuscle>(_onUpdateMuscle);
    on<UpdateExercise>(_onUpdateExercise);
  }

  Future<FitnessLoaded> fetchFitnessData() async {
    // print("fetch fitness data ********************************************");
    List<MySplit> splits = sqfliteSplitList;
    List<Muscle> muscles = sqfliteMuscleList;
    muscles.sort(
      (a, b) => a.supabaseIdMuscle!.compareTo(b.supabaseIdMuscle!),
    );
    List<Exercise> exercises = sqfliteExerciseList;
    List<ExerciseData> exerciseData = sqfliteExerciseDataList;
    List<SelectedMuscle> selectedMuscles = sqfliteSelectedMuscleList;
    List<SelectedExercise> selectedExercises = sqfliteSelectedExerciseList;
    List<SplitStartedCompleted> splitStartedCompletedList = sqfliteSplitStartedCompletedList;

    Map<int, MySplit> splitMap = {for (var split in splits) split.supabaseIdSplit!: split};
    Map<int, Muscle> muscleMap = {for (var muscle in muscles) muscle.supabaseIdMuscle!: muscle};
    Map<int, Exercise> exerciseMap = {for (var exercise in exercises) exercise.supabaseIdExercise!: exercise};
    Map<int, List<Exercise>> muscleExerciseMap = initMuscleExerciseMap(exercises); // svalId-list(exercise)pro zobrazení všech cviků pro sval v split page

    Map<int, List<SelectedMuscle>> selectedMuscleMap = initSelectedMuscle(selectedMuscles);
    Map<int, List<SelectedExercise>> selectedExerciseMap = initSelectedExercise(selectedExercises);
    SplitStartedCompleted? splitStartedCompleted = getSplitStartedCompleted(splitStartedCompletedList);
    Map<int, List<ExerciseData>> exerciseDataMap = initExerciseData(exerciseData, splitStartedCompleted);
    Map<int, List<SplitStartedCompleted>> splitStartedCompletedMap = initSplitStartedCompletedMap(exerciseData, splitStartedCompletedList);
    Map<int, Map<int, List<ExerciseData>>> oldExerciseDataMap = initOldExerciseDataMap(exerciseData);

    int? selectedSplitIndex;
    if (splitStartedCompleted != null) {
      selectedSplitIndex = splits.indexWhere(
        (split) => split.supabaseIdSplit == splitStartedCompleted.splitId,
      );
    }

    return FitnessLoaded(
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
      splitStartedCompletedMap: splitStartedCompletedMap,
      oldExerciseDataMap: oldExerciseDataMap,
      splitStartedCompletedList: splitStartedCompletedList,
      muscleExerciseMap: muscleExerciseMap,
    );
  }

  void _onLoadFitnessData(LoadFitnessData event, Emitter<FitnessState> emit) async {
    final fitnessData = await fetchFitnessData();
    emit(fitnessData);
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

      // SplitStartedCompleted? splitStartedCompleted = currentState.splitStartedCompleted;
      Map<int, List<SplitStartedCompleted>> splitStartedCompletedMap = currentState.splitStartedCompletedMap;
      List<SplitStartedCompleted> splitStartedCompletedList = List.from(currentState.splitStartedCompletedList);
      for (var item in splitStartedCompletedMap.keys) {
        splitStartedCompletedMap[item]!.firstWhereOrNull((element) => element.ended == null || element.ended == false)
          ?..ended = true
          ..createdAt = DateTime.now().toString();
        splitStartedCompletedMap[item]!.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt!),
        );
      }
      splitStartedCompletedList.firstWhereOrNull((element) => element.ended == null || element.ended == false)
        ?..ended = true
        ..createdAt = DateTime.now().toString();
      splitStartedCompletedList.sort(
        (a, b) => b.createdAt!.compareTo(a.createdAt!),
      );
      // Map<int, Map<int, List<ExerciseData>>> oldExerciseDataMap = initOldExerciseDataMap(currentState.exerciseData);
      emit(currentState.copyWith(
        splitStartedCompleted: event.splitStartedCompleted,
        explicitNull: event.explicitNull,
        exerciseDataMap: {},
        splitStartedCompletedList: splitStartedCompletedList,
        splitStartedCompletedMap: splitStartedCompletedMap,
      ));
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

  void _onUpdateExerciseData(UpdateExerciseData event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      emit(currentState.copyWith(exerciseDataMap: event.exerciseDataMap));
    }
  }

  void _onUpdateExerciseMap(UpdateExerciseMap event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;

      emit(
        currentState.copyWith(
          exerciseMap: {
            ...currentState.exerciseMap,
            if (event.exercise.supabaseIdExercise != null) event.exercise.supabaseIdExercise!: event.exercise,
          },
        ),
      );
    }
  }

  void _onCreateExerciseData(CreateExerciseData event, Emitter<FitnessState> emit) {
    if (state is! FitnessLoaded) return;

    final currentState = state as FitnessLoaded;
    SplitStartedCompleted? splitStartedCompleted = currentState.splitStartedCompleted;
    Exercise exercise = event.exercise;

    List<SplitStartedCompleted> splitStartedCompletedList = List.from(currentState.splitStartedCompletedList);
    List<ExerciseData> exerciseDataList = List.from(currentState.exerciseData);

    Map<int, List<SplitStartedCompleted>> updatedSplitStartedCompletedMap = Map<int, List<SplitStartedCompleted>>.from(currentState.splitStartedCompletedMap);
    Map<int, List<ExerciseData>> updatedExerciseDataMap = Map<int, List<ExerciseData>>.from(currentState.exerciseDataMap);

    // 🔹 Pokud není splitStartedCompleted nebo skončil, vytvoř nový
    if (splitStartedCompleted == null || splitStartedCompleted.ended == true) {
      print("přidání nového řádku do splitStartedCompleted a exerciseData");

      if (splitStartedCompletedList.isNotEmpty) {
        splitStartedCompletedList.sort((a, b) => a.idStartedCompleted!.compareTo(b.idStartedCompleted!));
      }

      int newId = splitStartedCompletedList.isNotEmpty ? splitStartedCompletedList.last.idStartedCompleted! + 1 : 1;
      int newSupabaseId = splitStartedCompletedList.isNotEmpty ? splitStartedCompletedList.last.supabaseIdStartedCompleted! + 1 : 1;

      int supabaseIdSplit = currentState.splits[currentState.selectedSplitIndex].supabaseIdSplit!;

      splitStartedCompleted = SplitStartedCompleted(
        ended: false,
        createdAt: DateTime.now().toString(),
        action: 0,
        idStartedCompleted: newId,
        supabaseIdStartedCompleted: newSupabaseId,
        splitId: supabaseIdSplit,
        endedAt: null,
      );

      splitStartedCompletedList.add(splitStartedCompleted);
      updatedSplitStartedCompletedMap.putIfAbsent(exercise.supabaseIdExercise!, () => []).add(splitStartedCompleted);
    }

    print("přidání dalšího řádku do exerciseData");

    if (exerciseDataList.isNotEmpty) {
      exerciseDataList.sort((a, b) => a.idExData!.compareTo(b.idExData!));
    }

    int newExerciseDataId = 1 + (exerciseDataList.isNotEmpty ? exerciseDataList.last.idExData! : 0);
    int newSupabaseExerciseDataId = 1 + (exerciseDataList.isNotEmpty ? exerciseDataList.last.supabaseIdExData! : 0);

    ExerciseData newExerciseData = ExerciseData(
      idExData: newExerciseDataId,
      supabaseIdExData: newSupabaseExerciseDataId,
      action: 0,
      exercisesIdExercise: exercise.supabaseIdExercise,
      idStartedCompleted: splitStartedCompleted.supabaseIdStartedCompleted,
      time: DateTime.now().toString(),
    );

    exerciseDataList.add(newExerciseData);
    updatedExerciseDataMap.putIfAbsent(exercise.supabaseIdExercise!, () => []).add(newExerciseData);

    Map<int, Map<int, List<ExerciseData>>> oldExerciseData = currentState.oldExerciseDataMap;
    oldExerciseData.putIfAbsent(newExerciseData.idStartedCompleted!, () => {});
    oldExerciseData[newExerciseData.idStartedCompleted]!.putIfAbsent(exercise.supabaseIdExercise!, () => []).add(newExerciseData);

    // 📌 🔥 Emit **pouze jednou** s celým novým stavem
    emit(
      currentState.copyWith(
        splitStartedCompleted: splitStartedCompleted,
        splitStartedCompletedList: splitStartedCompletedList,
        splitStartedCompletedMap: updatedSplitStartedCompletedMap,
        exerciseDataMap: updatedExerciseDataMap,
        exerciseData: exerciseDataList,
        oldExerciseDataMap: oldExerciseData,
      ),
    );
  }

  void _onUpdateSelectedExercise(UpdateSelectedExercise event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;

      int selectedMuscleId = event.selectedMuscleId;
      Exercise exercise = event.exercise;
      int exerciseId = exercise.supabaseIdExercise!;
      int muscleId = exercise.musclesIdMuscle!;
      // Zkopírování mapy, aby se neaktualizoval původní stav přímo
      Map<int, List<SelectedExercise>> selectedExerciseMap = Map.from(currentState.selectedExerciseMap);
      // Map<int, List<Exercise>> muscleExerciseMap = Map.from(currentState.muscleExerciseMap);

      // Pokud neexistuje seznam pro daný sval, vytvoříme ho
      selectedExerciseMap.putIfAbsent(selectedMuscleId, () => []);
      // muscleExerciseMap.putIfAbsent(muscleId, () => []);

      // Získání seznamu cvičení pro daný sval
      List<SelectedExercise> selectedExerciseList = List.from(selectedExerciseMap[selectedMuscleId]!);
      // List<Exercise> exerciseList = List.from(muscleExerciseMap[muscleId]!);
      // Hledání cvičení podle exerciseId
      int selectedExerciseIndex = selectedExerciseList.indexWhere((element) => element.idExercise == exerciseId);
      // int exerciseIndex = exerciseList.indexWhere((element) => element.idExercise == exerciseId);

      if (selectedExerciseIndex != -1) {
        // Pokud už cvičení existuje v seznamu, odstraníme ho (toggling funkce)
        print("odebrání cviku");
        selectedExerciseList.removeAt(selectedExerciseIndex);
      } else {
        // Pokud cvičení neexistuje, přidáme nové
        print("přidání cviku");
        selectedExerciseList.add(SelectedExercise(
          idExercise: exerciseId,
          idSelectedMuscle: selectedMuscleId,
        ));
      }

      // Aktualizace mapy
      selectedExerciseMap[selectedMuscleId] = selectedExerciseList;
      // muscleExerciseMap[muscleId] = List.from(exerciseList);

      emit(currentState.copyWith(
        selectedExerciseMap: selectedExerciseMap,
        // muscleExerciseMap: muscleExerciseMap,
      ));
    }
  }

  void _onAddExercise(AddNewExercise event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      List<Exercise>? exercises = List.from(currentState.exercises);
      exercises.sort(
        (a, b) => a.idExercise!.compareTo(b.idExercise!),
      );
      int idExercise = 1 + (exercises.last.idExercise ?? 0);
      int supabaseIdExercise = 1 + (exercises.last.supabaseIdExercise ?? 0);

      Exercise exercise = Exercise(
        idExercise: idExercise,
        supabaseIdExercise: supabaseIdExercise,
        nameOfExercise: event.exerciseName,
        musclesIdMuscle: event.muscle.supabaseIdMuscle,
        action: 0,
        comment: "",
      );

      List<Exercise> newExercises = List.from(currentState.exercises)..add(exercise);
      Map<int, Exercise> exerciseMap = Map.from(currentState.exerciseMap);
      exerciseMap.putIfAbsent(exercise.supabaseIdExercise!, () => exercise);
      Map<int, List<Exercise>> muscleExerciseMap = Map.from(currentState.muscleExerciseMap);
      muscleExerciseMap.putIfAbsent(exercise.musclesIdMuscle!, () => []);
      muscleExerciseMap[exercise.musclesIdMuscle]!.add(exercise);

      emit(
        currentState.copyWith(
          exercises: newExercises,
          exerciseMap: exerciseMap,
          muscleExerciseMap: muscleExerciseMap,
        ),
      );
    }
  }

  void _onAddSplit(AddNewSplit event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      Map<int, MySplit> splitMap = Map.from(currentState.splitMap);
      List<MySplit>? splits = List.from(currentState.splits);
      Map<int, List<SelectedMuscle>> selectedMuscleMap = Map.from(currentState.selectedMuscleMap);
      splits.sort(
        (a, b) => a.idSplit!.compareTo(b.idSplit!),
      );
      int splitId = 1 + (splits.isNotEmpty ? splits.last.idSplit! : 0);
      int supabaseSplitId = 1 + (splits.isNotEmpty ? splits.last.supabaseIdSplit! : 0);

      MySplit split = MySplit(
        idSplit: splitId,
        supabaseIdSplit: supabaseSplitId,
        nameSplit: event.nameOfSplit.trim(),
        createdAt: DateTime.now().toString(),
        isActive: true,
        action: 0,
      );
      splitMap.putIfAbsent(supabaseSplitId, () => split);
      splits.add(split);
      selectedMuscleMap.putIfAbsent(
        supabaseSplitId,
        () => [],
      );
      List<SelectedMuscle> newSelectedMuscleList = [];
      List<Muscle> muscles = List.from(event.selectedMuscles); // jsou to svaly které uživatel selectne a potřebuju z nich udělat SelctedMuscles
      List<SelectedMuscle> selectedMuscleList = selectedMuscleMap.values.expand((list) => list).toList();

      selectedMuscleList.sort(
        (a, b) => a.idSelectedMuscle!.compareTo(b.idSelectedMuscle!),
      );
      int selectedMuscleId = 1 + (selectedMuscleList.isNotEmpty ? selectedMuscleList.last.idSelectedMuscle! : 0);
      int supabaseSelectedMuscleId = 1 + (selectedMuscleList.isNotEmpty ? selectedMuscleList.last.supabaseIdSelectedMuscle! : 0);

      for (var muscle in muscles) {
        SelectedMuscle selectedMuscle = SelectedMuscle(
          idSelectedMuscle: selectedMuscleId,
          supabaseIdSelectedMuscle: supabaseSelectedMuscleId,
          splitIdSplit: supabaseSplitId,
          musclesIdMuscle: muscle.supabaseIdMuscle,
        );
        selectedMuscleId++;
        supabaseSelectedMuscleId++;
        newSelectedMuscleList.add(selectedMuscle);
      }
      selectedMuscleMap[supabaseSplitId] = newSelectedMuscleList;
      emit(currentState.copyWith(
        splitMap: splitMap,
        splits: splits,
        selectedMuscleMap: selectedMuscleMap,
      ));
    }
  }

  void _onAddMuscle(AddNewMuscle event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      Map<int, Muscle> muscleMap = Map.from(currentState.muscleMap);
      List<Muscle> muscles = List.from(currentState.muscles);

      muscles.sort((a, b) => a.idMuscle!.compareTo(b.idMuscle!));
      int muscleId = 1 + (muscles.isNotEmpty ? muscles.last.idMuscle! : 0);

      muscles.sort((a, b) => a.supabaseIdMuscle!.compareTo(b.supabaseIdMuscle!));
      int supabaseMuscleId = 1 + (muscles.isNotEmpty ? muscles.last.supabaseIdMuscle! : 0);

      Muscle newMuscle = Muscle(
        idMuscle: muscleId,
        supabaseIdMuscle: supabaseMuscleId,
        nameOfMuscle: event.nameOfMuscle.trim(),
        action: 0,
      );
      muscles.add(newMuscle);
      muscleMap.putIfAbsent(supabaseMuscleId, () => newMuscle);

      emit(currentState.copyWith(
        muscleMap: muscleMap,
        muscles: muscles,
      ));
    }
  }

  void _onUpdateSplit(UpdateSplit event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      MySplit split = event.split;
      List<MySplit> splits = currentState.splits;
      int? splitIndex = splits.indexWhere(
        (element) => element.supabaseIdSplit == split.supabaseIdSplit,
      );
      splits[splitIndex] = split;

      Map<int, MySplit> splitMap = currentState.splitMap;
      splitMap[split.supabaseIdSplit!] = split;
      emit(currentState.copyWith(
        splits: splits,
        splitMap: splitMap,
      ));
    }
  }

  void _onUpdateMuscle(UpdateMuscle event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      Muscle muscle = event.muscle;
      List<Muscle> muscles = currentState.muscles;
      int? muscleIndex = muscles.indexWhere(
        (element) => element.supabaseIdMuscle == muscle.supabaseIdMuscle,
      );
      muscles[muscleIndex] = muscle;

      Map<int, Muscle> muscleMap = currentState.muscleMap;
      muscleMap[muscle.supabaseIdMuscle!] = muscle;

      emit(currentState.copyWith(
        muscles: muscles,
        muscleMap: muscleMap,
      ));
    }
  }

  void _onUpdateExercise(UpdateExercise event, Emitter<FitnessState> emit) {
    if (state is FitnessLoaded) {
      final currentState = state as FitnessLoaded;
      Exercise exercise = event.exercise;
      List<Exercise> exercises = currentState.exercises;
      int? exerciseIndex = exercises.indexWhere(
        (element) => element.supabaseIdExercise == exercise.supabaseIdExercise,
      );
      exercises[exerciseIndex] = exercise;

      Map<int, Exercise> exerciseMap = currentState.exerciseMap;
      exerciseMap[exercise.supabaseIdExercise!] = exercise;

      emit(currentState.copyWith(
        exercises: exercises,
        exerciseMap: exerciseMap,
      ));
    }
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

Map<int, List<SelectedExercise>> initSelectedExercise(List<SelectedExercise> selectedExercises) {
  return groupBy(selectedExercises, (ex) => ex.idSelectedMuscle!);
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

Map<int, List<SplitStartedCompleted>> initSplitStartedCompletedMap(List<ExerciseData> exerciseData, List<SplitStartedCompleted> splitStartedCompletedList) {
  Map<int, List<SplitStartedCompleted>> splitStartedCompletedMap = {};
  Map<int, SplitStartedCompleted> splitStartedCompletedLookup = {
    for (var item in splitStartedCompletedList) item.supabaseIdStartedCompleted!: item,
  };

  for (var exDataItem in exerciseData.reversed) {
    SplitStartedCompleted? splitItem = splitStartedCompletedLookup[exDataItem.idStartedCompleted];
    if (splitItem != null && splitItem.ended != false) {
      splitStartedCompletedMap.putIfAbsent(exDataItem.exercisesIdExercise!, () => []);
      if (!splitStartedCompletedMap[exDataItem.exercisesIdExercise]!.contains(splitItem)) {
        splitStartedCompletedMap[exDataItem.exercisesIdExercise]!.add(splitItem);
      }
    }
  }

  // Odstranění duplicit v každém seznamu

  return splitStartedCompletedMap;
}

Map<int, Map<int, List<ExerciseData>>> initOldExerciseDataMap(List<ExerciseData> exerciseData) {
  Map<int, Map<int, List<ExerciseData>>> oldExerciseDataMap = {};
  exerciseData.sort(
    (a, b) => a.supabaseIdExData!.compareTo(b.supabaseIdExData!),
  );
  for (var element in exerciseData) {
    oldExerciseDataMap.putIfAbsent(element.idStartedCompleted!, () => {});
    oldExerciseDataMap[element.idStartedCompleted]!.putIfAbsent(element.exercisesIdExercise!, () => []).add(element);
  }

  return oldExerciseDataMap;
}

Map<int, List<Exercise>> initMuscleExerciseMap(List<Exercise> exercises) {
  Map<int, List<Exercise>> muscleExerciseMap = {};
  exercises.sort(
    (a, b) => a.supabaseIdExercise!.compareTo(b.supabaseIdExercise!),
  );
  for (var exercise in exercises) {
    muscleExerciseMap
        .putIfAbsent(
          exercise.musclesIdMuscle!,
          () => [],
        )
        .add(exercise);
  }
  return muscleExerciseMap;
}
