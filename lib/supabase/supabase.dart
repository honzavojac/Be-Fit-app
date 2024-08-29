import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider extends ChangeNotifier {
  final url = 'https://gznwbuvjfglgrcckmzeg.supabase.co';
  final anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6bndidXZqZmdsZ3JjY2ttemVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM5NTM5MzYsImV4cCI6MjAyOTUyOTkzNn0.uHx0t0ZRYQm-mLj3laHNCJgy2YOCTshv1TL0bcEod4E";
  var db;
  var dbS;
  var uid;
  UserSupabase? user;
  String name = '';
  List<MySplit> splits = List.empty();
  List<MySplit> splitStartedCompleted = List.empty();
  List<MySplit> fitnessData = List.empty();
  List<MySplit> exerciseData = List.empty();
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

  //exercise_page
  int? idSplitStartedCompleted;
  bool boolInsertSplitStartedCompleted = true;
  /* toto pak změním ve fitness_record_page 
  že když bude true tak budu muset ukončit widget tlačítkem ukončit a nebo smazat 
  a smažu všechny hodnoty co jsem insertoval */

  initialize() async {
    db = await Supabase.initialize(url: url, anonKey: anonKey);

    print("supabase inicializována");
    try {
      uid = supabase.auth.currentUser!.id;
    } catch (e) {}
  }

  Future<void> deleteUserAccount() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      print('User not logged in');
      return;
    }
    print(user.id);
    //  await supabase.auth.admin.deleteUser(user.id);

    print('User successfully deleted');
  }

  Future<UserSupabase?> getUser() async {
    try {
      // Získání ID aktuálního uživatele
      final tempUid = supabase.auth.currentUser?.id;
      print("UID: ${tempUid}");
      if (tempUid == null) {
        print('User is not logged in.');
        return null;
      }
      // Dotaz na Supabase pro získání uživatelských údajů
      final response = await supabase.from('users').select('id_user, name, email, country, birth_date').eq('user_id', tempUid).single(); // Získat jeden výsledek

      // Převod odpovědi na UserSupabase
      UserSupabase localUser = UserSupabase.fromJson(response);

      // Nastavení uživatelských dat
      user = localUser;
      name = localUser.name;

      print('User data retrieved successfully.');
      return localUser;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
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
    // final dateRange = getTodayDateRange();

    final response = await supabase.from('users').select('''
    split (
      id_split,
      name_split,
      created_at,
      split_started_completed (
        id_started_completed,
        split_id,
        created_at,
        ended_at, 
        ended
      ),
      selected_muscles (
        id_selected_muscle,
        muscles (
          name_of_muscle,
          id_muscle,
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
            name_of_exercise,
            exercise_data (
              
            )
          )
        )
      )
    )
  ''').eq('user_id', uid).order("created_at", ascending: true, referencedTable: 'split');

    final List<dynamic> data = response[0]['split'];
    splits = data.map((json) => MySplit.fromJson(json as Map<String, dynamic>)).toList();
  }

  getCurrentFitness(int? idStartedCompleted) async {
    final uid = supabase.auth.currentUser!.id;
    // final dateRange = getTodayDateRange();

    final response = await supabase
        .from('users')
        .select('''
    split (
      id_split,
      name_split,
      split_started_completed (
        id_started_completed,
        split_id,
        created_at,
        ended_at, 
        ended
      ),
      selected_muscles (
        id_selected_muscle,
        muscles (
          name_of_muscle,
          id_muscle,
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
            name_of_exercise,
            exercise_data (
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
        .eq(
          'split.selected_muscles.selected_exercise.exercises.exercise_data.id_started_completed',
          idStartedCompleted!,
        )
        .order(
          'id_ex_data',
          ascending: true,
          referencedTable: 'split.selected_muscles.selected_exercise.exercises.exercise_data',
        );

    final List<dynamic> data = response[0]['split'];
    exerciseData = data.map((json) => MySplit.fromJson(json as Map<String, dynamic>)).toList();
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
    return muscles;
  }

  Future<List<MySplit>> getOldExerciseData(int idExercise) async {
    final uid = await supabase.auth.currentUser!.id;

    final response = await supabase
        .from('users')
        .select('''
                  split (
                    id_split,
                    name_split,
                    split_started_completed (
                      id_started_completed,
                      split_id,
                      created_at,
                      ended_at, 
                      ended,
                      exercise_data (
                        id_ex_data,
                        exercises_id_exercise,
                        weight,
                        reps,
                        difficulty,
                        technique,
                        time,
                        id_started_completed
                      )
                    )
                  )
                ''')
        .eq('user_id', uid)
        .eq('split.split_started_completed.exercise_data.exercises_id_exercise', idExercise)
        .eq('split.split_started_completed.ended', true)
        .order(
          'id_ex_data',
          referencedTable: 'split.split_started_completed.exercise_data',
          ascending: true,
        )
        .order(
          'id_started_completed',
          referencedTable: 'split.split_started_completed',
          ascending: false,
        );

    final List<dynamic> data = response[0]['split'];

    splitStartedCompleted = data.map((json) => MySplit.fromJson(json as Map<String, dynamic>)).toList();
    return splitStartedCompleted;
  }

  Future<int?> insertSplitStartedCompleted(int splitId) async {
    try {
      // Vložení nového záznamu a získání id_started_completed
      final response = await supabase
          .from('split_started_completed')
          .insert({
            'created_at': DateTime.now().toIso8601String(),
            'split_id': splitId,
          })
          .select('id_started_completed')
          .single();

      // Získání vložené hodnoty id_started_completed z odpovědi
      int? idStartedCompleted = response['id_started_completed'];

      // Vrácení vloženého id
      return idStartedCompleted;
    } catch (e) {
      // Ošetření chyby
      print("Error inserting split_started_completed: $e");
      return null;
    }
  }

  endSplitStartedCompleted(int idStartedCompleted) async {
    final response = await supabase.from('split_started_completed').update({
      'ended': true,
      'ended_at': DateTime.now().toIso8601String(),
    }).eq('id_started_completed', idStartedCompleted);
    exerciseData.clear();
    notifyListeners();
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
    notifyListeners();
  }

  deleteSplit(int idSplit) async {
    print(idSplit);
    //odstranění hodnoty z tabulky selected_muscles
    await supabase.from('selected_muscles').delete().match({'split_id_split': idSplit});
    //odstranění hodnoty z tabulky split
    await supabase.from('split').delete().match({'id_split': idSplit});

    notifyListeners();
  }

  updateSplit(int idSplit, String updatedText) async {
    await supabase.from("split").update({'name_split': updatedText}).eq('id_split', idSplit);
    notifyListeners();
  }

  insertMuscle(String nameOfMuscle) async {
    var idRow = await supabase.from('muscles').insert({'name_of_muscle': nameOfMuscle, 'id_user': user!.idUser}).select('id_muscle');
    notifyListeners();
    int idMuscle = idRow[0]['id_muscle'];
    return idMuscle;
  }

  updateName(String newName) async {
    await supabase.from('users').update({'name': '$newName'}).eq('user_id', uid);
  }

  insertExercise(String nameOfExercise, int idMuscle) async {
    await supabase.from('exercises').insert({'name_of_exercise': nameOfExercise, 'muscles_id_muscle': idMuscle});

    notifyListeners();
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
    // print("idExercise $idExercise, nameOfExercise $nameOfExercise, idSelectedMuscle $idSelectedMuscle, splitIndex $splitIndex, muscleIndex $muscleIndex, exerciseIndex $exerciseIndex");
    // int i = 0;
    // for (var element in splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises!) {
    //   print("$i - ${element.exercises.nameOfExercise}");
    //   i++;
    // }
    if (isChecked) {
      //pokud je cvik označen tak insert row
      await supabase.from('selected_exercise').insert({'id_exercise': idExercise, 'id_selected_muscle': idSelectedMuscle});
    } else {
      //pokud není cvik označen tak delete row
      for (var i = 0; i < splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises!.length; i++) {
        var exerciseName = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![i].exercises!.nameOfExercise;
        if (exerciseName == nameOfExercise) {
          idSelectedExercise = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![i].idSelectedExercise!;
          await supabase.from('selected_exercise').delete().match({'id_selected_exercise': idSelectedExercise});
        }
      }

      // idSelectedExercise = splits[splitIndex].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].idSelectedExercise!;
    }
    await getFitness();
    notifyListeners();
  }

  Future<void> actionExerciseData(List<ExerciseData> exerciseData, int idExercise, int idStartedCompleted) async {
    for (var i = 0; i < exerciseData.length; i++) {
      var dataOfExercise = exerciseData[i];

      switch (exerciseData[i].operation) {
        case 0 || null:
          //hodnota zůstává
          print("hodnota zůstává");
          break;
        case 1:
          // print("insert");

          try {
            // print("insert: ${insert[i]}");
            await supabase.from('exercise_data').insert(ExerciseData(
                  weight: dataOfExercise.weight,
                  reps: dataOfExercise.reps,
                  difficulty: dataOfExercise.difficulty,
                  exercisesIdExercise: idExercise,
                  idStartedCompleted: idStartedCompleted,
                ).toJson());
            // insert(insert);
          } catch (e) {
            print("insert se nezdařil: $e");
          }
          break;
        case 2:
          // print("update");
          print("idstartedcompleted: $idStartedCompleted");
          try {
            // print("update: ${dataOfExercise.reps}");
            await supabase
                .from('exercise_data')
                .update(ExerciseData(
                  weight: dataOfExercise.weight,
                  reps: dataOfExercise.reps,
                  difficulty: dataOfExercise.difficulty,
                  exercisesIdExercise: idExercise,
                  time: dataOfExercise.time,
                  idStartedCompleted: idStartedCompleted,
                ).toJson())
                .match(
              {'id_ex_data': dataOfExercise.idExData!},
            ).match(
              {'id_started_completed': idStartedCompleted},
            );
          } catch (e) {
            print("update se nezdařil: $e");
          }
          break;
        case 3:
          // print("delete");

          try {
            // print("delete: ${delete[i]}");
            await supabase.from('exercise_data').delete().eq('id_ex_data', dataOfExercise.idExData!);
          } catch (e) {
            print("delete se nezdařil: $e");
          }
          break;
        case 4:
          // print("nothing");
          //nothing
          //hodnota byla insertována a pak smázana
          break;
        default:
      }
    }

    // refresh data
    await getFitness();
    await getCurrentFitness(idStartedCompleted);
    notifyListeners();
  }

  //food část
  void initFoodApi() async {
    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Be fit');

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[OpenFoodFactsLanguage.CZECH];

    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CZECHIA;
  }

  //sync tabulky
  MuscleTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    muscles(
      id_muscle,
      name_of_muscle
    )
  ''').eq('user_id', uid);

    final List<dynamic> data = response[0]["muscles"];

    List<Muscle> muscles = data.map((json) => Muscle.fromJson(json as Map<String, dynamic>)).toList();
    // for (var element in muscles) {
    //   print(element.nameOfMuscle);
    // }
    return muscles;
  }

  ExerciseTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    muscles(
      exercises(
        id_exercise,
        name_of_exercise,
        muscles_id_muscle
      )
    )
    ''').eq('user_id', uid);
    final List<dynamic> userData = response;
    List<Exercise> exercisesList = [];

    userData.forEach((user) {
      List<dynamic> muscles = user['muscles'] ?? [];

      muscles.forEach((muscle) {
        List<dynamic> exercises = muscle['exercises'] ?? [];

        exercises.forEach((exercise) {
          Exercise exerciseItem = Exercise.fromJson(exercise as Map<String, dynamic>);
          exercisesList.add(exerciseItem);
        });
      });
    });
    exercisesList.sort((a, b) => a.idExercise!.compareTo(b.idExercise!));
    // for (var exerciseItem in exercisesList) {
    //   print('idExercise: ${exerciseItem.idExercise} exercise: ${exerciseItem.nameOfExercise}');
    //   // Zde můžete provést další operace s každým záznamem cvičení, například ukládání do SQLite.
    // }
    return exercisesList;
  }

  ExerciseDataTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    muscles(
      exercises(
        exercise_data(
          id_ex_data,
          weight,
          reps,
          difficulty,
          technique,
          comment,
          time,
          exercises_id_exercise,
          id_started_completed
        )
      )
    )
    ''').eq('user_id', uid);
    final List<dynamic> userData = response;
    List<ExerciseData> exerciseDataList = [];

    // Průchod výsledky odpovědi a sběr dat z hloubky vnořených polí
    userData.forEach((user) {
      List<dynamic> muscles = user['muscles'] ?? [];

      muscles.forEach((muscle) {
        List<dynamic> exercises = muscle['exercises'] ?? [];

        exercises.forEach((exercise) {
          List<dynamic> exerciseData = exercise['exercise_data'] ?? [];

          exerciseData.forEach((data) {
            ExerciseData exerciseDataItem = ExerciseData.fromJson(data as Map<String, dynamic>);
            exerciseDataList.add(exerciseDataItem);
          });
        });
      });
    });
    exerciseDataList.sort((a, b) => a.idExData!.compareTo(b.idExData!));
    // for (var exerciseData in exerciseDataList) {
    //   print('Cvičení: ${exerciseData.idExData}, Váha: ${exerciseData.weight} idStartedCompleted: ${exerciseData.idStartedCompleted} exercisesIdExercise: ${exerciseData.exercisesIdExercise}');
    //   // Zde můžete provést další operace s každým záznamem cvičení, například ukládání do SQLite.
    // }
    return exerciseDataList;
  }

  SplitTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    split(
      id_split,
      name_split,
      created_at,
      is_active
    )
    ''').eq('user_id', uid);

    final List<dynamic> data = response[0]["split"];

    List<MySplit> splits = data.map((json) => MySplit.fromJson(json as Map<String, dynamic>)).toList();
    // for (var element in splits) {
    //   print("idSplit: ${element.idSplit} nameSplit: ${element.nameSplit}");
    // }
    return splits;
  }

  SelectedMuscleTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    split(
      selected_muscles(
        split_id_split,
        muscles_id_muscle,
        id_selected_muscle
      )
    )
    ''').eq('user_id', uid);

    final List<dynamic> userData = response as List<dynamic>;
    List<SelectedMuscle> selectedMuscleDataList = [];

    // Průchod výsledky odpovědi a sběr dat z hloubky vnořených polí
    userData.forEach((user) {
      List<dynamic> splits = user['split'] ?? [];

      splits.forEach((split) {
        List<dynamic> selectedMuscles = split['selected_muscles'] ?? [];

        selectedMuscles.forEach((data) {
          if (data != null && data is Map<String, dynamic>) {
            SelectedMuscle selectedMuscleDataItem = SelectedMuscle.fromJson(data);
            selectedMuscleDataList.add(selectedMuscleDataItem);
          }
        });
      });
    });

    selectedMuscleDataList.sort((a, b) => a.idSelectedMuscle!.compareTo(b.idSelectedMuscle!));
    // for (var selectedMuscleData in selectedMuscleDataList) {
    //   print('idSelectedMuscle: ${selectedMuscleData.idSelectedMuscle} splitIdSplit: ${selectedMuscleData.splitIdSplit}  musclesIdMuscle: ${selectedMuscleData.musclesIdMuscle} ');
    //   // Zde můžete provést další operace s každým záznamem cvičení, například ukládání do SQLite.
    // }
    return selectedMuscleDataList;
  }

  SelectedExericseTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    split(
      selected_muscles(
        selected_exercise(
          id_selected_exercise,
          id_exercise,
          id_selected_muscle
        )
      )
    )
    ''').eq('user_id', uid);

    final List<dynamic> userData = response as List<dynamic>;
    List<SelectedExercise> selectedExerciseDataList = [];

    // Průchod výsledky odpovědi a sběr dat z hloubky vnořených polí
    userData.forEach((user) {
      List<dynamic> splits = user['split'] ?? [];

      splits.forEach((split) {
        List<dynamic> selectedMuscles = split['selected_muscles'] ?? [];

        selectedMuscles.forEach((selectedMuscle) {
          List<dynamic> selectedExecises = selectedMuscle['selected_exercise'] ?? [];
          selectedExecises.forEach((data) {
            SelectedExercise selectedExerciseItem = SelectedExercise.fromJson(data as Map<String, dynamic>);
            selectedExerciseDataList.add(selectedExerciseItem);
          });
        });
      });
    });

    selectedExerciseDataList.sort((a, b) => a.idSelectedExercise!.compareTo(b.idSelectedExercise!));

    // for (var selectedExerciseData in selectedExerciseDataList) {
    //   print('idSelectedExercise: ${selectedExerciseData.idSelectedExercise} idExercise: ${selectedExerciseData.idExercise} idSelectedMuscle: ${selectedExerciseData.idSelectedMuscle} ');
    //   // Zde můžete provést další operace s každým záznamem cvičení, například ukládání do SQLite.
    // }
    return selectedExerciseDataList;
  }

  SplitStartedCompletedTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    split(
      split_started_completed(
        id_started_completed,
        created_at,
        split_id,
        ended_at,
        ended
      )
    )
    ''').eq('user_id', uid);

    final List<dynamic> userData = response as List<dynamic>;
    List<SplitStartedCompleted> splitStartedCompletedDataList = [];

    // Průchod výsledky odpovědi a sběr dat z hloubky vnořených polí
    userData.forEach((user) {
      List<dynamic> splits = user['split'] ?? [];

      splits.forEach((split) {
        List<dynamic> splitStartedCompleteds = split['split_started_completed'] ?? [];

        splitStartedCompleteds.forEach((data) {
          if (data != null && data is Map<String, dynamic>) {
            SplitStartedCompleted splitStartedCompletedDataItem = SplitStartedCompleted.fromJson(data);
            splitStartedCompletedDataList.add(splitStartedCompletedDataItem);
          }
        });
      });
    });

    splitStartedCompletedDataList.sort((a, b) => a.idStartedCompleted!.compareTo(b.idStartedCompleted!));
    // for (var splitStartedCompletedData in splitStartedCompletedDataList) {
    //   print('idStartedCompleted: ${splitStartedCompletedData.idStartedCompleted} createdAt: ${splitStartedCompletedData.createdAt}  splitId: ${splitStartedCompletedData.splitId} endedAt: ${splitStartedCompletedData.endedAt} ended: ${splitStartedCompletedData.ended} ');
    //   // Zde můžete provést další operace s každým záznamem cvičení, například ukládání do SQLite.
    // }
    return splitStartedCompletedDataList;
  }

  BodyMeasurementsTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    body_measurements(
      id_body_measurements,
      created_at,
      weight,
      height,
      abdominal_circumference,
      chest_circumference,
      waist_circumference,
      thigh_circumference,
      neck_circumference,
      biceps_circumference
        
    )
    ''').eq('user_id', uid);

    final List<dynamic> data = response[0]["body_measurements"];

    List<Measurements> splits = data.map((json) => Measurements.fromJson(json as Map<String, dynamic>)).toList();
    splits.sort(
      (a, b) => a.idBodyMeasurements!.compareTo(b.idBodyMeasurements!),
    );
    return splits;
  }

  Future<List<Food>> FoodTable(String searchTerm) async {
    String normalizedSearchTerm = removeDiacritics(searchTerm.trim());
    var response;
    // Dotaz do Supabase s použitím funkce unaccent
    if (selectedCountry == null || selectedCountry == "none") {
      print("undefined");
      response = await supabase.from('food').select().ilike('unaccent_name', '%${normalizedSearchTerm}%');
    } else {
      print("$selectedCountry");
      response = await supabase.from('food').select().ilike('unaccent_name', '%${normalizedSearchTerm}%').eq('country', selectedCountry!);
    }
    List<dynamic> data = response;

    // Mapování JSON dat na objekty třídy Food
    final List<Food> foods = data.map((json) => Food.fromJson(json as Map<String, dynamic>)).toList();

    // Seřazení objektů podle názvu
    foods.sort((a, b) => a.name!.compareTo(b.name!));

    return foods;
  }

  Future<Food?> SelectSpecificFood(int idFood) async {
    // Dotaz do Supabase, kde id_food se rovná idFood
    final response = await supabase.from('food').select().eq('id_food', idFood).limit(1).single();

    // Kontrola, zda byl vrácen nějaký záznam
    if (response != null) {
      // Převedení JSON dat na objekt třídy Food
      return Food.fromJson(response as Map<String, dynamic>);
    }

    // Pokud žádný záznam nebyl nalezen, vrátit null
    return null;
  }

  Future<List<Food?>> selectSpecificFoods(Set<int> idsFood) async {
    // Convert Set<int> to a comma-separated string
    String idsFoodStr = idsFood.join(',');

    // Query Supabase for specific foods
    final response = await supabase
        .from('food') // Replace with your table name
        .select()
        .filter('id_food', 'in', '($idsFoodStr)');

    // Convert response data to a list of Food objects
    List<Food> foodList = (response as List<dynamic>).map((json) => Food.fromJson(json as Map<String, dynamic>)).toList();

    return foodList;
  }

  IntakeCategoriesTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    intake_categories(
      id_intake_category,
      name       
    )
    ''').eq('user_id', uid);

    final List<dynamic> data = response[0]["intake_categories"];

    List<IntakeCategories> splits = data.map((json) => IntakeCategories.fromJson(json as Map<String, dynamic>)).toList();
    splits.sort(
      (a, b) => a.idIntakeCategory!.compareTo(b.idIntakeCategory!),
    );
    return splits;
  }

  NutriIntakeTable() async {
    final uid = supabase.auth.currentUser!.id;

    final response = await supabase.from('users').select('''
    nutri_intake(
      id_nutri_intake,
      id_food,
      quantity,
      weight,
      created_at,
      id_intake_category       
    )
    ''').eq('user_id', uid);

    final List<dynamic> data = response[0]["nutri_intake"];

    List<NutriIntake> nutriIntake = data.map((json) => NutriIntake.fromJson(json as Map<String, dynamic>)).toList();
    nutriIntake.sort(
      (a, b) => a.idNutriIntake!.compareTo(b.idNutriIntake!),
    );
    return nutriIntake;
  }
//
}
