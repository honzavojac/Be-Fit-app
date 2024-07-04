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
  int? operation;
  int id; //auto incremment
  int? idStartedCompleted;

  ExerciseData({this.idExData, required this.weight, required this.reps, required this.difficulty, this.technique, this.comment, this.time, this.exercisesIdExercise, this.operation, this.idStartedCompleted}) : id = _incrementCounter(); // Assign the incremented ID

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
      // 'time': time,
      'exercises_id_exercise': exercisesIdExercise,
      'id_started_completed': idStartedCompleted
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

class Exercise {
  int idExercise;
  String nameOfExercise;
  List<ExerciseData>? exerciseData;
  int? action;
  int? supabaseIdExercise;

  Exercise({required this.idExercise, required this.nameOfExercise, this.exerciseData, this.action = 0, this.supabaseIdExercise});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return Exercise(
      idExercise: json['id_exercise'],
      nameOfExercise: json['name_of_exercise'],
      exerciseData: exerciseDataList,
      action: json['action'] ?? 0,
      supabaseIdExercise: json['supabase_id_exercise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercise': idExercise,
      'name_of_exercise': nameOfExercise,
      'exercise_data': exerciseData?.map((e) => e.toJson()).toList(),
      'action': action,
      'supabase_id_exercise': supabaseIdExercise,
    };
  }
}

class Muscle {
  int? idMuscle;
  String nameOfMuscle;
  List<Exercise>? exercises;
  int? action;
  int? supabaseIdMuscle;

  Muscle({
    this.idMuscle,
    required this.nameOfMuscle,
    this.exercises,
    this.action = 0,
    this.supabaseIdMuscle,
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
      exercises: exercisesList,
      action: json['action'] ?? 0,
      supabaseIdMuscle: json['supabase_id_muscle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_muscle': idMuscle,
      'name_of_muscle': nameOfMuscle,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'action': action,
      'supabase_id_muscle': supabaseIdMuscle,
    };
  }
}

class SelectedMuscle {
  Muscle? muscles;
  int idSelectedMuscle;
  List<SelectedExercise>? selectedExercises;
  int? splitIdSplit;
  int? musclesIdMuscle;

  SelectedMuscle({
    this.muscles,
    required this.idSelectedMuscle,
    this.selectedExercises,
    this.splitIdSplit,
    this.musclesIdMuscle,
  });

  factory SelectedMuscle.fromJson(Map<String, dynamic> json) {
    var muscleFromJson = json['muscles'] != null ? json['muscles'] as Map<String, dynamic> : null;
    Muscle? muscles = muscleFromJson != null ? Muscle.fromJson(muscleFromJson) : null;

    var selectedExercisesFromJson = json['selected_exercise'] != null ? json['selected_exercise'] as List<dynamic> : [];
    List<SelectedExercise> selectedExercisesList = selectedExercisesFromJson.map((e) => SelectedExercise.fromJson(e as Map<String, dynamic>)).toList();

    return SelectedMuscle(
      muscles: muscles,
      idSelectedMuscle: json['id_selected_muscle'],
      selectedExercises: selectedExercisesList,
      musclesIdMuscle: json['muscles_id_muscle'],
      splitIdSplit: json['split_id_split'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muscles': muscles?.toJson(),
      'id_selected_muscle': idSelectedMuscle,
      'selected_exercises': selectedExercises?.map((e) => e.toJson()).toList(),
      'muscles_id_muscle': musclesIdMuscle,
      'split_id_split': splitIdSplit,
    };
  }
}

class SelectedExercise {
  Exercise? exercises;
  int idSelectedExercise;
  int? idExercise;
  int? idSelectedMuscle;

  SelectedExercise({
    required this.exercises,
    required this.idSelectedExercise,
    this.idExercise,
    this.idSelectedMuscle,
  });

  factory SelectedExercise.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] != null ? json['exercises'] as Map<String, dynamic> : null;
    Exercise? exercises = exercisesFromJson != null ? Exercise.fromJson(exercisesFromJson) : null;
    return SelectedExercise(
      exercises: exercises,
      idSelectedExercise: json['id_selected_exercise'],
      idExercise: json['id_exercise'],
      idSelectedMuscle: json['id_selected_muscle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercises': exercises!.toJson(),
      'id_selected_exercise': idSelectedExercise,
      'id_exercise': idExercise,
      'id_selected_muscle': idSelectedMuscle,
    };
  }
}

class SplitStartedCompleted {
  int? idStartedCompleted;
  int? splitId;
  String? createdAt;
  String? endedAt;
  bool ended;
  List<ExerciseData>? exerciseData;

  SplitStartedCompleted({
    this.idStartedCompleted,
    this.splitId,
    this.createdAt,
    this.endedAt,
    this.exerciseData,
    required this.ended,
  });

  factory SplitStartedCompleted.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return SplitStartedCompleted(
      idStartedCompleted: json['id_started_completed'],
      splitId: json['split_id'],
      createdAt: json['created_at'],
      endedAt: json['ended_at'],
      ended: json['ended'],
      exerciseData: exerciseDataList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_started_completed': idStartedCompleted,
      'split_id': splitId,
      'created_ad': createdAt,
      'ended_at': endedAt,
      'ended': ended,
      'exercise_data': exerciseData,
    };
  }
}

class Split {
  int? idSplit;
  String nameSplit;
  List<SelectedMuscle>? selectedMuscle;
  List<SplitStartedCompleted>? splitStartedCompleted;

  Split({
    this.idSplit,
    required this.nameSplit,
    this.selectedMuscle,
    this.splitStartedCompleted,
  });

  factory Split.fromJson(Map<String, dynamic> json) {
    var selectedMuscleFromJson = json['selected_muscles'] as List<dynamic>? ?? [];
    List<SelectedMuscle> selectedMusclesList = selectedMuscleFromJson.map((e) => SelectedMuscle.fromJson(e)).toList();

    var splitStartedCompletedFromJson = json['split_started_completed'] as List<dynamic>? ?? []; //pokud jsou data null tak se nastaví prázdný seznam
    List<SplitStartedCompleted> splitStartedCompletedList = splitStartedCompletedFromJson.map((e) => SplitStartedCompleted.fromJson(e)).toList();

    return Split(
      idSplit: json['id_split'],
      nameSplit: json['name_split'],
      selectedMuscle: selectedMusclesList,
      splitStartedCompleted: splitStartedCompletedList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_split': idSplit,
      'name_split': nameSplit,
      'selected_muscles': selectedMuscle,
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
