import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  getUsername() async {
    var documentSnapshot = await db.collection("users").doc(user?.email).get();

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
    var documentSnapshot = await db.collection("users").doc(user?.email).get();
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

  Future<void> addDocument() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');

    print('Added document with ID: ${collection.id}');
  }

  addUser(String name, String email) async {
    final user = <String, dynamic>{"name": name, "email": email};
    await db.collection("users").add(user).then(
          (DocumentReference doc) => print("Document ID -${doc.id}"),
        );
  }

  getUsers() async {
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  updateUser(String name, String email) async {
    final docRef = db.collection("users").doc();
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data();
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // print(docRef);
    final data = {"name": name, "email": email};
    // await db.collection("users").doc().set(data, SetOptions(merge: true));
  }

  addMuscle(String nameOfMucle) async {
    // final user = <String, dynamic>{"name of muscle": nameOfMucle};
    // await db.collection("muscles").add(user).then(
    //       (DocumentReference doc) => print("Document ID -${doc.id}"),
    //     );
    await db
        .collection("users")
        .doc("honzavojac@gmail.com")
        .collection("muscles")
        .doc("$nameOfMucle")
        .set({"name": "$nameOfMucle"});
  }

  Future<List<Map<String, dynamic>>> getMuscles() async {
    var musclesList = <Map<String, dynamic>>[];

    await db
        .collection("users")
        .doc(user?.email)
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
          .doc("honzavojac@gmail.com")
          .collection("splits")
          .get();

      int splitNumber = splitSnapshot.size;
      // print("Počet dokumentů v kolekci: $splitNumber");

      // Uložení mapy svalů pod názvem splitu
      await db
          .collection("users")
          .doc("honzavojac@gmail.com")
          .collection("splits")
          .doc("${splitName}")
          .set({"name": splitName, "muscles": musclesMap});
      // print(musclesMap);
      notifyListeners();
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
        .doc(user?.email)
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
    // notifyListeners();
    return splitsList;
  }

  Future<List<Map<String, dynamic>>> getSplitMuscles(String splitName) async {
    var splitsList = <Map<String, dynamic>>[];

    DocumentSnapshot<Map<String, dynamic>> document = await db
        .collection("users")
        .doc(user?.email)
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
      print('Vybrané svaly: $splitsList');
    } else {
      print('Dokument neexistuje.');
    }

    return splitsList;
  }
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