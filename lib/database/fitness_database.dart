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
    for (var i = 0; i < finalData.length; i++) {
      print("id: ${finalData[i].idMuscle} name: ${finalData[i].nameOfMuscle} action: ${finalData[i].action}");
    }
    print("hotovo");
    return finalData;
  }

  InsertMuscle(int supabaseIdMuscle, String nameOfMuscle) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO muscles (supabase_id_muscle, name_of_muscle, action) VALUES($supabaseIdMuscle,'$nameOfMuscle', 1)''');
    notifyListeners();
  }

  SupabaseInsertMuscle(String text, int id) async {
    await _database.rawQuery('''INSERT INTO muscles (name_of_muscle, supabase_id_muscle) VALUES('$text', $id)''');
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
    print("hotovo");
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
    for (var i = 0; i < finalData.length; i++) {
      print("id: ${finalData[i].idExercise} name: ${finalData[i].nameOfExercise} action: ${finalData[i].action}");
    }
    print("hotovo");
    return finalData;
  }

  InsertExercise(int supabaseIdExercise, String nameOfExercise) async {
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO muscles (supabase_id_muscle, name_of_muscle, action) VALUES($supabaseIdExercise,'$nameOfExercise', 1)''');
    notifyListeners();
  }

  SupabaseInsertExercise(String text, int id) async {
    await _database.rawQuery('''INSERT INTO muscles (name_of_muscle, supabase_id_muscle) VALUES('$text', $id)''');
    notifyListeners();
  }

  UpdateExercise(String text, int id) async {
    await _database.rawQuery('''UPDATE muscles SET name_of_muscle = '$text' WHERE id_muscle = $id''');
  }

  DeleteExercise(int id) async {
    try {
      await _database.rawQuery('''DELETE FROM muscles WHERE id_muscle = $id''');
    } on Exception catch (e) {
      print(e);
    }
    print("hotovo");
    notifyListeners();
  }

  DeleteAllExercises() async {
    List<Exercise> musclesDelete = await SelectExercises();
    for (var element in musclesDelete) {
      await DeleteExercise(element.idExercise);
    }
    notifyListeners();
  }

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
        await SupabaseInsertMuscle(supabaseData[i].nameOfMuscle, supabaseData[i].idMuscle!);
      }
    }
    return await SelectMuscles();
  }
}

// class Muscles {
//   int idMuscle;
//   String nameOfMuscle;
//   int? supabaseIdMuscle;
//   int action;

//   Muscles({
//     required this.idMuscle,
//     required this.nameOfMuscle,
//     this.supabaseIdMuscle,
//     this.action = 0,
//   });

//   factory Muscles.fromJson(Map<String, dynamic> json) {
//     return Muscles(
//       idMuscle: json['id_muscle'],
//       nameOfMuscle: json['name_of_muscle'],
//       supabaseIdMuscle: json['supabase_id_muscle'],
//       action: json['action'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_muscle': idMuscle,
//       'name_of_muscle': nameOfMuscle,
//       'supabase_id_muscle': supabaseIdMuscle,
//       'action': action,
//     };
//   }
// }
