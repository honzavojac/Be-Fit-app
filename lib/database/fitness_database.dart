import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///supabase je jen databáze když změním zařízení tak ať uživatel má data a načtou se mu do aplikace
///
/// 1) uložím sqflite podle action!
/// 2) ze supabase budu načítat data při načtení aplikace pokud nejsou v databázi
///
///
///
///

class FitnessProvider extends ChangeNotifier {
  late Database _database;
  late String databasesPath;

  Future<void> deleteFile(String fileName) async {
    try {
      // Získání cesty k adresáři, kde jsou ukládány soubory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Vytvoření cesty k souboru
      String filePath = '${appDocDir.path}/$fileName';

      // Kontrola, zda soubor existuje
      if (await File(filePath).exists()) {
        // Pokud existuje, smazat soubor
        await File(filePath).delete();
        print('Soubor $fileName byl smazán.');
      } else {
        print('Soubor $fileName neexistuje.');
      }
    } catch (e) {
      print('Chyba při mazání souboru: $e');
    }
  }

  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactoryOrNull = null;
    databaseFactory = databaseFactoryFfi;
    databasesPath = (await getApplicationDocumentsDirectory()).path;
    String appPath = join(databasesPath, 'fitnessDatabase.db');

    _database = await openDatabase(appPath, version: 1, onCreate: (Database db, int version) {
      db.execute('''
        CREATE TABLE muscles (
            id_muscle INTEGER PRIMARY KEY AUTOINCREMENT,
            name_of_muscle TEXT NOT NULL,
            supabase_id_muscle INTEGER,
            action INTEGER
        );

        CREATE TABLE exercises (
            id_exercise INTEGER PRIMARY KEY AUTOINCREMENT,
            name_of_exercise TEXT NOT NULL,
            muscles_id_muscle INTEGER NOT NULL,
            supabase_id_exercise INTEGER,
            action INTEGER,
            FOREIGN KEY (muscles_id_muscle) REFERENCES muscles (id_muscle)
        );

        CREATE TABLE exercise_data (
            id_ex_data INTEGER PRIMARY KEY AUTOINCREMENT,
            weight INTEGER,
            reps INTEGER,
            difficulty INTEGER,
            technique TEXT,
            comment TEXT,
            time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            exercises_id_exercise INTEGER NOT NULL,
            id_started_completed INTEGER NOT NULL,
            supabase_id_ex_data INTEGER,
            action INTEGER,
            FOREIGN KEY (exercises_id_exercise) REFERENCES exercises (id_exercise),
            FOREIGN KEY (id_started_completed) REFERENCES split_started_completed (id_started_completed) ON DELETE CASCADE
        );

        CREATE TABLE split (
            id_split INTEGER PRIMARY KEY AUTOINCREMENT,
            name_split TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            supabase_id_split INTEGER,
            action INTEGER
        );

        CREATE TABLE selected_muscles (
            id_selected_muscle INTEGER PRIMARY KEY AUTOINCREMENT,
            split_id_split INTEGER NOT NULL,
            muscles_id_muscle INTEGER NOT NULL,
            supabase_id_selected_muscle INTEGER,
            action INTEGER,
            FOREIGN KEY (muscles_id_muscle) REFERENCES muscles (id_muscle),
            FOREIGN KEY (split_id_split) REFERENCES split (id_split) ON DELETE CASCADE
        );

        CREATE TABLE selected_exercise (
            id_selected_exercise INTEGER PRIMARY KEY AUTOINCREMENT,
            id_exercise INTEGER NOT NULL,
            id_selected_muscle INTEGER NOT NULL,
            supabase_id_selected_exercise INTEGER,
            action INTEGER,
            FOREIGN KEY (id_selected_muscle) REFERENCES selected_muscles (id_selected_muscle) ON DELETE CASCADE,
            FOREIGN KEY (id_exercise) REFERENCES exercises (id_exercise)
        );

        CREATE TABLE split_started_completed (
            id_started_completed INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            split_id INTEGER NOT NULL,
            ended_at TIMESTAMP,
            ended BOOLEAN NOT NULL DEFAULT 0,
            supabase_id_started_completed INTEGER,
            action INTEGER,
            FOREIGN KEY (split_id) REFERENCES split (id_split)
        );

        ''');
      print("Databáze byly vytvořeny");
    });

    print("inicializace proběhla úspěšně");

    return _database;
  }

  DeleteAllTables() async {
    await DeleteAllMuscles();
    await DeleteAllExercises();
    await DeleteAllExerciseDatas();
    await DeleteAllSplits();
    await DeleteAllSelectedMuscles();
    await DeleteAllSelectedExercises();
    await DeleteAllSplitStartedCompleteds();
    print("Delete tables hotový");
  }

  UpdateAction(String dbTable, int action, int idItem) async {
    switch (dbTable) {
      case "muscles":
        await _database.rawQuery('''UPDATE muscles SET action = $action WHERE id_muscle = $idItem''');
        break;
      case "exercises":
        await _database.rawQuery('''UPDATE exercises SET action = $action WHERE id_exercise = $idItem''');

        break;
      case "exercise_data":
        await _database.rawQuery('''UPDATE exercise_data SET action = $action WHERE id_ex_data = $idItem''');

        break;
      case "split":
        await _database.rawQuery('''UPDATE split SET action = $action WHERE id_split = $idItem''');

        break;
      case "selected_muscles":
        await _database.rawQuery('''UPDATE selected_muscles SET action = $action WHERE id_selected_muscle = $idItem''');

        break;
      case "selected_exercise":
        await _database.rawQuery('''UPDATE selected_exercise SET action = $action WHERE id_selected_exercise = $idItem''');

        break;
      case "split_started_completed":
        await _database.rawQuery('''UPDATE split_started_completed SET action = $action WHERE id_started_completed = $idItem''');

        break;
      default:
    }
  }

  //Muscles
  SelectMuscles() async {
    var data = await _database.rawQuery('''SELECT * FROM muscles''');
    // var data1 = data[0];
    var finalData = data.map((e) => Muscle.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idMuscle} name: ${finalData[i].nameOfMuscle} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertMuscle(
    int supabaseIdMuscle,
    String nameOfMuscle,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO muscles (
      supabase_id_muscle, 
      name_of_muscle, 
      action
    ) 
    VALUES(
      $supabaseIdMuscle,
      '$nameOfMuscle', 
      $action
    )''');
    notifyListeners();
  }

  UpdateMuscle(String text, int id) async {
    await _database.rawQuery('''UPDATE muscles SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteMuscle(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM muscles WHERE id_muscle = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllMuscles() async {
    List<Muscle> musclesDelete = await SelectMuscles();
    for (var element in musclesDelete) {
      await DeleteMuscle(element.idMuscle!);
    }
    notifyListeners();
  }

  //Exercise
  SelectExercises() async {
    var data = await _database.rawQuery('''SELECT * FROM exercises''');
    // var data1 = data[0];
    var finalData = data.map((e) => Exercise.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idExercise} name: ${finalData[i].nameOfExercise} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertExercise(
    int supabaseIdExercise,
    String nameOfExercise,
    int musclesIdMuscle,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO exercises (
      supabase_id_exercise, 
      name_of_exercise, 
      muscles_id_muscle,
      action
    ) 
    VALUES(
      $supabaseIdExercise,
      '$nameOfExercise', 
      $musclesIdMuscle, 
      $action)
    ''');
    notifyListeners();
  }

  UpdateExercise(String text, int id) async {
    await _database.rawQuery('''UPDATE exercises SET name_of_exercise = '$text' WHERE id_exercise = $id''');
  }

  DeleteExercise(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM exercises WHERE id_exercise = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllExercises() async {
    List<Exercise> exerciseDelete = await SelectExercises();
    for (var element in exerciseDelete) {
      await DeleteExercise(element.idExercise);
    }
    notifyListeners();
  }

  //ExerciseData
  SelectExerciseData() async {
    var data = await _database.rawQuery('''SELECT * FROM exercise_data''');
    // var data1 = data[0];
    var finalData = data.map((e) => ExerciseData.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idExData!} name: ${finalData[i].idExData!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertExerciseData(
    int supabaseIdExerciseData,
    int weight,
    int reps,
    int difficulty,
    int exercisesIdExercise,
    int idStartedCompleted,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO exercise_data (
      supabase_id_ex_data, 
      weight, 
      reps, 
      difficulty, 
      exercises_id_exercise, 
      id_started_completed, 
      action
    ) 
    VALUES(
      $supabaseIdExerciseData, 
      $weight, 
      $reps, 
      $difficulty, 
      $exercisesIdExercise, 
      $idStartedCompleted, 
      $action
    )
    ''');
    notifyListeners();
  }

  UpdateExerciseData(String text, int id) async {
    await _database.rawQuery('''UPDATE exercise_data SET name_of_ex_data = '$text' WHERE id_ex_data = $id''');
  }

  DeleteExerciseData(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM exercise_data WHERE id_ex_data = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllExerciseDatas() async {
    List<ExerciseData> exerciseDataDelete = await SelectExerciseData();
    for (var element in exerciseDataDelete) {
      await DeleteExerciseData(element.idExData!);
    }
    notifyListeners();
  }

  //Split
  SelectSplit() async {
    var data = await _database.rawQuery('''SELECT * FROM split''');
    // var data1 = data[0];
    var finalData = data.map((e) => Split.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSplit!} name: ${finalData[i].idSplit!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSplit(
    int supabaseIdSplit,
    String nameOfSplit,
    String createdAt,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO split (
      supabase_id_split, 
      name_split, 
      created_at, 
      action
      ) 
      VALUES(
        $supabaseIdSplit,
        '$nameOfSplit',
        '$createdAt', 
        $action
      )''');
    notifyListeners();
  }

  UpdateSplit(String text, int id) async {
    await _database.rawQuery('''UPDATE split SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteSplit(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM split WHERE id_split = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllSplits() async {
    List<Split> splitsDelete = await SelectSplit();
    for (var element in splitsDelete) {
      await DeleteSplit(element.idSplit!);
    }
    notifyListeners();
  }

//SelectedMuscles
  SelectSelectedMuscles() async {
    var data = await _database.rawQuery('''SELECT * FROM selected_muscles''');
    // var data1 = data[0];
    var finalData = data.map((e) => SelectedMuscle.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSelectedMuscle!} name: ${finalData[i].idSelectedMuscle!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSelectedMuscle(
    int supabaseIdSelectedMuscle,
    int splitIdSplit,
    int musclesIdMuscle,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO selected_muscles (
      supabase_id_selected_muscle, 
      split_id_split,
      muscles_id_muscle, 
      action
    ) 
    VALUES(
      $supabaseIdSelectedMuscle,
      $splitIdSplit,
      $musclesIdMuscle,
      $action  
    )''');
    notifyListeners();
  }

  UpdateSelectedMuscle(String text, int id) async {
    await _database.rawQuery('''UPDATE selected_muscles SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteSelectedMuscle(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM selected_muscles WHERE id_selected_muscle = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllSelectedMuscles() async {
    List<SelectedExercise> selectedMusclesDelete = await SelectSelectedExercises();
    for (var element in selectedMusclesDelete) {
      await DeleteSelectedExercise(element.idSelectedExercise!);
    }
    notifyListeners();
  }

//SelectedExercise
  SelectSelectedExercises() async {
    var data = await _database.rawQuery('''SELECT * FROM selected_exercise''');
    // var data1 = data[0];
    var finalData = data.map((e) => SelectedExercise.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSelectedExercise!} name: ${finalData[i].idSelectedExercise!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSelectedExercise(
    int supabaseIdSelectedExercise,
    int idExercise,
    int idSelectedMuscle,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO selected_exercise (
      supabase_id_selected_exercise, 
      id_exercise,
      id_selected_muscle,
      action
    ) 
    VALUES(
      $supabaseIdSelectedExercise,
      $idExercise,
      $idSelectedMuscle,
      $action
    )''');
    notifyListeners();
  }

  UpdateSelectedExercise(String text, int id) async {
    await _database.rawQuery('''UPDATE selected_exercise SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteSelectedExercise(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM selected_exercise WHERE id_selected_exercise = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllSelectedExercises() async {
    List<SelectedExercise> selectedExerciseDelete = await SelectSelectedExercises();
    for (var element in selectedExerciseDelete) {
      await DeleteSelectedExercise(element.idSelectedExercise!);
    }
    notifyListeners();
  }

  //SplitStartedCompleted
  SelectSplitStartedCompleted() async {
    var data = await _database.rawQuery('''SELECT * FROM split_started_completed''');
    // var data1 = data[0];
    var finalData = data.map((e) => SplitStartedCompleted.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idStartedCompleted!} name: ${finalData[i].idStartedCompleted!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSplitStartedCompleted(
    int supabaseIdSplitStartedCompleted,
    String createdAt,
    int splitId,
    bool ended,
    int action,
  ) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO split_started_completed (
      supabase_id_started_completed, 
      created_at,
      split_id,
      ended,
      action
    ) 
    VALUES(
      $supabaseIdSplitStartedCompleted,
      '$createdAt',
      $splitId,
      ${!ended},
      $action
    )''');

    notifyListeners();
  }

  UpdateSplitStartedCompleted(String text, int id) async {
    await _database.rawQuery('''UPDATE split_started_completed SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteSplitStartedCompleted(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM split_started_completed WHERE id_started_completed = $id''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllSplitStartedCompleteds() async {
    List<SplitStartedCompleted> splitStartedCompletedDelete = await SelectSplitStartedCompleted();
    for (var element in splitStartedCompletedDelete) {
      await DeleteSplitStartedCompleted(element.idStartedCompleted!);
    }
    notifyListeners();
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  SyncFromSupabase(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    // Načítání dat ze Supabase
    List<Muscle> supabaseData = await dbSupabase.getAllMuscles();
    // Načítání dat z SQLite
    List<Muscle> fitnessData = await SelectMuscles();

    //do action data
    for (var i = 0; i < fitnessData.length; i++) {
      if (fitnessData[i].action == 3) {
        //odstranění z supabase teď nebudu dělat

        //odstranění z sqlflite
        DeleteMuscle(fitnessData[i].idMuscle!);
      }
    }

    // Debugging výstup
    print('Supabase data length: ${supabaseData.length}');
    print('SQLite data length: ${fitnessData.length}');

    for (var i = 0; i < supabaseData.length; i++) {
      bool exists = false;
      for (var j = 0; j < fitnessData.length; j++) {
        if (supabaseData[i].idMuscle == fitnessData[j].supabaseIdMuscle) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        await InsertMuscle(supabaseData[i].idMuscle!, supabaseData[i].nameOfMuscle, 0);
      }
    }
    return await SelectMuscles();
  }
}
