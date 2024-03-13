import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class FirestoreService extends ChangeNotifier {
  /* //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //CREATE
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //READ
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //UPDATE
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //DELETE
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
  */
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  getUsername() async {
    var documentSnapshot =
        await db.collection("users").doc(auth.currentUser?.uid).get();

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

  getUserEmail() async {
    var documentSnapshot =
        await db.collection("users").doc(auth.currentUser?.uid).get();
    print(documentSnapshot.toString());
    if (documentSnapshot.exists) {
      var userData = documentSnapshot.data();

      // Získání konkrétní části dokumentu
      var desiredValue = userData?["email"];
      print("Desired value: $desiredValue");
      return desiredValue;
    } else {
      print("Dokument neexistuje");
    }
  }

  addUser(String name, String email) async {
    final user = <String, dynamic>{"name": name, "email": email};
    await db.collection("users").doc(auth.currentUser?.uid).set(user);
  }

  addMuscle(String nameOfMucle) async {
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("muscles")
        .doc("$nameOfMucle")
        .set({"name": "$nameOfMucle"});
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getMuscles() async {
    var musclesList = <Map<String, dynamic>>[];

    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("muscles")
        .get()
        .then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          // print("${doc.id} => ${doc.data()}");
          musclesList.add(doc.data());
        }
      },
    );

    return musclesList;
  }

  addExercise(String nameOfExercise, String muscle) async {
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("muscles")
        .doc(chosedMuscle)
        .collection("exercises")
        .doc(nameOfExercise)
        .set({"name": nameOfExercise});
    notifyListeners();
  }

  String? chosedMuscle = "";

  Future<List<Map<String, dynamic>>> getExercises() async {
    var exercisesList = <Map<String, dynamic>>[];

    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("muscles")
        .doc(chosedMuscle)
        .collection("exercises")
        .get()
        .then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          exercisesList.add(doc.data());
        }
      },
    );

    return exercisesList;
  }

  List<bool> isCheckedList = [];
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

      // for (var muscle in muscles) {
      //   var muscleName = muscle["name"] as String;
      //   musclesMap[muscleName] =
      //       musclesMap[muscle]; // Nastavte výchozí hodnotu na false
      // }
      for (var element in isCheckedList) {
        // print("$element");
      }
      QuerySnapshot splitSnapshot = await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .get();

      // print("Počet dokumentů v kolekci: $splitNumber");

      // Uložení mapy svalů pod názvem splitu
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .doc("${splitName}")
          .set({"name": splitName, "muscles": musclesMap});
      // print(musclesMap);
    } catch (error) {
      print("Chyba při přidávání splitu: $error");
      // Zpracování chyby podle potřeby (např. zobrazení chybového hlášení).
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getSplits() async {
    var splitsList = <Map<String, dynamic>>[];

    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("splits")
        .get()
        .then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          // print("${doc.id} => ${doc.data()}");
          splitsList.add(doc.data());
        }
      },
    );
    return splitsList;
  }

  Future<void> deleteSplit(String docID) {
    return db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("splits")
        .doc(docID)
        .delete();
  }

  late String splitName;
  Future<void> addTrueSplitExercise(String exerciseName) async {
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .doc(splitName)
          .collection("exercises")
          .doc(chosedMuscle)
          .set({
        'exercises': FieldValue.arrayUnion([exerciseName]),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    notifyListeners();
  }

  Future<void> DeleteTrueSplitExercise(String exerciseName) async {
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .doc(splitName)
          .collection("exercises")
          .doc(chosedMuscle)
          .update({
        'exercises': FieldValue.arrayRemove([exerciseName])
      });
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    notifyListeners();
  }

  Future getTrueSplitExercise() async {
    List<String> exercises = [];
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .doc(splitName)
          .collection("exercises")
          .doc(chosedMuscle)
          .get()
          .then((value) {
        // Převedení dynamického seznamu na seznam řetězců
        exercises = (value["exercises"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      });
    } catch (e) {
      print('Error adding exercise to split: $e');
    }
    // print(exercises);
    // notifyListeners();
    return exercises;
  }

  Future<List<Map<String, String>>> getCurrentSplitExercises() async {
    List<Map<String, String>> exercises = [];
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("splits")
          .doc(splitName)
          .collection("exercises")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          List<dynamic> exerciseNames =
              doc["exercises"]; // Přečtěte pole názvů cvičení
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

  Future<List<Map<String, dynamic>>> getSplitMuscles(String splitName) async {
    var splitsList = <Map<String, dynamic>>[];

    DocumentSnapshot<Map<String, dynamic>> document = await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("splits")
        .doc(splitName)
        .get();

    if (document.exists) {
      Map<String, dynamic> splitData = document.data() ?? {};

      // Získání mapy s hodnotami true/false pro jednotlivé svaly
      Map<String, dynamic> musclesMap = splitData['muscles'] ?? {};

      // Získání názvů svalů s hodnotou true
      List<String> selectedMuscles = musclesMap.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();

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

    return splitsList;
  }

  Future<List<Map<String, dynamic>>> getSplitExercises(
      String splitName, List<Map<String, dynamic>> muscleNames) async {
    var exercisesList = <Map<String, dynamic>>[];

    for (int i = 0; i < muscleNames.length; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .collection("splits")
            .doc(splitName)
            .collection("exercises")
            .doc(muscleNames[i]["name"])
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() ?? {};
          List<dynamic> exercises = data['exercises'] ?? [];

          // Add each exercise to the list with the associated muscle name
          exercisesList.addAll(exercises.map((exercise) {
            return {
              'muscleName': muscleNames[i]["name"],
              'exerciseName': exercise.toString(),
            };
          }));
        } else {
          print(
              'Document exercises does not exist for muscle: ${muscleNames[i]["name"]}');
        }
      } catch (e) {
        print('Error fetching exercises: $e');
      }
    }
    return exercisesList;
  }

  //
  //
  //
  //
}

/* //get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //CREATE
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //READ
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //UPDATE
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //DELETE
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
  */
