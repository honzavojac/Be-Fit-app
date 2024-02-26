import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class usersFirestoreService {
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

  getUser() async {
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
}

class musclesFirestoreService {
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

  addMuscle(String nameOfMucle) async {
    final user = <String, dynamic>{"name of muscle": nameOfMucle};
    await db.collection("muscles").add(user).then(
          (DocumentReference doc) => print("Document ID -${doc.id}"),
        );
  }

  Future<List<Map<String, dynamic>>> getMuscles() async {
    var musclesList = <Map<String, dynamic>>[];

    await db.collection("muscles").get().then(
      (querySnapshot) {
        for (var doc in querySnapshot.docs) {
          print("${doc.id} => ${doc.data()}");
          musclesList.add(doc.data());
        }
      },
    );

    return musclesList;
  }
}
