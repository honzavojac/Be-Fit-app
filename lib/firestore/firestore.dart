import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

  //bullshit, načítá se do něho hodnoty, které se převádí do mapy v fitness record page (mělo by to spíše být tak, že to budou mapy a ne listy map)
  List<Map<String, dynamic>> listSplits = [];
  List<Map<String, dynamic>> listFinalExercises = [];
  List<Map<String, dynamic>> listSplitMuscles = [];

  //proměnné (mapy) pro místo převodu
  Map<String, dynamic> mapSplits = {};
  Map<String, dynamic> mapFinalExercises = {};
  Map<String, dynamic> mapSplitMuscles = {};

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
  Map<String, dynamic> mapExercisesSplits = {};

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
  Future<List<Map<String, dynamic>>> getMuscles() async {
    var musclesList = <Map<String, dynamic>>[];

    await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          // print("${doc.id} => ${doc.data()}");
          musclesList.add(doc.data());
        }
      },
    );
    return musclesList;
  }

  //vytvoření a uložení nového cviku do firebase
  addExercise(String nameOfExercise, String muscle) async {
    await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc(chosedMuscle).collection("exercises").doc(nameOfExercise).set({"name": nameOfExercise});
    notifyListeners();
  }

  //získání cviků z firebase
  Future<List<Map<String, dynamic>>> getExercises() async {
    var exercisesList = <Map<String, dynamic>>[];

    await db.collection("users").doc(auth.currentUser!.uid).collection("muscles").doc(chosedMuscle).collection("exercises").get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          exercisesList.add(doc.data());
        }
      },
    );
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
        var muscleName = muscles[i]["name"] as String;
        if (isCheckedList.length > i) {
          musclesMap[muscleName] = isCheckedList[i];
        } else {
          // print("aaaaa${isCheckedList.length}");
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
          // print("${doc.id} => ${doc.data()}");
          splitsList.add(doc.data());
        }
      },
    );
    listSplits = splitsList;
    return splitsList;
  }

  //odstranění splitu z firebase
  Future<void> deleteSplit(String docID) {
    return db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(docID).delete();
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

  //získání "true" cviků ze splitu
  Future getTrueSplitExercise() async {
    List<String> exercises = [];
    try {
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").doc(chosedMuscle).get().then((value) {
        // Převedení dynamického seznamu na seznam řetězců
        exercises = (value["exercises"] as List<dynamic>).map((e) => e.toString()).toList();
      });
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    print(exercises);
    // notifyListeners();
    return exercises;
  }

  //získání cviků z právě zvoleného splitu
  Future<List<Map<String, String>>> getCurrentSplitExercises() async {
    List<Map<String, String>> exercises = [];
    try {
      await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).collection("exercises").get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          List<dynamic> exerciseNames = doc["exercises"]; // Přečtěte pole názvů cvičení
          String muscleName = doc.id; // Přečtěte název svalu
          exerciseNames.forEach((name) {
            exercises.add({
              "muscle": muscleName,
              "exercise": name.toString(),
            }); // Přidejte každý název cvičení s odpovídajícím svalovým názvem do seznamu exercises
          });
        });
      });
    } catch (e) {
      print('Error getting all exercises: $e');
    }
    return exercises;
  }

  //získání svalů splitu
  Future<List<Map<String, dynamic>>> getSplitMuscles(String splitName) async {
    var splitsList = <Map<String, dynamic>>[];

    DocumentSnapshot<Map<String, dynamic>> document = await db.collection("users").doc(auth.currentUser!.uid).collection("splits").doc(splitName).get();

    if (document.exists) {
      Map<String, dynamic> splitData = document.data() ?? {};

      // Získání mapy s hodnotami true/false pro jednotlivé svaly
      Map<String, dynamic> musclesMap = splitData['muscles'] ?? {};

      // Získání názvů svalů s hodnotou true
      List<String> selectedMuscles = musclesMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();

      // Vytvoření seznamu map s informacemi o svalích
      splitsList = selectedMuscles.map((muscleName) {
        return {
          'name': muscleName,
          // Zde můžete přidat další informace o svalu, pokud jsou dostupné v datovém modelu
        };
      }).toList();

      // Výsledek
    } else {
      print('Dokument neexistuje.');
    }
    print(splitsList);
    return splitsList;
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
        Map<String, dynamic> data = exerciseData[muscleKey][exerciseKey];

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
  Future<void> LoadExerciseData() async {
    print("list splits: $listSplits");
    print("list final exercises: $listFinalExercises");
    print("list split muscles: $listSplitMuscles");

// // Projděte všechny položky v listFinalExercises
//     listFinalExercises.forEach((exercise) {
//       // Získejte hodnoty svalů a cvičení z každé položky
//       String muscle = exercise["muscle"];
//       String exerciseName = exercise["exercise"];

//       // Pokud sval již existuje v mapě, přidejte cvičení do seznamu cvičení pro daný sval
//       if (mapFinalExercises.containsKey(muscle)) {
//         mapFinalExercises[muscle]!.add(exerciseName);
//       } else {
//         // Pokud sval ještě neexistuje v mapě, vytvořte nový seznam cvičení pro daný sval
//         mapFinalExercises[muscle] = [exerciseName];
//       }
//     });

// // Výpis mapy cvičení podle svalů
//     print(mapFinalExercises);
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
