import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DbController {
  late Database _database;

  Future<void> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("initilizing DB");

    // create data database
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dataDbPath = path.join(applicationDirectory.path, "data.db");
    debugPrint(dataDbPath);

    _database = await openDatabase(
      dataDbPath,
      onCreate: (db, version) async {
        debugPrint("creating dataDb tables...");
        await db.execute('''
          CREATE TABLE dog (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age NUMBER
          );
          ''');
      },
      version: 1,
    );
    // await dataDb.close();

    // questions database
    // String questionsDbPath =
    //     path.join(applicationDirectory.path, "questions.db");

    // // Copy from asset
    // ByteData data =
    //     await rootBundle.load(path.join("assets/db", "questions.db"));
    // List<int> bytes =
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // // Write and flush the bytes written
    // await io.File(questionsDbPath).writeAsBytes(bytes, flush: true);

    // _database = await openDatabase(questionsDbPath);

    // attach dataDb
    // try {
    //   await _database.rawQuery("ATTACH DATABASE '$dataDbPath' as 'dataDb'");
    // } catch (e) {
    //   // database is already attached ignore
    //   debugPrint("database already attached, not attaching again");
    // }
  }

// Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    await _database.rawQuery('''
      insert into dog (name,age) values ('${dog.name}', '${dog.age}');
    ''');
  }

  Future<List<Dog>> getDogs() async {
    List<Map<String, Object?>> result = await _database.rawQuery('''
      select id, name, age from dog;
    ''');
    debugPrint(result.toString());
    return result.map((e) => Dog.fromMap(e)).toList();
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.

    // Update the given Dog.
    await _database.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    await _database.rawQuery('''
      delete from dog where id = $id;
    ''');
  }
}

class Dog {
  final int id;
  final String name;
  final String age;

  const Dog({
    this.id = -1,
    required this.name,
    required this.age,
  });

  Dog.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        age = item["age"];

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
