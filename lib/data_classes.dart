import 'package:intl/intl.dart';

class Muscle {
  int? idMuscle;
  String? nameOfMuscle;

  int? action;
  int? supabaseIdMuscle;
  List<Exercise>? exercises;
  int? idUser;

  Muscle({
    this.idMuscle,
    this.nameOfMuscle,
    this.supabaseIdMuscle,
    this.action = 0,
    this.exercises,
    this.idUser,
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
      // 'supabase_id_muscle': supabaseIdMuscle,
      // 'action': action,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      // 'users_id_user': idUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_muscle': idMuscle,
      'name_of_muscle': nameOfMuscle,
    };
  }

  printMuscle() {
    print(
      "id_muscle: $idMuscle  *** supabase_id_muscle: $supabaseIdMuscle *** action: $action *** name_of_muscle: $nameOfMuscle",
    );
  }
}

class Exercise {
  int? idExercise;
  String? nameOfExercise;
  int? musclesIdMuscle;
  int? supabaseIdExercise;
  int? action;
  int? idUser;

  List<ExerciseData>? exerciseData;

  Exercise({
    this.idExercise,
    this.nameOfExercise,
    this.musclesIdMuscle,
    this.supabaseIdExercise,
    this.action = 0,
    this.exerciseData,
    this.idUser,
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
      // 'supabase_id_exercise': supabaseIdExercise,
      // 'action': action,
      'exercise_data': exerciseData?.map((e) => e.toJson()).toList(),
      // 'users_id_user': idUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_exercise': idExercise,
      'name_of_exercise': nameOfExercise,
      'muscles_id_muscle': musclesIdMuscle,
      // 'supabase_id_exercise': supabaseIdExercise,
      // 'action': action,
      // 'users_id_user': idUser,
    };
  }

  printExercise() {
    print(
      "id_exercise: $idExercise *** muscles_id_muscle: $musclesIdMuscle *** supabase_id_exercise: $supabaseIdExercise *** action: $action *** name_of_exercise: $nameOfExercise",
    );
  }
}

class ExerciseData {
  static int _counter = 0; // Static counter to keep track of the ID

  int? idExData;
  int? weight;
  int? reps;
  int? difficulty;
  String? technique;
  String? comment;
  String? time;
  int? exercisesIdExercise;
  int? idStartedCompleted;
  int? supabaseIdExData;
  int? action;
  int id; //auto incremment
  int? operation;
  int? idUser;

  ExerciseData({
    this.idExData,
    this.weight,
    this.reps,
    this.difficulty,
    this.technique,
    this.comment,
    this.time,
    this.exercisesIdExercise,
    this.idStartedCompleted,
    this.supabaseIdExData,
    this.action = 0,
    this.operation,
    this.idUser,
  }) : id = _incrementCounter(); // Assign the incremented ID

  // Factory constructor to create an instance from a JSON object
  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      idExData: json['id_ex_data'],
      weight: json['weight'],
      reps: json['reps'],
      difficulty: json['difficulty'],
      technique: json['technique'] as String?,
      comment: json['comment'] as String?,
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
      // 'time': time,
      'exercises_id_exercise': exercisesIdExercise,
      'id_started_completed': idStartedCompleted,
      // 'operation': operation,
      // 'action': action,
      // 'supabase_id_ex_data': supabaseIdExData,
      // 'users_id_user': idUser,
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

  printExerciseData() {
    print("id_ex_data: $idExData *** weight: $weight *** reps: $reps *** difficulty: $difficulty *** technique: $technique *** comment: $comment *** time: ${time!.replaceRange(10, time!.length, "")} *** exercises_id_exercise: $exercisesIdExercise *** id_started_completed: $idStartedCompleted *** operation: $operation *** action: $action *** supabase_id_ex_data: $supabaseIdExData");
  }
}

class MySplit {
  int? idSplit;
  String nameSplit;
  String? createdAt;
  int? supabaseIdSplit;
  int? action;
  List<SelectedMuscle>? selectedMuscle;
  List<SplitStartedCompleted>? splitStartedCompleted;
  int? idUser;
  bool isActive;

  MySplit({
    this.idSplit,
    required this.nameSplit,
    this.createdAt,
    this.supabaseIdSplit,
    this.action = 0,
    this.selectedMuscle,
    this.splitStartedCompleted,
    this.idUser,
    required this.isActive,
  });

  factory MySplit.fromJson(Map<String, dynamic> json) {
    var selectedMuscleFromJson = json['selected_muscles'] as List<dynamic>? ?? [];
    List<SelectedMuscle> selectedMusclesList = selectedMuscleFromJson.map((e) => SelectedMuscle.fromJson(e)).toList();

    var splitStartedCompletedFromJson = json['split_started_completed'] as List<dynamic>? ?? []; //pokud jsou data null tak se nastaví prázdný seznam
    List<SplitStartedCompleted> splitStartedCompletedList = splitStartedCompletedFromJson
        .map(
          (e) => SplitStartedCompleted.fromJson(e),
        )
        .toList();

    return MySplit(
      idSplit: json['id_split'],
      nameSplit: json['name_split'],
      createdAt: json['created_at'],
      supabaseIdSplit: json['supabase_id_split'],
      action: json['action'] ?? 0,
      selectedMuscle: selectedMusclesList,
      splitStartedCompleted: splitStartedCompletedList,
      isActive: json['is_active'] is bool ? json['is_active'] : (json['is_active'] as int) != 0,
    );
  }
  Map<String, dynamic> toJson() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy:MM:dd').format(date);

    return {
      'id_split': idSplit,
      'name_split': nameSplit,
      'created_at': createdAt ?? formattedDate,
      'users_id_user': idUser,
      'selected_muscles': selectedMuscle,
      'is_active': isActive,
      // 'action': action,
      // 'supabase_id_split': supabaseIdSplit,
    };
  }

  Map<String, dynamic> toMap() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy:MM:dd').format(date);

    return {
      'id_split': idSplit,
      'name_split': nameSplit,
      'created_at': createdAt ?? formattedDate,
      'is_active': isActive
      // 'users_id_user': idUser,
      // 'selected_muscles': selectedMuscle,
      // 'action': action,
      // 'supabase_id_split': supabaseIdSplit,
    };
  }

  printSplit() {
    print("id_split: $idSplit *** is_active: $isActive *** name_split: $nameSplit *** created_at: $createdAt ***  action: $action *** supabase_id_split: $supabaseIdSplit *** selected_muscles: $selectedMuscle");
  }
}

class SelectedMuscle {
  int? idSelectedMuscle;
  int? splitIdSplit;
  int? musclesIdMuscle;
  int? supabaseIdSelectedMuscle;
  int? action;
  Muscle? muscles;
  List<SelectedExercise>? selectedExercises;
  int? idUser;

  SelectedMuscle({
    this.idSelectedMuscle,
    this.splitIdSplit,
    this.musclesIdMuscle,
    this.supabaseIdSelectedMuscle,
    this.action,
    this.muscles,
    this.selectedExercises,
    this.idUser,
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
      // 'supabase_id_selected_muscle': supabaseIdSelectedMuscle,
      // 'action': action,
      'muscles': muscles?.toJson(),
      'selected_exercises': selectedExercises?.map((e) => e.toJson()).toList(),
      // 'users_id_user': idUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_selected_muscle': idSelectedMuscle,
      'split_id_split': splitIdSplit,
      'muscles_id_muscle': musclesIdMuscle,
      // 'supabase_id_selected_muscle': supabaseIdSelectedMuscle,
      // 'action': action,
      // 'muscles': muscles?.toJson(),
      // 'selected_exercises': selectedExercises?.map((e) => e.toJson()).toList(),
      // 'users_id_user': idUser,
    };
  }

  printSelectedMuscle() {
    print("id_selected_muscle: $idSelectedMuscle *** split_id_split: $splitIdSplit *** muscles_id_muscle: $musclesIdMuscle *** supabase_id_muscle: $supabaseIdSelectedMuscle *** action: $action *** muscles: $muscles ");
  }
}

class SelectedExercise {
  int? idSelectedExercise;
  int? idExercise;
  int? idSelectedMuscle;
  int? supabaseIdSelectedExercise;
  int? action;
  Exercise? exercises;
  int? idUser;

  SelectedExercise({
    this.idSelectedExercise,
    this.idExercise,
    this.idSelectedMuscle,
    this.supabaseIdSelectedExercise,
    this.action,
    this.exercises,
    this.idUser,
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
      // 'supabase_id_selected_exercise': supabaseIdSelectedExercise,
      // 'action': action,
      'exercises': exercises!.toJson(),
      // 'users_id_user': idUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_selected_exercise': idSelectedExercise,
      'id_exercise': idExercise,
      'id_selected_muscle': idSelectedMuscle,
      // 'supabase_id_selected_exercise': supabaseIdSelectedExercise,
      // 'action': action,
      // 'exercises': exercises!.toJson(),
      // 'users_id_user': idUser,
    };
  }

  printSelectedExercise() {
    print(
      "id_selected_exercise: $idSelectedExercise *** id_exercise: $idExercise *** id_selected_muscle: $idSelectedMuscle *** supabase_id_exercise: $supabaseIdSelectedExercise *** action: $action *** exercises: $exercises ",
    );
  }
}

class SplitStartedCompleted {
  int? idStartedCompleted;
  String? createdAt;
  int? splitId;

  String? endedAt;
  bool? ended;
  int? supabaseIdStartedCompleted;
  int? action;
  List<ExerciseData>? exerciseData;
  int? idUser;
  String? name;
  int? numberOfSets = 0;
  int? totalWorkVolume = 0;

  SplitStartedCompleted({
    this.idStartedCompleted,
    this.createdAt,
    this.splitId,
    this.endedAt,
    required this.ended,
    this.supabaseIdStartedCompleted,
    this.action = 0,
    this.exerciseData,
    this.idUser,
    this.name,
    this.numberOfSets,
    this.totalWorkVolume,
  });

  factory SplitStartedCompleted.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();
    var lateEnded = json['ended'];
    bool ended;
    if (lateEnded == 1 || lateEnded == true) {
      ended = true;
    } else {
      ended = false;
    }
    return SplitStartedCompleted(
      idStartedCompleted: json['id_started_completed'],
      createdAt: json['created_at'],
      splitId: json['split_id'],
      endedAt: json['ended_at'],
      ended: ended,
      supabaseIdStartedCompleted: json['supabase_id_started_completed'],
      action: json['action'] ?? 0,
      exerciseData: exerciseDataList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_started_completed': idStartedCompleted,
      'created_at': createdAt,
      'split_id': splitId,
      'ended_at': endedAt,
      'ended': ended,
      // 'supabase_id_started_completed': supabaseIdStartedCompleted,
      // 'action': action,
      'exercise_data': exerciseData,
      'users_id_user': idUser,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_started_completed': idStartedCompleted,
      'created_at': createdAt,
      'split_id': splitId,
      'ended_at': endedAt,
      'ended': ended == true ? 1 : 0,
      // 'supabase_id_started_completed': supabaseIdStartedCompleted,
      // 'action': action,
      // 'exercise_data': exerciseData,
      // 'users_id_user': idUser,
    };
  }

  printSplitStartedCompleted() {
    print(
      "id_started_completed: $idStartedCompleted *** created_at: $createdAt *** split_id: $splitId *** ended_at: $endedAt *** ended: $ended *** supabase_is_started_completed: $supabaseIdStartedCompleted *** action: $action *** exercise_data: $exerciseData",
    );
  }
}

class UserSupabase {
  int idUser;
  String name;
  String email;
  String? dateOfBirth; // Optional, can be null
  String? country; // Optional, can be null
  int? action;
  List<Muscle>? muscles; // Optional, can be null
  List<MySplit>? split; // Optional, can be null

  UserSupabase({
    required this.idUser,
    required this.name,
    required this.email,
    this.dateOfBirth,
    this.country,
    this.action,
    this.muscles,
    this.split,
  });

  // Factory constructor for creating a new UserSupabase instance from a map.
  factory UserSupabase.fromJson(Map<String, dynamic> json) {
    var musclesFromJson = json['muscles'] as List<dynamic>?; // Check for null
    List<Muscle>? musclesList = musclesFromJson?.map((e) => Muscle.fromJson(e)).toList();

    var splitsFromJson = json['split'] as List<dynamic>?; // Check for null
    List<MySplit>? splitList = splitsFromJson?.map((e) => MySplit.fromJson(e)).toList();

    return UserSupabase(
      idUser: json['id_user'],
      name: json['name'],
      email: json['email'],
      dateOfBirth: json['birth_date'], // Null check not needed, it's optional
      country: json['country'], // Optional field for country
      action: json['action'],
      muscles: musclesList,
      split: splitList,
    );
  }

  // Method for converting a UserSupabase instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'name': name,
      'email': email,
      'birth_date': dateOfBirth, // Include date of birth if available
      'country': country, // Include country if available
      'action': action,
      'muscles': muscles?.map((e) => e.toJson()).toList(), // Convert each Muscle to JSON
      'split': split?.map((e) => e.toJson()).toList(), // Convert each MySplit to JSON
    };
  }
}

class Measurements {
  int? idBodyMeasurements;
  double? weight;
  int? height;
  double? abdominalCircumference;
  double? chestCircumference;
  double? waistCircumference;
  double? thighCircumference;
  double? neckCircumference;
  double? bicepsCircumference;
  String? createdAt;
  int? supabaseIdBodyMeasurements;
  int? action;

  Measurements({
    this.idBodyMeasurements,
    this.weight,
    this.height,
    this.abdominalCircumference,
    this.chestCircumference,
    this.waistCircumference,
    this.thighCircumference,
    this.neckCircumference,
    this.bicepsCircumference,
    this.createdAt,
    this.supabaseIdBodyMeasurements,
    this.action,
  });

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      idBodyMeasurements: json['id_body_measurements'],
      weight: double.tryParse(json['weight'].toString()),
      height: json['height'],
      abdominalCircumference: double.tryParse(json['abdominal_circumference'].toString()),
      chestCircumference: double.tryParse(json['chest_circumference'].toString()),
      waistCircumference: double.tryParse(json['waist_circumference'].toString()),
      thighCircumference: double.tryParse(json['thigh_circumference'].toString()),
      neckCircumference: double.tryParse(json['neck_circumference'].toString()),
      bicepsCircumference: double.tryParse(json['biceps_circumference'].toString()),
      createdAt: json['created_at'],
      supabaseIdBodyMeasurements: json['supabase_id_body_measurements'],
      action: json['action'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_body_measurements': idBodyMeasurements,
      'weight': weight,
      'height': height,
      'abdominal_circumference': abdominalCircumference,
      'chest_circumference': chestCircumference,
      'waist_circumference': waistCircumference,
      'thigh_circumference': thighCircumference,
      'neck_circumference': neckCircumference,
      'biceps_circumference': bicepsCircumference,
      'created_at': createdAt,
      'supabase_id_body_measurements': supabaseIdBodyMeasurements,
      'action': action,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id_body_measurements': idBodyMeasurements,
      'weight': weight,
      'height': height,
      'abdominal_circumference': abdominalCircumference,
      'chest_circumference': chestCircumference,
      'waist_circumference': waistCircumference,
      'thigh_circumference': thighCircumference,
      'neck_circumference': neckCircumference,
      'biceps_circumference': bicepsCircumference,
      'created_at': createdAt,
      'supabase_id_body_measurements': supabaseIdBodyMeasurements,
      'action': action,
    };
  }
}

class Food {
  int? idFood;
  String? country;
  String? name;
  String? unaccentName; // Add this field
  String? recentlyUsed;
  int? weight;
  String? quantity;
  double? kcal;
  double? protein;
  double? carbs;
  double? sugar;
  double? fat;
  double? fatSatureated;
  double? fatTrans;
  double? fatMonounsatureted;
  double? fatPolyunsatureted;
  double? fiber;
  double? water;
  double? cholesterol;
  int? intakeCategory;
  int? supabaseIdFood;
  int? action;
  String? createdAt;
  int? idNutriIntake;
  int? insertedByIdUser;

  Food({
    this.idFood,
    this.country,
    this.name,
    this.unaccentName, // Add this parameter
    this.recentlyUsed,
    this.weight,
    this.quantity,
    this.kcal,
    this.protein,
    this.carbs,
    this.sugar,
    this.fat,
    this.fatSatureated,
    this.fatTrans,
    this.fatMonounsatureted,
    this.fatPolyunsatureted,
    this.fiber,
    this.water,
    this.cholesterol,
    this.intakeCategory,
    this.supabaseIdFood,
    this.action,
    this.createdAt,
    this.idNutriIntake,
    this.insertedByIdUser,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      idFood: json['id_food'],
      country: json['country'],
      name: json['name'],
      unaccentName: json['unaccent_name'], // Add this line
      weight: json['weight'],
      quantity: json['quantity'],
      kcal: double.tryParse(json['kcal'].toString()),
      protein: double.tryParse(json['protein'].toString()),
      carbs: double.tryParse(json['carbs'].toString()),
      sugar: double.tryParse(json['sugar'].toString()),
      fat: double.tryParse(json['fat'].toString()),
      fatSatureated: double.tryParse(json['fat_saturated'].toString()),
      fatTrans: double.tryParse(json['fat_trans'].toString()),
      fatMonounsatureted: double.tryParse(json['fat_monounsaturated'].toString()),
      fatPolyunsatureted: double.tryParse(json['fat_polyunsaturated'].toString()),
      fiber: double.tryParse(json['fiber'].toString()),
      water: double.tryParse(json['water'].toString()),
      cholesterol: double.tryParse(json['cholesterol'].toString()),
      supabaseIdFood: json['supabase_id_food'],
      action: json['action'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id_food': idFood,
      'country': country,
      'name': name,
      'unaccent_name': unaccentName, // Add this line
      'weight': weight,
      'quantity': quantity,
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'sugar': sugar,
      'fat': fat,
      'fat_saturated': fatSatureated,
      'fat_trans': fatTrans,
      'fat_monounsaturated': fatMonounsatureted,
      'fat_polyunsaturated': fatPolyunsatureted,
      'fiber': fiber,
      'water': water,
      'cholesterol': cholesterol,
      'created_at': createdAt,
      'inserted_by_id_user': insertedByIdUser,
    };
  }

  @override
  String toString() {
    return 'Food(idFood: $idFood, country: $country, name: $name, unaccentName: $unaccentName, weight: $weight, quantity: $quantity, kcal: $kcal, protein: $protein, carbs: $carbs, sugar: $sugar, fat: $fat, fatSatureated: $fatSatureated, fatTrans: $fatTrans, fatMonounsatureted: $fatMonounsatureted, fatPolyunsatureted: $fatPolyunsatureted, fiber: $fiber, water: $water, cholesterol: $cholesterol, supabaseIdFood: $supabaseIdFood, action: $action, createdAt: $createdAt)';
  }
}

class NutriIntake {
  int? idNutriIntake;
  String? createdAt;
  int? idFood;
  String? quantity;
  int? weight;
  int? intakeCategory; // Opraveno na intakeCategory
  int? supabaseIdNutriIntake;
  int? action;

  NutriIntake({
    this.idNutriIntake,
    this.createdAt,
    this.idFood,
    this.quantity,
    this.weight,
    this.intakeCategory, // Přidáno do konstruktoru
    this.supabaseIdNutriIntake,
    this.action,
  });

  // Convert from JSON
  factory NutriIntake.fromJson(Map<String, dynamic> json) {
    return NutriIntake(
      idNutriIntake: json['id_nutri_intake'],
      createdAt: json['created_at'],
      idFood: json['id_food'],
      quantity: json['quantity'],
      weight: json['weight'],
      intakeCategory: json['id_intake_category'], // Přidáno pro intakeCategory
      supabaseIdNutriIntake: json['supabase_id_nutri_intake'],
      action: json['action'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_nutri_intake': idNutriIntake,
      'created_at': createdAt, // Opraveno 'creatcreated_atedAt' na 'created_at'
      'id_food': idFood,
      'quantity': quantity,
      'weight': weight,
      'id_intake_category': intakeCategory, // Přidáno pro intakeCategory
      'supabase_id_nutri_intake': supabaseIdNutriIntake,
      'action': action,
    };
  }

  @override
  String toString() {
    return 'NutriIntake(idNutriIntake: $idNutriIntake, createdAt: $createdAt, idFood: $idFood, quantity: $quantity, weight: $weight, intakeCategory: $intakeCategory, supabaseIdNutriIntake: $supabaseIdNutriIntake, action: $action)';
  }
}

class IntakeCategories {
  int? idIntakeCategory;
  String? name;
  int? supabaseIdIntakeCategory;
  int? action;

  IntakeCategories({
    this.idIntakeCategory,
    this.name,
    this.supabaseIdIntakeCategory,
    this.action,
  });

  // Named constructor for creating an object from a JSON map
  factory IntakeCategories.fromJson(Map<String, dynamic> json) {
    return IntakeCategories(
      idIntakeCategory: json['id_intake_category'],
      name: json['name'],
      supabaseIdIntakeCategory: json['supabase_id_intake_category'],
      action: json['action'],
    );
  }

  // Method to convert the object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id_intake_category': idIntakeCategory,
      'name': name,
      'supabase_id_intake_category': supabaseIdIntakeCategory,
      'action': action,
    };
  }

  // Overriding toString method for easier debugging
  @override
  String toString() {
    return 'IntakeCategories(idIntakeCategory: $idIntakeCategory, name: $name, supabaseIdIntakeCategory: $supabaseIdIntakeCategory, action: $action)';
  }
}
