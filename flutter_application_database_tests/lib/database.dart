import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
///
///pro rebuild aplikace
  ///flutter clean
  ///flutter run
///


class DBHelper {
  late Database _database;
  late String
      _assetsDatabasePath; // Nová proměnná pro uchování cesty k assets databázi
  late String databasesPath;

  initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactoryOrNull = null;
    databaseFactory = databaseFactoryFfi;
    databasesPath = await getDatabasesPath();
    String appPath = join(databasesPath, 'database.db');

    _database = await openDatabase(appPath, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
        "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, CZFOODNAME TEXT NOT NULL)",
      );
      print("Databáze byla vytvořena");
    });

    _assetsDatabasePath = await assetsDB(); // Uložení cesty k assets databázi
    // print("Assets Database Path: $_assetsDatabasePath");

    await _database.rawQuery("ATTACH DATABASE '$_assetsDatabasePath' AS DB");
    // var result = await _database.query('Notes');
    // print("Notes database:$result");
    // var result1 = await _database.query("NutriDatabase");
    // print("NutriDatabase database:$result1");
    print("inicializace proběhla úspěšně\n\n\n\n\n\n\n");
    return _database;
  }

  

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Note>> Notes() async {
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('''SELECT id,CZFOODNAME FROM Notes''');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
          // description: maps[i]['description'] as String,
          );
    });
  }



  Future<List<Map<String, Object?>>> a() async {
    var joinResult = await _database.rawQuery('''
 
      SELECT * FROM NutriDatabase
      
    ''');

    print("vše------------$joinResult");

    // var description;
    var id;
    joinResult.forEach((data) {
      // description.add(data['description'] as String);
      id.add(data['ID'] as int?);
    });

    //List<int> cisla = joinResult.map((data) => data['id'] as int).toList();

    // List<String> description =
    //     joinResult.map((data) => data['description'] as String).toList();
    // print(cisla);
    // print(description);
    return joinResult;
  }

  Future<String> assetsDB() async {
    String databasesPath = await getDatabasesPath();
    String assetsPath = join(databasesPath, "foodDatabase.db");
    // print("Cesta k assets databázi: $assetsPath");

    var exists = await databaseExists(assetsPath);
    // print("Ověření existence databáze: $exists");

    if (!exists) {
      print("\nVytváření databáze");
      try {
        await Directory(dirname(assetsPath)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "foodDatabase.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(assetsPath).writeAsBytes(bytes, flush: true);
    }

    return assetsPath; // Vracíme cestu k assets databázi (typu String)
  }

  insertItem(String text) async {
    databaseFactoryOrNull = null; //odstraní sql kecy

    await _database.rawQuery('''INSERT INTO Notes values(null ,"$text")''');
    print(await _database.rawQuery('''select * from Notes'''));
  }

  Future<void> deleteItem(int id) async {
    databaseFactoryOrNull = null;

    await _database.delete('Notes', where: 'id = ?', whereArgs: [id]);
    // Smazání záznamu s id 5
    // await db.execute('DELETE FROM Notes WHERE id = 5');

    // Získání aktualizovaných dat z databáze
    var updatedData = await _database.query('Notes');
    print(updatedData);
  }
}

class Note {
  final int id;
  final String czfoodname;
  // final String description;

  Note({this.id = 1, this.czfoodname = 'CZFOODNAME'});

  Note.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        czfoodname = item["CZFOODNAME"]
  // description = item["description"];
  ;
  Map<String, Object> toMap() {
    return {'id': id, 'CZFOODNAME': czfoodname};
  }

  @override
  String toString() {
    return 'Dog{id: $id, CZFOODNAME: $czfoodname}';
  }
}
