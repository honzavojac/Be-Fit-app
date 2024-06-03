import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
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

  //pro jednotlivé stránky pro správu stavu
  int clickedSplitTab = 0;

  initialize() async {
    db = await Supabase.initialize(url: url, anonKey: anonKey);

    print("supabase inicializována");
    try {
      uid = supabase.auth.currentUser!.id;
    } catch (e) {}
  }

  Future<User?> getUser() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('id_user, name, email').eq('user_id', uid).single();
    User localUser = User.fromJson(response);
    user = localUser;
    name = localUser.name;
    print(localUser.name);
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

  getTodayFitness() async {
    final uid = supabase.auth.currentUser!.id;
    final dateRange = getTodayDateRange();

    final response = await supabase
        .from('users')
        .select('''
    split(
      name_split,
      split_muscles (
        muscles (
          name_of_muscle,
          exercises (
            name_of_exercise,
            exercise_data(
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
          'split.split_muscles.muscles.exercises.exercise_data.time',
          dateRange['start']!,
        )
        .lt(
          'split.split_muscles.muscles.exercises.exercise_data.time',
          dateRange['end']!,
        );

    // print(response[0].toString());
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
    //   for (var splitMuscle in split.splitMuscles!) {
    //     print("  Muscle name: ${splitMuscle.muscles.nameOfMuscle}");
    //     if (splitMuscle.muscles.exercises != null) {
    //       for (var exercise in splitMuscle.muscles.exercises!) {
    //         print("   Exercise name: ${exercise.nameOfExercise}");

    //         for (var exerciseData in exercise.exerciseData!) {
    //           if (DateTime.now().toString().replaceRange(10, null, '') == exerciseData.time?.replaceRange(10, null, '')) {
    //             print("    záznam: weight: ${exerciseData.weight} reps: ${exerciseData.reps} difficulty: ${exerciseData.difficulty} technique: ${exerciseData.technique} time: ${exerciseData.time?.replaceRange(10, null, '') ?? null}");
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    // notifyListeners();
  }

  updateName(String newName) async {
    await supabase.from('users').update({'name': '$newName'}).eq('user_id', uid);
  }

  // data() async {
  //   final dat = await supabase.from('split').select('''
  //     name_split,
  //     split_muscles (
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
  //     //   for (var splitMuscle in split.splitMuscles) {
  //     //     print('    ${splitMuscle.muscles.nameOfMuscle}');
  //     //     for (var exercise in splitMuscle.muscles.exercises) {
  //     //       print("      ${exercise.nameOfExercise}");
  //     //     }
  //     //   }
  //     // }
  //   }
  // }
}

class ExerciseData {
  int weight;
  int reps;
  int difficulty;
  String? technique;
  String? commnet;
  String? time;

  ExerciseData({
    required this.weight,
    required this.reps,
    required this.difficulty,
    this.technique,
    this.commnet,
    this.time,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      weight: json['weight'],
      reps: json['reps'],
      difficulty: json['difficulty'],
      technique: json['technique'],
      commnet: json['comment'],
      time: json['time'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
      'difficulty': difficulty,
      'technique': technique,
      'comment': commnet,
      'time': time,
    };
  }
}

class Exercise {
  String nameOfExercise;
  List<ExerciseData>? exerciseData;

  Exercise({required this.nameOfExercise, this.exerciseData});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseDataFromJson = json['exercise_data'] as List?;
    List<ExerciseData>? exerciseDataList = exerciseDataFromJson?.map((e) => ExerciseData.fromJson(e)).toList();

    return Exercise(
      nameOfExercise: json['name_of_exercise'],
      exerciseData: exerciseDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_of_exercise': nameOfExercise,
      'exercise_data': exerciseData?.map((e) => e.toJson()).toList(),
    };
  }
}

class Muscle {
  String nameOfMuscle;
  List<Exercise>? exercises;

  Muscle({required this.nameOfMuscle, this.exercises});

  factory Muscle.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List;
    List<Exercise> exerciseList = exercisesFromJson.map((e) => Exercise.fromJson(e)).toList();

    return Muscle(nameOfMuscle: json['name_of_muscle'], exercises: exerciseList);
  }

  Map<String, dynamic> toJson() {
    return {
      'name_of_muscle': nameOfMuscle,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
    };
  }
}

class SplitMuscle {
  Muscle muscles;

  SplitMuscle({required this.muscles});

  factory SplitMuscle.fromJson(Map<String, dynamic> json) {
    return SplitMuscle(muscles: Muscle.fromJson(json['muscles']));
  }

  Map<String, dynamic> toJson() {
    return {'muscles': muscles.toJson()};
  }
}

class Split {
  String nameSplit;
  List<SplitMuscle>? splitMuscles;

  Split({required this.nameSplit, this.splitMuscles});

  factory Split.fromJson(Map<String, dynamic> json) {
    var splitMusclesFromJson = json['split_muscles'];
    List<SplitMuscle>? splitMuscleList;
    try {
      // Add null check and type check
      if (splitMusclesFromJson != null && splitMusclesFromJson is List) {
        splitMuscleList = splitMusclesFromJson.map((e) => SplitMuscle.fromJson(e)).toList();
      }
    } catch (e) {
      // Handle error
      print('Error parsing split muscles: $e');
    }
    return Split(nameSplit: json['name_split'], splitMuscles: splitMuscleList);
  }

  Map<String, dynamic> toJson() {
    return {
      'name_split': nameSplit,
      'split_muscles': splitMuscles?.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  int idUser;
  String name;
  String email;
  List<Split>? split;

  User({required this.idUser, required this.name, required this.email, this.split});

  factory User.fromJson(Map<String, dynamic> json) {
    var splitFromJson = json['split'];
    List<Split>? splitList;
    try {
      splitList = splitFromJson.map((e) => Split.fromJson(e)).toList();
      print('mapa splitu byla nalezena');
    } catch (e) {}

    return User(
      idUser: json['id_user'],
      name: json['name'],
      email: json['email'],
      split: splitList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'name': name,
      'email': email,
      'split': split?.map((e) => e.toJson()).toList(),
    };
  }
}
