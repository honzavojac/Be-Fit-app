import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  //Proměnné ******************************************************************************************************************************************
  //***************************************************************************************************************************************************

  //proměnné pro firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Určení dnešního datumu
  DateTime now = DateTime.now();

  //proměnná pro uložení všech uživatelem zadaných hodnot do cviků
  Map<String, dynamic> exerciseData = {};

  List<String> allMuscles = [];
  List<String> allExercises = [];

  // načítájí se do ní hodnoty, které se převádí do mapy v fitness record page
  List<Map<String, dynamic>> listSplits = [];
  // List<Map<String, dynamic>> listFinalExercises = [];
  // List<Map<String, dynamic>> listSplitMuscles = [];

  //proměnné (mapy) pro místo převodu
  Map<String, dynamic> mapSplits = {};
  Map<String, dynamic> mapSplitMuscles = {};
  Map<String, dynamic> mapFinalExercises = {};

  //proměnná pro kontrolování stavu
  late int readyState = 0;

  //proměnná kliknutí na tab v edit_split_page, která kontroluje jaký tab je kliknutý
  late int clickedSplitTab = 0;

  //vybraný cvik v fitness record page -- po kliknutí na cvik
  String? chosedExercise;

  //vybraný sval v fitness record page -- po kliknutí na cvik
  String? selectedMuscle;

  //proměnná do které se ukládá comentář cviku
  String? commentExercise;

  //proměnná pro výběr svalu v exercise page -- po kliknutí na exercises
  String? chosedMuscle = "";

  //proměnná sloužící pro vyběř aktivních cviků
  //při novém cviku se nastaví na false
  List<bool> isCheckedList = [];

  //proměnná pro uložení výběru splitu
  late String splitName;

  //mapa pro složení celé mapy
  //FORMÁT:   currunt split -> muscles - > exercises -> exercise data
  //"pull":{"back":{"kladiva":{data}}};
  Map<String, dynamic> fullMapExercises = {};

  //funkce pro zakázání synchronizace / obnovení s firebase *******************************************************************************************
  //***************************************************************************************************************************************************

  //zakáže se synchronizovat s firebase
  void disableSync() async {
    await db.disableNetwork();
    print("synchronizace s firebase odpojena");
  }

  //povolí se synchronizovat s firebase
  void enableSync() async {
    await db.enableNetwork();
    print("synchronizace s firebase zpřístupněna");
  }

//uživatelské funkce (vyytváření a úprava) ************************************************************************************************************

  //přídání jména a emailu při sign up
  addUsername(String name) async {
    db.collection("users").doc(auth.currentUser?.uid).set({"name": name, "email": auth.currentUser?.email});
  }

  //získání jména přihlášeného uživatele
  getUsername() async {
    var documentSnapshot = await db.collection("users").doc(auth.currentUser?.uid).get();

    if (documentSnapshot.exists) {
      var userData = documentSnapshot.data();

      // Získání konkrétní části dokumentu
      var desiredValue = userData?["name"];
      print("Desired value: $desiredValue");
      return desiredValue;
    } else {
      print("Dokument neexistuje");
    }
  }

  //získání emailu přihláčeného uživatele
  getUserEmail() async {
    var documentSnapshot = await db.collection("users").doc(auth.currentUser?.uid).get();
    print(documentSnapshot.toString());
    if (documentSnapshot.exists) {
      var userData = documentSnapshot.data();
      var desiredValue = userData?["email"];
      print("Desired value: $desiredValue");
      return desiredValue;
    } else {
      print("Dokument neexistuje");
    }
  }

  //vytvoření jména a emailu nového uživatele
  addUser(String name, String email) async {
    final user = <String, dynamic>{"name": name, "email": email};
    await db.collection("users").doc(auth.currentUser?.uid).set(user);
  }

  //vytvoření a uložení nového svalu do firebase
  addMuscle(String nameOfMucle) async {
    await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc("$nameOfMucle").set({"name": "$nameOfMucle"});
    notifyListeners();
  }
  //funkce pro pracování s splity, svaly a cviky ******************************************************************************************************
  //***************************************************************************************************************************************************

  //získání svalů z firebase
  Future<List<String>> getMuscles() async {
    List<String> musclesList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        musclesList.add(doc.id);
      }

      allMuscles = musclesList;
      print("všechny svaly: ${allMuscles}");
    } catch (e) {
      print('Error getting muscles: $e');
    }

    return musclesList;
  }

  //vytvoření a uložení nového cviku do firebase
  addExercise(String nameOfExercise, String muscle) async {
    await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc(chosedMuscle).collection("exercises").doc(nameOfExercise).set({"name": nameOfExercise});
    notifyListeners();
  }

  //získání cviků z firebase
  Future<List<String>> getExercises() async {
    List<String> exercisesList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc(chosedMuscle).collection("exercises").get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        exercisesList.add(doc.id);
      }

      allExercises = exercisesList;
    } catch (e) {
      print('Error getting muscles: $e');
    }
    print("allExercises: ${exercisesList}");
    return exercisesList;
  }

  //vytvoření a uložení nového splitu s uložením "true" cviků do firebase
  Future<void> addSplit(String splitName, isCheckedList) async {
    try {
      // Získání seznamu svalů a jejich stavů
      var muscles = await getMuscles();

      // Vytvoření mapy pro uložení svalů a jejich stavu
      Map<String, bool> musclesMap = {};

      // Naplnění mapy svalů ze seznamu svalů
      for (int i = 0; i < muscles.length; i++) {
        var muscleName = muscles[i] as String;

        if (isCheckedList.length > i) {
          musclesMap[muscleName] = isCheckedList[i];
          if (isCheckedList[i] == true) {
            //vytvoření potřebné cesty
            await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc("${splitName}").collection("exercises").doc(muscleName).set({"exercises": []});
            print("vytvořeno");
          }
        } else {
          musclesMap[muscleName] = false;
        }
      }
      // Uložení mapy svalů pod názvem splitu
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc("${splitName}").set({"name": splitName, "muscles": musclesMap});
    } catch (error) {
      print("Chyba při přidávání splitu: $error");
    }

    notifyListeners();
  }

  //získání splitů z firebase
  Future<List<Map<String, dynamic>>> getSplits() async {
    var splitsList = <Map<String, dynamic>>[];

    await db.collection("users").doc(auth.currentUser!.uid).collection("splits").get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          splitsList.add(doc.data());
        }
      },
    );
    listSplits = splitsList;
    return splitsList;
  }

  //odstranění splitu z firebase
  Future<void> deleteSplit(String docID) async {
    await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(docID).delete();

    notifyListeners();
  }

  //přidání "true" cviku do splitu (checkbox)
  Future<void> addTrueSplitExercise(String exerciseName) async {
    try {
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").doc(chosedMuscle).set({
        'exercises': FieldValue.arrayUnion([exerciseName]),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    notifyListeners();
  }

  //odstranění "true" cviku ze splitu (checkbox)
  Future<void> DeleteTrueSplitExercise(String exerciseName) async {
    try {
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").doc(chosedMuscle).update({
        'exercises': FieldValue.arrayRemove([exerciseName])
      });
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    notifyListeners();
  }

  Future<Map<String, Map<String, List<String>>>> getTrueSplitExercise(String splitName) async {
    Map<String, Map<String, List<String>>> exercisesMap = {};
    try {
      // Získání dokumentů pro všechny svaly ve splitu
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").get();

      // Pro každý sval ve splitu
      for (DocumentSnapshot<Map<String, dynamic>> docSnapshot in querySnapshot.docs) {
        // Kontrola existence kolekce exercises pro každý sval
        if (docSnapshot.exists && docSnapshot.data()?.containsKey("exercises") == true) {
          // Převedení dynamického seznamu na seznam řetězců
          List<dynamic> exercisesList = docSnapshot.data()?["exercises"];
          List<String> exercises = exercisesList.map((e) => e.toString()).toList();

          // Uložení seznamu cviků do mapy pro daný sval
          exercisesMap[splitName] ??= {};
          exercisesMap[splitName]![docSnapshot.id] = exercises;
        }
      }
    } catch (e) {
      print('Chyba při získávání cviků ze splitu: $e');
    }

    // Přidejte mapu cviků do mapy mapFinalExercises
    mapFinalExercises.addAll(exercisesMap);

    // Vypsání výsledků pro ověření
    print(mapFinalExercises);

    return exercisesMap;
  }

  //získání cviků z právě zvoleného splitu
  Future<Map<String, List<String>>> getCurrentSplitExercises(String splitName) async {
    Map<String, List<String>> exercisesMap = {};
    try {
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          List<dynamic> exerciseNames = doc["exercises"]; // Přečtěte pole názvů cvičení
          String muscleName = doc.id; // Přečtěte název svalu
          exercisesMap[muscleName] = exerciseNames.cast<String>(); // Přidejte seznam cvičení s odpovídajícím svalovým názvem do mapy exercisesMap
        });
      });
    } catch (e) {
      print('Error getting all exercises: $e');
    }

    // allExercises.addAll(exercisesMap);

    return exercisesMap;
  }

  //získání svalů splitu
  Future<Map<String, List<String>>> getSplitMuscles(String splitName) async {
    var splitMusclesMap = <String, List<String>>{};

    try {} catch (e) {}
    DocumentSnapshot<Map<String, dynamic>> document = await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).get();

    if (document.exists) {
      Map<String, dynamic> splitData = document.data() ?? {};

      // Získání mapy s hodnotami true/false pro jednotlivé svaly
      Map<String, dynamic> musclesMap = splitData['muscles'] ?? {};

      // Získání názvů svalů s hodnotou true
      List<String> selectedMuscles = musclesMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();

      // Přidání seznamu svalů do mapy s odpovídajícím klíčem
      splitMusclesMap[splitName] = selectedMuscles;
    } else {
      print('Dokument pro split "$splitName" neexistuje.');
    }

    mapSplitMuscles.addAll(splitMusclesMap);

    //return se nepoužívá
    return splitMusclesMap;
  }

  //získání cviků ze splitu
  Future<List<Map<String, dynamic>>> getSplitExercises(String splitName, List<Map<String, dynamic>> muscleNames) async {
    var exercisesList = <Map<String, dynamic>>[];

    for (int i = 0; i < muscleNames.length; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").doc(muscleNames[i]["name"]).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() ?? {};
          List<dynamic> exercises = data['exercises'] ?? [];

          // Add each exercise to the list with the associated muscle name
          exercisesList.addAll(
            exercises.map(
              (exercise) {
                return {
                  'muscleName': muscleNames[i]["name"],
                  'exerciseName': exercise.toString(),
                };
              },
            ),
          );
        } else {
          print('Document exercises does not exist for muscle: ${muscleNames[i]["name"]}');
        }
      } catch (e) {
        print('Error fetching exercises: $e');
      }
    }
    return exercisesList;
  }

  ///
  /// Ukládání dat cviků
  ///

  //ukládání dat cviku do firebase
  // Future<void> SaveExerciseData() async {
  //   //aktuální čas
  //   String time = "${now.day}.${now.month}.${now.year}";
  //   Map<String, dynamic> finalData = {
  //     "exercise_data": {"$time": {}}
  //   };

  //   for (var a = 0; a < exerciseData.length; a++) {
  //     //svaly
  //     var muscleKey = exerciseData.keys.toList()[a];
  //     // print(muscleKey);
  //     for (var b = 0; b < exerciseData[muscleKey]?.length; b++) {
  //       //cviky
  //       var exerciseKey = exerciseData[muscleKey].keys.toList()[b];
  //       // print(exerciseKey);
  //       // samotné hodnoty

  //       for (var i = 0; i < exerciseData[muscleKey][exerciseKey].length; i++) {
  //         Map<dynamic, dynamic> data = {};
  //         if (exerciseData[muscleKey][exerciseKey]["set ${i + 1}"]["weight"] != null || exerciseData[muscleKey][exerciseKey]["set ${i + 1}"]["weight"] != " " || exerciseData[muscleKey][exerciseKey]["set ${i + 1}"]["reps"] != null || exerciseData[muscleKey][exerciseKey]["set ${i + 1}"]["reps"] != " ") {
  //           print("uložit");

  //           data.addAll(exerciseData[muscleKey][exerciseKey]["set ${i + 1}"]);
  //           print(data);
  //           // if (finalData["exercise_data"]["$time"]["series"] == null) {
  //           //   print("null");
  //           // }
  //           //mapa která se uloží na firebase
  //         }
  //         finalData["exercise_data"]["$time"].addAll({
  //           "series": {"set ${i + 1}": data}
  //         });
  //       }
  //       print(finalData);
  //       await db.collection("users").doc(auth.currentUser?.uid).collection("muscles").doc(muscleKey).collection("exercises").doc(exerciseKey).collection("years").doc("${now.year}").set(finalData, SetOptions(merge: true));
  //       print("uloženo");
  //       // uložit do databáze
  //     }
  //   }
  Future<void> SaveExerciseData() async {
    //aktuální čas
    String time = "${now.day}.${now.month}.${now.year}";
    for (var a = 0; a < exerciseData.length; a++) {
      //svaly
      var muscleKey = exerciseData.keys.toList()[a];
      // print(a);
      for (var b = 0; b < exerciseData[muscleKey].length; b++) {
        //cviky
        var exerciseKey = exerciseData[muscleKey].keys.toList()[b];

        // samotné hodnoty
        Map<dynamic, dynamic> data = exerciseData[muscleKey][exerciseKey];

        //mapa která se uloží na firebase
        Map<String, dynamic> finalData = {
          "exercise_data": {
            "$time": {"comment": "$commentExercise", "series": data}
          }
        };
        print(finalData);
        // Získání reference na dokument

        await db.collection("users").doc(auth.currentUser?.uid).collection("muscles").doc(muscleKey).collection("exercises").doc(exerciseKey).collection("years").doc("${now.year}").set(finalData, SetOptions(merge: true));
        print("uloženo");
        // uložit do databáze

        // Funkce pro kontrolu shody dvou map
      }
    }

    // try {
    //   //
    //   Map<String, dynamic> map = exerciseData;
    //   for (var i = 0; i < map.length; i++) {}
    //   await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").collection("exercises").doc(exerciseName).set(exerciseData);
    // } catch (e) {
    //   print('Chyba při ukládání dat ve Firestore: $e');
    // }
  }

  //získání dat z konkrétního cviku (pro zobrazení hodnot, když uživatel zavře aplikaci a z proměnné exerciseData se vymažou hodnoty, tak se znovu do té proměnné načtou)
  Future<void> LoadExerciseData(String splitName, String muscleName, String exerciseName) async {
    // print("list splits: $listSplits");
    // print("map final exercises: ${mapFinalExercises}");
    // print("map split muscles: $mapSplitMuscles");
    try {
      //aktuální čas
      String time = "${now.day}.${now.month}.${now.year}";

      var document = await db.collection("users").doc(auth.currentUser?.uid).collection("muscles").doc(muscleName).collection("exercises").doc(exerciseName).collection("years").doc("${now.year}").get();

      // print(document["exercise_data"]["${time}"]);

      //FORMÁT:   currunt split -> muscles - > exercises -> exercise data

      fullMapExercises.addAll({
        "$splitName": {
          "$muscleName": {
            "$exerciseName": {"date": document["exercise_data"]},
          },
        },
      });
    } catch (e) {}
    // print(fullMapExercises[splitName][selectedMuscle][chosedExercise]["date"]);
    // for (var i = 0; i < fullMapExercises[splitName][muscleName][exerciseName]["date"].length; i++) {
    //   print(fullMapExercises[splitName][muscleName][exerciseName]["date"].keys.toList()[i]);
    // }
    disableSync();
  }

  Future<void> DeleteExerciseData(String splitName, String muscleName, String exerciseName) async {
    try {
      //aktuální čas
    } catch (e) {}

    disableSync();
  }

  //ostatní *******************************************************************************************************************************************
  //***************************************************************************************************************************************************

  //porovnání dvou map jestli jsou stejné
  bool areEqual(Map map1, Map map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }
}
