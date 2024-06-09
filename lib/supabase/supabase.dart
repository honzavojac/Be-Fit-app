import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends ChangeNotifier {
  final url = 'https://gznwbuvjfglgrcckmzeg.supabase.co';
  final anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6bndidXZqZmdsZ3JjY2ttemVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM5NTM5MzYsImV4cCI6MjAyOTUyOTkzNn0.uHx0t0ZRYQm-mLj3laHNCJgy2YOCTshv1TL0bcEod4E";
  var db;
  var dbS;
  var uid;
  User? user;
  String name = '';
  List<Split> splits = List.empty();
  String? splitText;
  //pro jednotlivé stránky pro správu stavu
  //split_page
  int clickedSplitTab = 0;
  int? muscleIndex;
  // new_musle
  List<Muscle> muscles = [];
  List<bool> isCheckedList = List.empty();
  generateFalseMuscleCheckbox() async {
    isCheckedList = List.generate(muscles.length, (index) => false);
  }

  //add_split_box
  clearTextController() {
    splitText = '';
  }

  setTextController() {
    return splitText;
  }

  void clearUserData() {
    db = null;
    dbS = null;
    uid = null;
    user = null;
    name = '';
    splits = List.empty();
    splitText = null;
    // clickedSplitTab = -1;
    muscleIndex = null;
    muscles = List.empty();
    isCheckedList = List.empty();
  }

  //add_exercise_box
  int initChecklist = 0;
  List<bool> exercisesCheckedList = List.empty();
  generateFalseExerciseCheckbox(int idSplit, int idMuscle) async {
    exercisesCheckedList = List.empty();
    exercisesCheckedList = await List.generate(splits[idSplit].selectedMuscle![idMuscle].muscles!.exercises!.length, (index) => false);
  }

  initialize() async {
    db = await Supabase.initialize(url: url, anonKey: anonKey);

    print("supabase inicializována");
    try {
      uid = supabase.auth.currentUser!.id;
    } catch (e) {}
  }

  Future<User?> getUser() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('id_user, name, email').eq('user_id', uid);
    // print(response);
    User localUser = User.fromJson(response.first);
    user = localUser;
    name = localUser.name;
    // print(localUser.name);
    return localUser;
  }

  Map<String, String> getTodayDateRange() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final todayEnd = todayStart.add(Duration(days: 1));

    final dateFormatter = DateFormat('yyyy-MM-ddTHH:mm:ss');

    return {
      'start': dateFormatter.format(todayStart),
      'end': dateFormatter.format(todayEnd),
    };
  }

  getFitness() async {
    final uid = supabase.auth.currentUser!.id;
    final dateRange = getTodayDateRange();

    final response = await supabase
        .from('users')
        .select('''
    split (
      id_split,
      name_split,
      selected_muscles (
        id_selected_muscle,
        muscles (
          name_of_muscle,
          exercises (
            id_exercise,
            name_of_exercise
          )
        ),
        selected_exercise (
          id_selected_muscle,
          id_selected_exercise,
          exercises (
            id_exercise,
            name_of_exercise,exercise_data (
              id_ex_data,
              weight,
              reps,
              difficulty,
              technique,
              time
            )
          )
        )
      )
    )
  ''')
        .eq('user_id', uid)
        .gte(
          'split.selected_muscles.selected_exercise.exercises.exercise_data.time',
          dateRange['start']!,
        )
        .lt(
          'split.selected_muscles.selected_exercise.exercises.exercise_data.time',
          dateRange['end']!,
        )
        .order('id_ex_data', referencedTable: 'split.selected_muscles.selected_exercise.exercises.exercise_data', ascending: true);

    final List<dynamic> data = response[0]['split'];
    splits = data.map((json) => Split.fromJson(json as Map<String, dynamic>)).toList();

    // for (var i = 0; i < split.length; i++) {
    //   print(split[i].nameSplit);
    //   for (var y = 0; y < split[y].nameSplit.length; y++) {
    //     print('object');
    //   }
    // }

    // for (var split in splits) {
    //   print("Split name: ${split.nameSplit}");
    //   for (var SelectedMuscle in split.selectedMuscle!) {
    //     print("  Muscle name: ${SelectedMuscle.muscles!.nameOfMuscle}");
    //     // if (SelectedMuscle.muscles[0].exercises != null) {
    //     //   for (var exercise in SelectedMuscle.muscles[0].exercises!) {
    //     //     print("   Exercise name: ${exercise.nameOfExercise}");

    //     //     for (var exerciseData in exercise.exerciseData!) {
    //     //       if (DateTime.now().toString().replaceRange(10, null, '') == exerciseData.time?.replaceRange(10, null, '')) {
    //     //         print("    záznam: weight: ${exerciseData.weight} reps: ${exerciseData.reps} difficulty: ${exerciseData.difficulty} technique: ${exerciseData.technique} time: ${exerciseData.time?.replaceRange(10, null, '') ?? null}");
    //     //       }
    //     //     }
    //     //   }
    //     // }
    //   }
    // }
    // notifyListeners();
  }

  getAllMuscles() async {
    final uid = supabase.auth.currentUser!.id;
    final response = await supabase.from('users').select('''
      muscles (
              id_muscle,
              name_of_muscle,
              exercises (
                id_exercise,
                name_of_exercise
              )
            )
  ''').eq('user_id', uid);

    // print(response[0].toString());
    final List<dynamic> data = response[0]['muscles'];
    muscles = data.map((json) => Muscle.fromJson(json as Map<String, dynamic>)).toList();
  }

  int inserted = 0;
  insertSplit(String nameSplit, int idMuscle) async {
    var idRow;
    if (inserted == 0) {
      idRow = await supabase.from('split').insert({'name_split': nameSplit, 'users_id_user': user!.idUser}).select('id_split');
      inserted = 1;
    } else {
      idRow = await supabase.from('split').select('id_split').eq('name_split', nameSplit).eq('users_id_user', user!.idUser);
    }

    int splitIdSplit = idRow.first['id_split'];
    await supabase.from('selected_muscles').insert({'split_id_split': splitIdSplit, 'muscles_id_muscle': idMuscle});
  }

  deleteSplit(int idSplit) async {
    print(idSplit);
    //odstranění hodnoty z tabulky selected_muscles
    await supabase.from('selected_muscles').delete().match({'split_id_split': idSplit});
    //odstranění hodnoty z tabulky split
    await supabase.from('split').delete().match({'id_split': idSplit});
    notifyListeners();
  }

  insertMuscle(String nameOfMuscle) async {
    await supabase.from('muscles').insert({'name_of_muscle': nameOfMuscle, 'id_user': user!.idUser});
  }

  updateName(String newName) async {
    await supabase.from('users').update({'name': '$newName'}).eq('user_id', uid);
  }

  // data() async {
  //   final dat = await supabase.from('split').select('''
  //     name_split,
  //     selected_muscles (
  //       muscles (
  //         name_of_muscle,
  //         exercises (
  //           name_of_exercise
  //         )
  //       )
  //     )
  // ''').eq('user_id', supabase.auth.currentUser!.id).order('id_user', ascending: true);

  //   // final List<dynamic> jsonData = dat.data;
  //   List<User> users = dat.map((e) => User.fromJson(e)).toList();
  //   // print(users);
  //   for (var user in users) {
  //     print("${user.idUser} ${user.name}");
  //     // for (var split in user.split) {
  //     //   print("  ${split.nameSplit}");
  //     //   for (var SelectedMuscle in split.selectedMuscle) {
  //     //     print('    ${SelectedMuscle.muscles.nameOfMuscle}');
  //     //     for (var exercise in SelectedMuscle.muscles.exercises) {
  //     //       print("      ${exercise.nameOfExercise}");
  //     //     }
  //     //   }
  //     // }
  //   }
  // }
  insertExercise(String nameOfExercise, int idMuscle) async {
    await supabase.from('exercises').insert({'name_of_exercise': nameOfExercise, 'muscles_id_muscle': idMuscle});
  }

  updateSelectedExercise(
    int idExercise,
    String nameOfExercise,
    bool isChecked,
    int idSelectedMuscle,
    int splitIndex,
    int muscleIndex,
    int exerciseIndex,
  ) async {
    int idSelectedExercise;
    print("idExercise $idExercise, nameOfExercise $nameOfExercise, idSelectedMuscle $idSelectedMuscle, splitIndex $splitIndex, muscleIndex $muscleIndex, exerciseIndex $exerciseIndex");
    int i = 0;
    for (var element in splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises!) {
      print("$i - ${element.exercises.nameOfExercise}");
      i++;
    }
    if (isChecked) {
      //pokud je cvik označen tak insert row
      await supabase.from('selected_exercise').insert({'id_exercise': idExercise, 'id_selected_muscle': idSelectedMuscle});
    } else {
      //pokud není cvik označen tak delete row
      for (var i = 0; i < splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises!.length; i++) {
        var exerciseName = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![i].exercises.nameOfExercise;
        if (exerciseName == nameOfExercise) {
          idSelectedExercise = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![i].idSelectedExercise;
          await supabase.from('selected_exercise').delete().match({'id_selected_exercise': idSelectedExercise});
        }
      }

      // idSelectedExercise = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].idSelectedExercise!;
    }
  }

  Future<void> actionExerciseData(List<ExerciseData> exerciseData, int idExercise) async {
    // Převod TextEditingController na seznam int hodnot
    // for (var element in exerciseData) {
    //   print(element.operation);
    // }

    for (var i = 0; i < exerciseData.length; i++) {
      var dataOfExercise = exerciseData[i];
      switch (exerciseData[i].operation) {
        case 0 || null:
          //hodnota zůstává
          print("hodnota zůstává");
          break;
        case 1:
          print("insert");

          try {
            // print("insert: ${insert[i]}");
            await supabase.from('exercise_data').insert(ExerciseData(
                  weight: dataOfExercise.weight,
                  reps: dataOfExercise.reps,
                  difficulty: dataOfExercise.difficulty,
                  exercisesIdExercise: idExercise,
                ).toJson());
            // insert(insert);
          } catch (e) {
            print("insert se nezdařil: $e");
          }
          break;
        case 2:
          print("update");

          try {
            print("update: ${dataOfExercise.reps}");
            await supabase
                .from('exercise_data')
                .update(ExerciseData(
                  weight: dataOfExercise.weight,
                  reps: dataOfExercise.reps,
                  difficulty: dataOfExercise.difficulty,
                  exercisesIdExercise: idExercise,
                  time: dataOfExercise.time,
                ).toJson())
                .match({'id_ex_data': dataOfExercise.idExData!});
          } catch (e) {
            print("update se nezdařil: $e");
          }
          break;
        case 3:
          print("delete");

          try {
            // print("delete: ${delete[i]}");
            await supabase.from('exercise_data').delete().eq('id_ex_data', dataOfExercise.idExData!);
          } catch (e) {
            print("delete se nezdařil: $e");
          }
          break;
        case 4:
          print("nothing");
          //nothing
          //hodnota byla insertována a pak smázana
          break;
        default:
      }
    }

    // efresh data
    await getFitness();
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
  int? operation;
  int id;

  ExerciseData({
    this.idExData,
    required this.weight,
    required this.reps,
    required this.difficulty,
    this.technique,
    this.comment,
    this.time,
    this.exercisesIdExercise,
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

  Exercise({
    required this.idExercise,
    required this.nameOfExercise,
    this.exerciseData,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return Exercise(
      idExercise: json['id_exercise'],
      nameOfExercise: json['name_of_exercise'],
      exerciseData: exerciseDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exercise': idExercise,
      'name_of_exercise': nameOfExercise,
      'exercise_data': exerciseData?.map((e) => e.toJson()).toList(),
    };
  }
}

class Muscle {
  int? idMuscle;
  String nameOfMuscle;
  List<Exercise>? exercises;

  Muscle({
    this.idMuscle,
    required this.nameOfMuscle,
    this.exercises,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List;
    List<Exercise> exercisesList = exercisesFromJson.map((e) => Exercise.fromJson(e)).toList();

    return Muscle(
      idMuscle: json['id_muscle'],
      nameOfMuscle: json['name_of_muscle'],
      exercises: exercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_muscle': idMuscle,
      'name_of_muscle': nameOfMuscle,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
    };
  }
}

class SelectedMuscle {
  Muscle? muscles;
  int idSelectedMuscle;
  List<SelectedExercise>? selectedExercises;

  SelectedMuscle({
    this.muscles,
    required this.idSelectedMuscle,
    this.selectedExercises,
  });

  factory SelectedMuscle.fromJson(Map<String, dynamic> json) {
    var muscleFromJson = json['muscles'] as Map<String, dynamic>;
    Muscle muscles = Muscle.fromJson(muscleFromJson);

    var selectedExercisesFromJson = json['selected_exercise'] as List<dynamic>;
    List<SelectedExercise> selectedExercisesList = selectedExercisesFromJson.map((e) => SelectedExercise.fromJson(e as Map<String, dynamic>)).toList();

    return SelectedMuscle(
      muscles: muscles,
      idSelectedMuscle: json['id_selected_muscle'],
      selectedExercises: selectedExercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muscles': muscles?.toJson(),
      'id_selected_muscle': idSelectedMuscle,
      'selected_exercises': selectedExercises?.map((e) => e.toJson()).toList(),
    };
  }
}

class SelectedExercise {
  Exercise exercises;
  int idSelectedExercise;

  SelectedExercise({
    required this.exercises,
    required this.idSelectedExercise,
  });

  factory SelectedExercise.fromJson(Map<String, dynamic> json) {
    return SelectedExercise(
      exercises: Exercise.fromJson(json['exercises']),
      idSelectedExercise: json['id_selected_exercise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercises': exercises.toJson(),
      'id_selected_exercise': idSelectedExercise,
    };
  }
}

class Split {
  int? idSplit;
  String nameSplit;
  List<SelectedMuscle>? selectedMuscle;

  Split({
    this.idSplit,
    required this.nameSplit,
    this.selectedMuscle,
  });

  factory Split.fromJson(Map<String, dynamic> json) {
    var selectedMuscleFromJson = json['selected_muscles'] as List<dynamic>;
    List<SelectedMuscle> selectedMusclesList = selectedMuscleFromJson.map((e) => SelectedMuscle.fromJson(e)).toList();

    return Split(
      idSplit: json['id_split'],
      nameSplit: json['name_split'],
      selectedMuscle: selectedMusclesList,
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

class User {
  int idUser;
  String name;
  String email;
  List<Muscle>? muscles;
  List<Split>? split;

  User({
    required this.idUser,
    required this.name,
    required this.email,
    this.muscles,
    this.split,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var musclesFromJson = json['muscles'] as List<dynamic>?; // Add null check
    List<Muscle>? musclesList = musclesFromJson?.map((e) => Muscle.fromJson(e)).toList();

    var splitsFromJson = json['split'] as List<dynamic>?; // Add null check
    List<Split>? splitList = splitsFromJson?.map((e) => Split.fromJson(e)).toList();

    return User(
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
