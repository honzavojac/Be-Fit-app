class Muscle {
  int? idMuscle;
  String nameOfMuscle;

  int? action;
  int? supabaseIdMuscle;
  List<Exercise>? exercises;

  Muscle({
    this.idMuscle,
    required this.nameOfMuscle,
    this.supabaseIdMuscle,
    this.action = 0,
    this.exercises,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List?;
    List<Exercise>? exercisesList;

    if (exercisesFromJson != null) {
      exercisesList = exercisesFromJson.map((e) => Exercise.fromJson(e)).toList();
    }

    return Muscle(
      idMuscle: json['id_muscle'],
      nameOfMuscle: json['name_of_muscle'],
      supabaseIdMuscle: json['supabase_id_muscle'],
      action: json['action'] ?? 0,
      exercises: exercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_muscle': idMuscle,
      'name_of_muscle': nameOfMuscle,
      'supabase_id_muscle': supabaseIdMuscle,
      'action': action,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
    };
  }
}

class Exercise {
  int idExercise;
  String nameOfExercise;
  int? musclesIdMuscle;
  int? supabaseIdExercise;
  int? action;

  List<ExerciseData>? exerciseData;

  Exercise({
    required this.idExercise,
    required this.nameOfExercise,
    this.musclesIdMuscle,
    this.supabaseIdExercise,
    this.action = 0,
    this.exerciseData,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return Exercise(
      idExercise: json['id_exercise'],
      nameOfExercise: json['name_of_exercise'],
      musclesIdMuscle: json['muscles_id_muscle'],
      supabaseIdExercise: json['supabase_id_exercise'],
      action: json['action'] ?? 0,
      exerciseData: exerciseDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercise': idExercise,
      'name_of_exercise': nameOfExercise,
      'muscles_id_muscle': musclesIdMuscle,
      'supabase_id_exercise': supabaseIdExercise,
      'action': action,
      'exercise_data': exerciseData?.map((e) => e.toJson()).toList(),
    };
  }
}

class ExerciseData {
  static int _counter = 0; // Static counter to keep track of the ID

  int? idExData;
  int weight;
  int reps;
  int difficulty;
  String? technique;
  String? comment;
  String? time;
  int? exercisesIdExercise;
  int? idStartedCompleted;
  int? supabaseIdExData;
  int? action;
  int id; //auto incremment
  int? operation;

  ExerciseData({
    this.idExData,
    required this.weight,
    required this.reps,
    required this.difficulty,
    this.technique,
    this.comment,
    this.time,
    this.exercisesIdExercise,
    this.idStartedCompleted,
    this.supabaseIdExData,
    this.action = 0,
    this.operation,
  }) : id = _incrementCounter(); // Assign the incremented ID

  // Factory constructor to create an instance from a JSON object
  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      idExData: json['id_ex_data'],
      weight: json['weight'],
      reps: json['reps'],
      difficulty: json['difficulty'],
      technique: json['technique'],
      comment: json['comment'],
      time: json['time'],
      exercisesIdExercise: json['exercises_id_exercise'],
      idStartedCompleted: json['id_started_completed'],
      operation: json['operation'],
      action: json['action'] ?? 0,
      supabaseIdExData: json['supabase_id_ex_data'],
    );
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'weight': weight,
      'reps': reps,
      'difficulty': difficulty,
      'technique': technique,
      'comment': comment,
      'time': time,
      'exercises_id_exercise': exercisesIdExercise,
      'id_started_completed': idStartedCompleted,
      'operation': operation,
      'action': action,
      'supabase_id_ex_data': supabaseIdExData,
    };
    if (idExData != null) {
      data['id_ex_data'] = idExData;
    }
    return data;
  }

  // Static method to increment the counter and return the new value
  static int _incrementCounter() {
    return _counter++;
  }

  // Static method to reset the counter
  static void resetCounter() {
    _counter = 0;
  }
}

class Split {
  int? idSplit;
  String nameSplit;
  String? createdAt;
  int? supabaseIdSplit;
  int? action;
  List<SelectedMuscle>? selectedMuscle;
  List<SplitStartedCompleted>? splitStartedCompleted;

  Split({
    this.idSplit,
    required this.nameSplit,
    this.createdAt,
    this.supabaseIdSplit,
    this.action = 0,
    this.selectedMuscle,
    this.splitStartedCompleted,
  });

  factory Split.fromJson(Map<String, dynamic> json) {
    var selectedMuscleFromJson = json['selected_muscles'] as List<dynamic>? ?? [];
    List<SelectedMuscle> selectedMusclesList = selectedMuscleFromJson.map((e) => SelectedMuscle.fromJson(e)).toList();

    var splitStartedCompletedFromJson = json['split_started_completed'] as List<dynamic>? ?? []; //pokud jsou data null tak se nastaví prázdný seznam
    List<SplitStartedCompleted> splitStartedCompletedList = splitStartedCompletedFromJson
        .map(
          (e) => SplitStartedCompleted.fromJson(e),
        )
        .toList();

    return Split(
      idSplit: json['id_split'],
      nameSplit: json['name_split'],
      createdAt: json['created_at'],
      supabaseIdSplit: json['supabase_id_split'],
      action: json['action'] ?? 0,
      selectedMuscle: selectedMusclesList,
      splitStartedCompleted: splitStartedCompletedList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_split': idSplit,
      'name_split': nameSplit,
      'created_at': createdAt,
      'selected_muscles': selectedMuscle,
      'action': action,
      'supabase_id_split': supabaseIdSplit,
    };
  }
}

class SelectedMuscle {
  int idSelectedMuscle;
  int? splitIdSplit;
  int? musclesIdMuscle;
  int? supabaseIdSelectedMuscle;
  int? action;
  Muscle? muscles;
  List<SelectedExercise>? selectedExercises;

  SelectedMuscle({
    required this.idSelectedMuscle,
    this.splitIdSplit,
    this.musclesIdMuscle,
    this.supabaseIdSelectedMuscle,
    this.action,
    this.muscles,
    this.selectedExercises,
  });

  factory SelectedMuscle.fromJson(Map<String, dynamic> json) {
    var muscleFromJson = json['muscles'] != null ? json['muscles'] as Map<String, dynamic> : null;
    Muscle? muscles = muscleFromJson != null ? Muscle.fromJson(muscleFromJson) : null;

    var selectedExercisesFromJson = json['selected_exercise'] != null ? json['selected_exercise'] as List<dynamic> : [];
    List<SelectedExercise> selectedExercisesList = selectedExercisesFromJson.map((e) => SelectedExercise.fromJson(e as Map<String, dynamic>)).toList();

    return SelectedMuscle(
      idSelectedMuscle: json['id_selected_muscle'],
      splitIdSplit: json['split_id_split'],
      musclesIdMuscle: json['muscles_id_muscle'],
      supabaseIdSelectedMuscle: json['supabase_id_selected_muscle'],
      action: json['action'] ?? 0,
      muscles: muscles,
      selectedExercises: selectedExercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_selected_muscle': idSelectedMuscle,
      'split_id_split': splitIdSplit,
      'muscles_id_muscle': musclesIdMuscle,
      'supabase_id_selected_muscle': supabaseIdSelectedMuscle,
      'action': action,
      'muscles': muscles?.toJson(),
      'selected_exercises': selectedExercises?.map((e) => e.toJson()).toList(),
    };
  }
}

class SelectedExercise {
  int idSelectedExercise;
  int? idExercise;
  int? idSelectedMuscle;
  int? supabaseIdSelectedExercise;
  int? action;
  Exercise? exercises;

  SelectedExercise({
    required this.idSelectedExercise,
    this.idExercise,
    this.idSelectedMuscle,
    this.supabaseIdSelectedExercise,
    this.action,
    required this.exercises,
  });

  factory SelectedExercise.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] != null ? json['exercises'] as Map<String, dynamic> : null;
    Exercise? exercises = exercisesFromJson != null ? Exercise.fromJson(exercisesFromJson) : null;
    return SelectedExercise(
      idSelectedExercise: json['id_selected_exercise'],
      idExercise: json['id_exercise'],
      idSelectedMuscle: json['id_selected_muscle'],
      supabaseIdSelectedExercise: json['supabase_id_selected_exercise'],
      action: json['action'] ?? 0,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_selected_exercise': idSelectedExercise,
      'id_exercise': idExercise,
      'id_selected_muscle': idSelectedMuscle,
      'supabase_id_selected_exercise': supabaseIdSelectedExercise,
      'action': action,
      'exercises': exercises!.toJson(),
    };
  }
}

class SplitStartedCompleted {
  int? idStartedCompleted;
  String? createdAt;
  int? splitId;

  String? endedAt;
  bool ended;
  int? supabaseIdStartedCompleted;
  int? action;
  List<ExerciseData>? exerciseData;

  SplitStartedCompleted({
    this.idStartedCompleted,
    this.createdAt,
    this.splitId,
    this.endedAt,
    required this.ended,
    this.supabaseIdStartedCompleted,
    this.action = 0,
    this.exerciseData,
  });

  factory SplitStartedCompleted.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return SplitStartedCompleted(
      idStartedCompleted: json['id_started_completed'],
      createdAt: json['created_at'],
      splitId: json['split_id'],
      endedAt: json['ended_at'],
      ended: json['ended'] == 1 ? false : true,
      supabaseIdStartedCompleted: json['supabase_id_started_completed'],
      action: json['action'] ?? 0,
      exerciseData: exerciseDataList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_started_completed': idStartedCompleted,
      'created_ad': createdAt,
      'split_id': splitId,
      'ended_at': endedAt,
      'ended': ended,
      'supabase_id_started_completed': supabaseIdStartedCompleted,
      'action': action,
      'exercise_data': exerciseData,
    };
  }
}

class UserSupabase {
  int idUser;
  String name;
  String email;
  List<Muscle>? muscles;
  List<Split>? split;

  UserSupabase({
    required this.idUser,
    required this.name,
    required this.email,
    this.muscles,
    this.split,
  });

  factory UserSupabase.fromJson(Map<String, dynamic> json) {
    var musclesFromJson = json['muscles'] as List<dynamic>?; // Add null check
    List<Muscle>? musclesList = musclesFromJson?.map((e) => Muscle.fromJson(e)).toList();

    var splitsFromJson = json['split'] as List<dynamic>?; // Add null check
    List<Split>? splitList = splitsFromJson?.map((e) => Split.fromJson(e)).toList();

    return UserSupabase(
      idUser: json['id_user'],
      name: json['name'],
      email: json['email'],
      muscles: musclesList,
      split: splitList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'name': name,
      'email': email,
      'muscles': muscles,
      'split': split,
    };
  }
}
