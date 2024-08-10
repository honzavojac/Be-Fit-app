import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/main.dart';
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

  bool switchButton = false;
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
            time TEXT,
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
            created_at TEXT NOT NULL,
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
            created_at TEXT NOT NULL,
            split_id INTEGER NOT NULL,
            ended_at TEXT,
            ended BOOLEAN NOT NULL DEFAULT 0,
            supabase_id_started_completed INTEGER,
            action INTEGER,
            FOREIGN KEY (split_id) REFERENCES split (id_split)
        );
        CREATE TABLE body_measurements (
            id_body_measurements INTEGER PRIMARY KEY AUTOINCREMENT,
            created_at TEXT NOT NULL,
            weight NUMERIC,
            height INTEGER,
            age INTEGER,
            abdominal_circumference NUMERIC,
            chest_circumference NUMERIC,
            waist_circumference NUMERIC,
            thigh_circumference NUMERIC,
            neck_circumference NUMERIC,
            biceps_circumference NUMERIC,
            supabase_id_body_measurements INTEGER,
            action INTEGER
        );
        ''');
      print("Databáze byly vytvořeny");
    });

    print("inicializace proběhla úspěšně");

    return _database;
  }

  Future<void> deleteAllData() async {
    // Začátek transakce
    await _database.transaction((txn) async {
      // Mazání dat z jednotlivých tabulek
      await txn.rawDelete('DELETE FROM exercise_data');
      await txn.rawDelete('DELETE FROM selected_exercise');
      await txn.rawDelete('DELETE FROM selected_muscles');
      await txn.rawDelete('DELETE FROM split_started_completed');
      await txn.rawDelete('DELETE FROM split');
      await txn.rawDelete('DELETE FROM exercises');
      await txn.rawDelete('DELETE FROM muscles');
      await txn.rawDelete('DELETE FROM body_measurements');
    });
    print("Delete all data hotový");
  }

  SyncSqfliteToSupabase(SupabaseProvider dbSupabase, String dbTable, dynamic data, int action) async {
    var idUser = dbSupabase.user!.idUser;
    // print(data.printMuscle());
    dynamic finalData;
    int idRecord;
    String idItem = "";
    int? supabaseIdItem;
    String updateDeleteColumn = "";

    DateTime? parseDate(String? date) {
      if (date == null || date == "null" || date == Null || date == "Null") {
        return null;
      }
      try {
        return DateTime.parse(date);
      } catch (e) {
        print("Date parsing failed: $e");
        return null;
      }
    }

    switch (dbTable) {
      case "muscles":
        finalData = {
          'name_of_muscle': data.nameOfMuscle,
          'id_user': idUser,
        };
        idRecord = data.idMuscle;
        idItem = "id_muscle";
        supabaseIdItem = data.supabaseIdMuscle;
        updateDeleteColumn = "supabase_id_muscle";
        break;
      case "exercises":
        finalData = {
          'name_of_exercise': data.nameOfExercise,
          'muscles_id_muscle': data.musclesIdMuscle,
        };
        idRecord = data.idExercise;
        idItem = "id_exercise";
        supabaseIdItem = data.supabaseIdExercise;
        updateDeleteColumn = "supabase_id_exercise";
        break;
      case "exercise_data":
        finalData = {
          'weight': data.weight,
          'reps': data.reps,
          'difficulty': data.difficulty,
          'technique': data.technique,
          'exercises_id_exercise': data.exercisesIdExercise,
          'comment': data.comment == null || data.comment == "null" ? null : data.comment,
          'time': data.time,
          'id_started_completed': data.idStartedCompleted,
        };
        idRecord = data.idExData;
        idItem = "id_ex_data";
        supabaseIdItem = data.supabaseIdExData;
        updateDeleteColumn = "supabase_id_ex_data";
        break;
      case "split":
        finalData = {
          'name_split': data.nameSplit,
          'users_id_user': idUser,
          'created_at': data.createdAt,
        };
        idRecord = data.idSplit;
        idItem = "id_split";
        supabaseIdItem = data.supabaseIdSplit;
        updateDeleteColumn = "supabase_id_split";
        break;
      case "selected_muscles":
        finalData = {
          'split_id_split': data.splitIdSplit,
          'muscles_id_muscle': data.musclesIdMuscle,
        };

        idRecord = data.idSelectedMuscle;
        idItem = "id_selected_muscle";
        supabaseIdItem = data.supabaseIdSelectedMuscle;
        updateDeleteColumn = "supabase_id_selected_muscle";
        break;
      case "selected_exercise":
        finalData = {
          'id_exercise': data.idExercise,
          'id_selected_muscle': data.idSelectedMuscle,
        };
        idRecord = data.idSelectedExercise;
        idItem = "id_selected_exercise";
        supabaseIdItem = data.supabaseIdSelectedExercise;
        updateDeleteColumn = "supabase_id_selected_exercise";
        break;
      case "split_started_completed":
        print("datum endedAt:${data.endedAt} ****************************");
        // print(data.endedAt != null ? parseDate(data.endedAt) : null);
        finalData = {
          'split_id': data.splitId,
          'created_at': data.createdAt,
          'ended_at': data.endedAt ?? null,
          'ended': data.ended,
        };
        idRecord = data.idStartedCompleted;
        idItem = "id_started_completed";
        supabaseIdItem = data.supabaseIdStartedCompleted;
        updateDeleteColumn = "supabase_id_started_completed";
        break;
      case "body_measurements":
        finalData = {
          'id_user': idUser,
          'created_at': data.createdAt,
          'weight': data.weight,
          'height': data.height,
          'abdominal_circumference': data.abdominalCircumference,
          'chest_circumference': data.chestCircumference,
          'waist_circumference': data.waistCircumference,
          'thigh_circumference': data.thighCircumference,
          'neck_circumference': data.neckCircumference,
          'biceps_circumference': data.bicepsCircumference,
        };
        idRecord = data.idBodyMeasurements;
        idItem = "id_body_measurements";
        supabaseIdItem = data.supabaseIdBodyMeasurements;
        updateDeleteColumn = "supabase_id_body_measurements";
        break;
      default:
        //něco se pokazilo
        idRecord = -1;
        action = 99;
        print("stala se chyba v fitness_database (nejspíš v jméně zadané tabulky)");
    }
    int? finalSupabaseIdItem;
    switch (action) {
      case 0:
        //data jsou stejné
        // finalData.printSplit();
        // var responseData = await _database.rawQuery('''SELECT * FROM $dbTable;''');
        finalSupabaseIdItem = supabaseIdItem;
        print("nic se neinsertovalo");
        break;
      case 1:
        // funguje
        print("insertuje se ${finalData}");

        // print(finalData);
        //insert do supabase
        try {
          var responseData = await supabase.from('$dbTable').insert(finalData).select();
          finalSupabaseIdItem = responseData[0]['$idItem'];

          await UpdateSupabaseIdItemAndAction(dbTable, idRecord, finalSupabaseIdItem, 0);
        } catch (e) {
          print("Stala se chyba při sync hodnot do supabase: chyba $e");
        }

        break;
      case 2:
        //update do supabase
        //v sqlite to už je takže data se aktualizují jen v supa
        print("UPDATE DO SUPABASE");
        print("updatuje se ${finalData}");
        print("supabaseIdItem $supabaseIdItem");
        try {
          await supabase.from('$dbTable').update(finalData).eq(idItem, supabaseIdItem!);
        } catch (e) {
          print("chyba při update $e");
        }
        try {
          await _database.rawQuery('''UPDATE $dbTable SET action = 0 WHERE $updateDeleteColumn = $supabaseIdItem''');
        } catch (e) {
          print("chyba při update action v sqflite");
        }
        print("UPDATED");
        break;
      case 3:
        //delete do supabase
        print("DELETE V SUPABASE A V SQFLITE");
        print("deletuje se $finalData");
        try {
          await supabase.from('$dbTable').delete().eq(idItem, supabaseIdItem!);
        } catch (e) {
          print("Stala se chyba při delete row v supabase");
        }
        try {
          await _database.rawQuery('''DELETE FROM $dbTable WHERE $updateDeleteColumn == $supabaseIdItem''');
        } catch (e) {
          print("Stala se chyba při delete row v sqflite v FitnessProvider při sync hodnot");
        }

        break;
      case 4:
        //delete v sqlite
        try {
          await _database.rawQuery('''DELETE FROM $dbTable WHERE $updateDeleteColumn == $supabaseIdItem''');
        } catch (e) {
          print("delete v sqflite se nezdařil, chyba: $e");
        }
      default:
    }
    return finalSupabaseIdItem;
  }

  UpdateSelectedMuscleMusclesIdMuscle(int newMusclesIdMuscle, int oldMusclesIdMuscle) async {
    await _database.rawQuery('''UPDATE selected_muscles SET muscles_id_muscle = $newMusclesIdMuscle WHERE muscles_id_muscle = $oldMusclesIdMuscle''');
  }

  UpadateExercisesMusclesIdMuscle(int newMusclesIdMuscle, int oldMusclesIdMuscle) async {
    await _database.rawQuery('''UPDATE exercises SET muscles_id_muscle = $newMusclesIdMuscle WHERE muscles_id_muscle = $oldMusclesIdMuscle''');
  }

  UpadateExerciseDataExercisesIdExercise(int newExercisesIdExercise, int oldExercisesIdExercise) async {
    await _database.rawQuery('''UPDATE exercise_data SET exercises_id_exercise = $newExercisesIdExercise WHERE exercises_id_exercise = $oldExercisesIdExercise''');
  }

  UpadateExerciseDataIdExData(int newIdExData, int oldIdExData) async {
    await _database.rawQuery('''UPDATE exercise_data SET id_ex_data = $newIdExData WHERE id_ex_data = $oldIdExData''');
  }

  UpadateSelectedExerciseIdExercise(int newExercisesIdExercise, int oldExercisesIdExercise) async {
    await _database.rawQuery('''UPDATE selected_exercise SET id_exercise = $newExercisesIdExercise WHERE id_exercise = $oldExercisesIdExercise''');
  }

  UpadateSelectedMusclesSplitIdSplit(int newSplitIdSplit, int oldSplitIdSplit) async {
    await _database.rawQuery('''UPDATE selected_muscles SET split_id_split = $newSplitIdSplit WHERE split_id_split = $oldSplitIdSplit''');
  }

  UpadateSelectedExerciseIdSelectedMuscle(int newIdSelectedMuscle, int oldIdSelectedMuscle) async {
    await _database.rawQuery('''UPDATE selected_exercise SET id_selected_muscle = $newIdSelectedMuscle WHERE id_selected_muscle = $newIdSelectedMuscle''');
  }

  UpadateSplitStartedCompletedSplitId(int newSplitId, int oldSplitId) async {
    await _database.rawQuery('''UPDATE split_started_completed SET split_id = $newSplitId WHERE split_id = $oldSplitId''');
  }

  UpadateExerciseDataIdStartedCompleted(int newIdSplitStarted, int oldIdSplitStarted) async {
    await _database.rawQuery('''UPDATE exercise_data SET id_started_completed = $newIdSplitStarted WHERE id_started_completed = $oldIdSplitStarted''');
  }

  UpadateBodyMeasurements(int newIdBodyMeasurements, int oldIdBodyMeasurements) async {
    await _database.rawQuery('''UPDATE body_measurements SET id_body_measurements = $newIdBodyMeasurements WHERE id_body_measurements = $oldIdBodyMeasurements''');
  }

  SaveToSupabaseAndOrderSqlite(SupabaseProvider dbSupabase) async {
    List<Muscle> muscles = await SelectMuscles();
    List<Exercise> exercises = await SelectExercises();
    List<Measurements> measurements = await SelectMeasurements();

    for (var muscle in muscles) {
      int muscleAction = muscle.action ?? 0;
      int? supabaseIdMuscle = await SyncSqfliteToSupabase(dbSupabase, "muscles", muscle, muscleAction);
      if (supabaseIdMuscle != null) {
        await UpdateSelectedMuscleMusclesIdMuscle(supabaseIdMuscle, muscle.supabaseIdMuscle ?? 0);
        await UpadateExercisesMusclesIdMuscle(supabaseIdMuscle, muscle.supabaseIdMuscle ?? 0);

        for (var exercise in exercises) {
          if (muscle.supabaseIdMuscle == exercise.musclesIdMuscle) {
            exercise.musclesIdMuscle = supabaseIdMuscle;
            int exerciseAction = exercise.action ?? 0;
            int? supabaseIdExercise = await SyncSqfliteToSupabase(dbSupabase, "exercises", exercise, exerciseAction);
            if (supabaseIdExercise != null) {
              await UpadateExerciseDataExercisesIdExercise(supabaseIdExercise, exercise.supabaseIdExercise ?? 0);
              await UpadateSelectedExerciseIdExercise(supabaseIdExercise, exercise.supabaseIdExercise ?? 0);
            }
          }
        }
      }
    }

    List<Split> allData = await SelectAllData();
    List<ExerciseData> exercisesData = await SelectExerciseData();

    for (var split in allData) {
      int splitAction = split.action ?? 0;
      int? supabaseIdSplit = await SyncSqfliteToSupabase(dbSupabase, "split", split, splitAction);
      if (supabaseIdSplit != null) {
        await UpadateSelectedMusclesSplitIdSplit(supabaseIdSplit, split.supabaseIdSplit ?? 0);
        await UpadateSplitStartedCompletedSplitId(supabaseIdSplit, split.supabaseIdSplit ?? 0);

        for (var selectedMuscle in split.selectedMuscle ?? []) {
          if (split.supabaseIdSplit == selectedMuscle.splitIdSplit) {
            selectedMuscle.splitIdSplit = supabaseIdSplit;
            int selectedMuscleAction = selectedMuscle.action ?? 0;
            int? supabaseIdSelectedMuscle = await SyncSqfliteToSupabase(dbSupabase, "selected_muscles", selectedMuscle, selectedMuscleAction);
            if (supabaseIdSelectedMuscle != null) {
              await UpadateSelectedExerciseIdSelectedMuscle(supabaseIdSelectedMuscle, selectedMuscle.supabaseIdSelectedMuscle ?? 0);

              for (var selectedExercise in selectedMuscle.selectedExercises ?? []) {
                if (selectedMuscle.supabaseIdSelectedMuscle == selectedExercise.idSelectedMuscle) {
                  selectedExercise.idSelectedMuscle = supabaseIdSelectedMuscle;
                  int selectedExerciseAction = selectedExercise.action ?? 0;
                  await SyncSqfliteToSupabase(dbSupabase, "selected_exercise", selectedExercise, selectedExerciseAction);
                }
              }
            }
          }
        }

        for (var splitStartedCompletedItem in split.splitStartedCompleted ?? []) {
          if (split.supabaseIdSplit == splitStartedCompletedItem.splitId) {
            splitStartedCompletedItem.splitId = supabaseIdSplit;
            int splitStartedCompletedAction = splitStartedCompletedItem.action ?? 0;
            int? supabaseIdStartedCompleted = await SyncSqfliteToSupabase(dbSupabase, "split_started_completed", splitStartedCompletedItem, splitStartedCompletedAction);
            if (supabaseIdStartedCompleted != null) {
              await UpadateExerciseDataIdStartedCompleted(supabaseIdStartedCompleted, splitStartedCompletedItem.supabaseIdStartedCompleted ?? 0);

              for (var exerciseDataItem in exercisesData) {
                if (splitStartedCompletedItem.supabaseIdStartedCompleted == exerciseDataItem.idStartedCompleted) {
                  exerciseDataItem.idStartedCompleted = supabaseIdStartedCompleted;
                  int exerciseDataAction = exerciseDataItem.action ?? 0;
                  await SyncSqfliteToSupabase(dbSupabase, "exercise_data", exerciseDataItem, exerciseDataAction);
                }
              }
            }
          }
        }
      }
    }
    for (var measurement in measurements) {
      int bodyMeasurementsAction = measurement.action ?? 0;
      int? supabaseIdBodyMeasurements = await SyncSqfliteToSupabase(dbSupabase, "body_measurements", measurement, bodyMeasurementsAction);
      if (supabaseIdBodyMeasurements != null) {
        await UpadateBodyMeasurements(supabaseIdBodyMeasurements, measurement.idBodyMeasurements ?? 0);
      }
    }
  }

  UpdateSupabaseIdItemAndAction(String dbTable, int idRecord, int? supabaseIdItem, int action) async {
    switch (dbTable) {
      case "muscles":
        await _database.rawQuery('''UPDATE muscles SET supabase_id_muscle = $supabaseIdItem, action = $action WHERE id_muscle = $idRecord''');
        break;
      case "exercises":
        await _database.rawQuery('''UPDATE exercises SET supabase_id_exercise = $supabaseIdItem, action = $action WHERE id_exercise = $idRecord''');

        break;
      case "exercise_data":
        await _database.rawQuery('''UPDATE exercise_data SET supabase_id_ex_data = $supabaseIdItem, action = $action WHERE id_ex_data = $idRecord''');

        break;
      case "split":
        await _database.rawQuery('''UPDATE split SET supabase_id_split = $supabaseIdItem, action = $action  WHERE id_split = $idRecord''');

        break;
      case "selected_muscles":
        await _database.rawQuery('''UPDATE selected_muscles SET supabase_id_selected_muscle = $supabaseIdItem, action = $action WHERE id_selected_muscle = $idRecord''');

        break;
      case "selected_exercise":
        await _database.rawQuery('''UPDATE selected_exercise SET supabase_id_selected_exercise = $supabaseIdItem, action = $action WHERE id_selected_exercise = $idRecord''');

        break;
      case "split_started_completed":
        await _database.rawQuery('''UPDATE split_started_completed SET supabase_id_started_completed = $supabaseIdItem, action = $action WHERE id_started_completed = $idRecord''');

        break;
      case "body_measurements":
        await _database.rawQuery('''UPDATE body_measurements SET supabase_id_body_measurements = $supabaseIdItem, action = $action WHERE id_body_measurements = $idRecord''');

        break;
      default:
    }
  }

//pro fungování aplikace
  SelectAllMuscleAndExercises() async {
    List<Muscle> muscles = [];

    var data = await _database.rawQuery('''
     SELECT 
  t1.id_muscle, 
  t1.name_of_muscle, 
  t1.supabase_id_muscle,
  t1.action AS muscle_action,
  t2.id_exercise, 
  t2.name_of_exercise,
  t2.muscles_id_muscle,
  t2.supabase_id_exercise,
  t2.action AS exercise_action,
  t3.id_ex_data,
  t3.weight,
  t3.reps,
  t3.difficulty,
  t3.technique,
  t3.comment,
  t3.time,
  t3.exercises_id_exercise,
  t3.id_started_completed,
  t3.supabase_id_ex_data,
  t3.action AS ex_data_action
FROM muscles t1
LEFT JOIN exercises t2 ON t1.supabase_id_muscle = t2.muscles_id_muscle
LEFT JOIN exercise_data t3 ON t2.supabase_id_exercise = t3.exercises_id_exercise;

    ''');

//
    print('Joined Data: ${data}');

    Map<int, Muscle> muscleMap = {};

    for (var item in data) {
      int muscleId = item['id_muscle'] as int;

      // Vytvoření svalu (Muscle), pokud ještě neexistuje
      if (!muscleMap.containsKey(muscleId)) {
        muscleMap[muscleId] = Muscle(
          idMuscle: muscleId,
          nameOfMuscle: item['name_of_muscle'] as String,
          supabaseIdMuscle: item['supabase_id_muscle'] as int,
          action: item['muscle_action'] as int,
          exercises: [],
        );
      }

      // Získání svalu
      Muscle muscle = muscleMap[muscleId]!;

      // Vytvoření cvičení (Exercise), pokud ještě neexistuje
      int? exerciseId = item['id_exercise'] as int?;
      if (!muscle.exercises!.any((exercise) => exercise.idExercise == exerciseId)) {
        Exercise exercise = Exercise(
          idExercise: exerciseId,
          nameOfExercise: item['name_of_exercise'] as String?,
          musclesIdMuscle: muscleId,
          supabaseIdExercise: item['supabase_id_exercise'] as int?,
          action: item['exercise_action'] as int?,
          exerciseData: [],
        );
        muscle.exercises!.add(exercise);
      }

      // Získání cvičení
      Exercise? exercise = muscle.exercises!.firstWhere((item) => item.idExercise == exerciseId);

      // Přidání ExerciseData, pokud jsou k dispozici
      if (item['id_ex_data'] != null) {
        ExerciseData exerciseData = ExerciseData(
          idExData: item['id_ex_data'] as int,
          weight: item['weight'] as int,
          reps: item['reps'] as int,
          difficulty: item['difficulty'] as int,
          technique: item['technique'] != null ? item['technique'] as String : "",
          comment: item['comment'] != null ? item['comment'] as String : "",
          time: item['time'].toString(),
          exercisesIdExercise: item['exercises_id_exercise'] as int,
          idStartedCompleted: item['id_started_completed'] as int,
          supabaseIdExData: item['supabase_id_ex_data'] as int,
          action: item['ex_data_action'] as int,
        );
        exercise.exerciseData!.add(exerciseData);
      }
    }

    // Výpis dat
    // muscleMap.forEach((key, value) {
    //   value.printMuscle();
    //   value.exercises!.forEach((exercise) {
    //     exercise.printExercise();

    //     exercise.exerciseData!.forEach((exerciseData) {
    //       exerciseData.printExerciseData();
    //     });
    //   });
    // });
    muscles = muscleMap.values.toList();

    return muscles;
  }

  Future<List<Split>> SelectAllData() async {
    List<Split> splits = await SelectSplit();
    List<Muscle> muscles = await SelectMuscles();
    List<Exercise> exercises = await SelectExercises();
    List<SelectedMuscle> selectedMuscles = await SelectSelectedMuscles();
    List<SelectedExercise> selectedExercises = await SelectSelectedExercises();
    List<SplitStartedCompleted> splitStartedCompleteds = await SelectSplitStartedCompleted();

    for (var split in splits) {
      split.selectedMuscle = [];
      split.splitStartedCompleted = [];

      // Přidání selectedMuscles do splits
      for (var selectedMuscle in selectedMuscles) {
        if (split.supabaseIdSplit == selectedMuscle.splitIdSplit) {
          selectedMuscle.selectedExercises = [];

          // Přidání selectedExercises do selectedMuscles
          for (var selectedExercise in selectedExercises) {
            if (selectedMuscle.supabaseIdSelectedMuscle == selectedExercise.idSelectedMuscle) {
              // Přidání exercises do selectedExercises
              for (var exercise in exercises) {
                if (selectedExercise.idExercise == exercise.supabaseIdExercise) {
                  selectedExercise.exercises = exercise;
                }
              }
              selectedMuscle.selectedExercises!.add(selectedExercise);
            }
          }

          // Přidání muscles do selectedMuscles
          for (var muscle in muscles) {
            if (selectedMuscle.musclesIdMuscle == muscle.supabaseIdMuscle) {
              muscle.exercises = [];
              for (var exercise in exercises) {
                if (muscle.supabaseIdMuscle == exercise.musclesIdMuscle) {
                  muscle.exercises!.add(exercise);
                }
              }
              selectedMuscle.muscles = muscle;
            }
          }
          split.selectedMuscle!.add(selectedMuscle);
        }
      }

      // Přidání splitStartedCompleted do splits
      for (var splitStartedCompleted in splitStartedCompleteds) {
        if (split.supabaseIdSplit == splitStartedCompleted.splitId) {
          split.splitStartedCompleted!.add(splitStartedCompleted);
        }
      }
    }

    // Debug výpisy
    for (var split in splits) {
      // print(split.nameSplit);
      for (var selectedMuscle in split.selectedMuscle!) {
        // print(selectedMuscle.muscles!.printMuscle());
        for (var selectedExercise in selectedMuscle.selectedExercises!) {
          // print(selectedExercise.exercises!.printExercise());
        }
      }
      for (var element in split.selectedMuscle!) {
        // print(element.muscles!.printMuscle());
      }
    }

    return splits;
  }

  SelectAllHistoricalData(int supabaseIdExercise) async {
    List<SplitStartedCompleted> finalData = [];
    List<Split> splits = [];
    List<SplitStartedCompleted> splitStartedCompleteds = [];
    List<ExerciseData> exerciseData = [];
    splits = await SelectSplit();
    splitStartedCompleteds = await SelectSplitStartedCompletedWhereEnded(true);
    exerciseData = await SelectExerciseData();
    for (var split in splits) {
      split.splitStartedCompleted = [];

      // Přidání splitStartedCompleted do splits
      for (var splitStartedCompleted in splitStartedCompleteds) {
        if (split.supabaseIdSplit == splitStartedCompleted.splitId) {
          splitStartedCompleted.exerciseData = [];

          // Přidání exerciseData do splitStartedCompleted
          for (var exerciseDataItem in exerciseData) {
            if (exerciseDataItem.idStartedCompleted == splitStartedCompleted.supabaseIdStartedCompleted) {
              splitStartedCompleted.exerciseData!.add(exerciseDataItem);
            }
          }

          split.splitStartedCompleted!.add(splitStartedCompleted);
        }
      }
    }
    for (var element in splits) {
      for (var splitStartedCompleted in element.splitStartedCompleted!) {
        for (var element in splitStartedCompleted.exerciseData!) {
          if (element.exercisesIdExercise == supabaseIdExercise) {
            // print(element.printExerciseData());
            finalData.add(splitStartedCompleted);
            break;
          }
        }
      }
    }
    return finalData.reversed.toList();
  }

  SelectAllExData() async {
    List<SplitStartedCompleted> finalData = [];
    List<Split> splits = [];
    List<SplitStartedCompleted> splitStartedCompleteds = [];
    List<ExerciseData> exerciseData = [];
    splits = await SelectSplit();
    splitStartedCompleteds = await SelectSplitStartedCompletedWhereEnded(true);
    exerciseData = await SelectExerciseData();
    for (var split in splits) {
      split.splitStartedCompleted = [];

      // Přidání splitStartedCompleted do splits
      for (var splitStartedCompleted in splitStartedCompleteds) {
        if (split.supabaseIdSplit == splitStartedCompleted.splitId) {
          splitStartedCompleted.exerciseData = [];

          // Přidání exerciseData do splitStartedCompleted
          for (var exerciseDataItem in exerciseData) {
            if (exerciseDataItem.idStartedCompleted == splitStartedCompleted.supabaseIdStartedCompleted) {
              splitStartedCompleted.exerciseData!.add(exerciseDataItem);
            }
          }

          split.splitStartedCompleted!.add(splitStartedCompleted);
        }
        finalData.add(splitStartedCompleted);
      }
    }

    return finalData.reversed.toList();
  }
//

  //Muscles
  Future<List<Muscle>> SelectMuscles() async {
    var data = await _database.rawQuery('''SELECT * FROM muscles''');
    // var data1 = data[0];
    var finalData = data.map((e) => Muscle.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idMuscle} name: ${finalData[i].nameOfMuscle} action: ${finalData[i].action}");
    // }

    return finalData;
  }

  InsertMuscle(
    int? supabaseIdMuscle,
    String nameOfMuscle,
    int action,
  ) async {
    //action 1 == insert
    try {
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
      print("Insert muscle hotový");
    } on Exception catch (e) {
      print("Chyba při vkládání muscle do sqflite: ${e}");
    }
    notifyListeners();
  }

  InsertMuscleWithSync(
    SupabaseProvider dbSupabase,
    String nameOfMuscle,
  ) async {
    int supabaseIdMuscle = await dbSupabase.insertMuscle(nameOfMuscle);

    print(supabaseIdMuscle);
    await InsertMuscle(supabaseIdMuscle, nameOfMuscle, 0);
  }

  UpdateMuscle(String text, int id) async {
    await _database.rawQuery('''UPDATE muscles SET name_of_muscle = '$text' WHERE supabase_id_muscle = $id''');
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
  Future<List<Exercise>> SelectExercises() async {
    var data = await _database.rawQuery('''SELECT * FROM exercises''');

    var finalData = data.map((e) => Exercise.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idExercise} name: ${finalData[i].nameOfExercise} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertExercise(
    int? supabaseIdExercise,
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

  UpdateExercise(String nameOfExercise, int supabaseIdExercise) async {
    await _database.rawQuery('''UPDATE exercises SET name_of_exercise = '$nameOfExercise' WHERE supabase_id_exercise = $supabaseIdExercise''');
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
      await DeleteExercise(element.idExercise!);
    }
    notifyListeners();
  }

  //ExerciseData
  Future<List<ExerciseData>> SelectExerciseData() async {
    var data = await _database.rawQuery('''SELECT * FROM exercise_data''');
    // var data1 = data[0];
    var finalData = data.map((e) => ExerciseData.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idExData!} name: ${finalData[i].idExData!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  Future<List<ExerciseData>> SelectCurrentExerciseDataWhereExerciseIdExerciseAndIdStCo(int exerciseIdExercise, int idStartedCompleted) async {
    var data = await _database.rawQuery('''SELECT * FROM exercise_data 
    WHERE exercises_id_exercise = $exerciseIdExercise AND id_started_completed = $idStartedCompleted''');
    // print(data);
    var finalData = data.map((e) => ExerciseData.fromJson(e)).toList();
    return finalData;
  }

  Future<List<ExerciseData>> SelectCurrentExerciseDataWhereId(int idStartedCompleted) async {
    var data = await _database.rawQuery('''SELECT * FROM exercise_data 
    WHERE id_started_completed = $idStartedCompleted''');
    // print(data);
    var finalData = data.map((e) => ExerciseData.fromJson(e)).toList();
    return finalData;
  }

  Future<List<ExerciseData>> selectMaxExerciseData() async {
    var data = await _database.rawQuery('''
    SELECT MAX(supabase_id_ex_data) as supabase_id_ex_data FROM exercise_data;
''');
    print(data);
    var finalData = data.map((e) => ExerciseData.fromJson(e)).toList();
    return finalData;
  }

  InsertExerciseData(
    int? supabaseIdExerciseData,
    int? weight,
    int? reps,
    int? difficulty,
    String? technique,
    String? comment,
    String? time,
    int exercisesIdExercise,
    int idStartedCompleted,
    int action,
  ) async {
    // Příprava hodnot pro vložení do dotazu SQL
    //action 1 == insert
    print(time);
    await _database.rawQuery('''INSERT INTO exercise_data (
      supabase_id_ex_data, 
      weight, 
      reps, 
      difficulty, 
      technique,
      comment,
      time,
      exercises_id_exercise, 
      id_started_completed, 
      action
    ) 
    VALUES(
      $supabaseIdExerciseData, 
      $weight, 
      $reps, 
      $difficulty, 
      '$technique',
      '$comment',
      '$time',
      $exercisesIdExercise, 
      $idStartedCompleted, 
      $action
    )
    ''');
    notifyListeners();
  }

  UpdateExerciseData(int? weight, int? reps, int? difficulty, int supabaseIdExData, int action) async {
    await _database.rawQuery('''
    UPDATE exercise_data 
    SET 
      weight = $weight, 
      reps = $reps, 
      difficulty = $difficulty, 
      action = $action 
    WHERE supabase_id_ex_data = $supabaseIdExData
    ''');
  }

  DeleteExerciseData(int supabaseIdExData) async {
    try {
      await _database.rawQuery('''DELETE FROM exercise_data WHERE supabase_id_ex_data = $supabaseIdExData''');
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  DeleteAllExerciseDatas() async {
    List<ExerciseData> exerciseDataDelete = await SelectExerciseData();
    for (var element in exerciseDataDelete) {
      await DeleteExerciseData(element.supabaseIdExData!);
    }
    notifyListeners();
  }

  //Split
  Future<List<Split>> SelectSplit() async {
    var data = await _database.rawQuery('''SELECT * FROM split''');
    // var data1 = data[0];
    var finalData = data.map((e) => Split.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSplit!} name: ${finalData[i].idSplit!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSplit(
    int? supabaseIdSplit,
    String nameOfSplit,
    String? createdAt,
    int action,
  ) async {
    //action 1 == insert
    DateTime date = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(date.toLocal());
    await _database.rawQuery('''INSERT INTO split (
      supabase_id_split, 
      name_split, 
      created_at, 
      action
      ) 
      VALUES(
        $supabaseIdSplit,
        '$nameOfSplit',
        '${createdAt ?? formattedDate}', 
        $action
      )''');
    notifyListeners();
  }

  UpdateSplit(String nameOfSplit, int supabaseIdSplit) async {
    await _database.rawQuery('''UPDATE split SET name_split = '$nameOfSplit' WHERE supabase_id_split = $supabaseIdSplit''');
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
  Future<List<SelectedMuscle>> SelectSelectedMuscles() async {
    var data = await _database.rawQuery('''SELECT * FROM selected_muscles''');
    // var data1 = data[0];
    var finalData = data.map((e) => SelectedMuscle.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSelectedMuscle!} name: ${finalData[i].idSelectedMuscle!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSelectedMuscle(
    int? supabaseIdSelectedMuscle,
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
    List<SelectedMuscle> selectedMusclesDelete = await SelectSelectedMuscles();
    for (var element in selectedMusclesDelete) {
      await DeleteSelectedMuscle(element.idSelectedMuscle!);
    }
    notifyListeners();
  }

//SelectedExercise
  Future<List<SelectedExercise>> SelectSelectedExercises() async {
    var data = await _database.rawQuery('''SELECT * FROM selected_exercise''');
    // print(data);
    var finalData = data.map((e) => SelectedExercise.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idSelectedExercise!} name: ${finalData[i].idSelectedExercise!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSelectedExercise(
    int? supabaseIdSelectedExercise,
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

  UpdateSelectedExercise(int action, int idSelectedExercise) async {
    await _database.rawQuery('''UPDATE selected_exercise SET action = $action WHERE supabase_id_selected_exercise = $idSelectedExercise''');
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
  Future<List<SplitStartedCompleted>> SelectSplitStartedCompleted() async {
    var data = await _database.rawQuery('''SELECT * FROM split_started_completed''');
    // var data1 = data[0];
    var finalData = data.map((e) => SplitStartedCompleted.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idStartedCompleted!} name: ${finalData[i].idStartedCompleted!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  Future<List<SplitStartedCompleted>> SelectSplitStartedCompletedWhereEnded(bool ended) async {
    var data = await _database.rawQuery('''SELECT * FROM split_started_completed WHERE ended is $ended''');
    // var data1 = data[0];
    var finalData = data.map((e) => SplitStartedCompleted.fromJson(e)).toList();
    // for (var i = 0; i < finalData.length; i++) {
    //   print("id: ${finalData[i].idStartedCompleted!} name: ${finalData[i].idStartedCompleted!} action: ${finalData[i].action}");
    // }
    return finalData;
  }

  InsertSplitStartedCompleted(
    int? supabaseIdSplitStartedCompleted,
    String? createdAt,
    String? endedAt,
    int splitId,
    bool ended,
    int action,
  ) async {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(date.toLocal());
    //action 1 == insert
    await _database.rawQuery('''INSERT INTO split_started_completed (
      supabase_id_started_completed, 
      created_at,
      ended_at,
      split_id,
      ended,
      action
    ) 
    VALUES(
      $supabaseIdSplitStartedCompleted,
      '${createdAt ?? formattedDate}',
      '${endedAt}',
      $splitId,
      ${ended},
      $action
    )''');

    notifyListeners();
  }

  UpdateSplitStartedCompleted(bool ended, String endedAt, int idStartedCompleted) async {
    await _database.rawQuery('''
      UPDATE split_started_completed 
      SET 
        ended = $ended, 
        ended_at = '$endedAt',
        action = CASE 
                    WHEN action = 0 THEN 2 
                    ELSE action 
                 END
      WHERE supabase_id_started_completed = $idStartedCompleted;
    ''');
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

  //Measurement
  SelectMeasurements() async {
    var data = await _database.rawQuery('''SELECT * FROM body_measurements''');
    var finalData = data.map((e) => Measurements.fromJson(e)).toList();
    return finalData;
  }

  Future<void> insertMeasurements(Measurements measurements, int action) async {
    final db = await _database; // Získání instance databáze

    await db.rawInsert('''
    INSERT INTO body_measurements (
      created_at,
      weight,
      height,
      abdominal_circumference,
      chest_circumference,
      waist_circumference,
      thigh_circumference,
      neck_circumference,
      biceps_circumference,
      supabase_id_body_measurements,
      action
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''', [
      measurements.createdAt,
      measurements.weight,
      measurements.height,
      measurements.abdominalCircumference,
      measurements.chestCircumference,
      measurements.waistCircumference,
      measurements.thighCircumference,
      measurements.neckCircumference,
      measurements.bicepsCircumference,
      measurements.supabaseIdBodyMeasurements,
      action,
    ]);
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
        await InsertMuscle(supabaseData[i].idMuscle!, supabaseData[i].nameOfMuscle!, 0);
      }
    }
    return await SelectMuscles();
  }
}
