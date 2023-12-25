import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late Database _database;
  late String
      _assetsDatabasePath; // Nová proměnná pro uchování cesty k assets databázi

  initializeDB() async {
  a() async {
    var joinResult = await _database.rawQuery('''
  SELECT * FROM Notes
  UNION ALL
  SELECT * FROM TestNotes
  
''');

    print("vše------------$joinResult");

    
      return joinResult;
    
  }
    databaseFactoryOrNull = null;
    databaseFactory = databaseFactoryFfi;
    String databasesPath = await getDatabasesPath();
    String appPath = join(databasesPath, 'database.db');

    _database = await openDatabase(appPath, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
        "CREATE TABLE Notes(id INTEGER AUTOINCREMENT, description TEXT NOT NULL)",
      );
    });

    _assetsDatabasePath = await assetsDB(); // Uložení cesty k assets databázi
    print("Assets Database Path: $_assetsDatabasePath");

    await _database.rawQuery("ATTACH DATABASE '$_assetsDatabasePath' AS DB");
    var result = await _database.query('Notes');
    print("Notes database:$result");
    var result1 = await _database.query("TestNotes");
    print("TestNotes database:$result1");

    return _database;
  }
  a() async {
    var joinResult = await _database.rawQuery('''
      SELECT * FROM Notes
      UNION ALL
      SELECT * FROM TestNotes
    ''');

    print("vše------------$joinResult");

    return joinResult;
  }

  Future<String> assetsDB() async {
    String databasesPath = await getDatabasesPath();
    String assetsPath = join(databasesPath, "TestNote.db");
    print("Cesta k assets databázi: $assetsPath");

    var exists = await databaseExists(assetsPath);
    print("Ověření existence databáze: $exists");

    if (!exists) {
      print("\nVytváření databáze");
      try {
        await Directory(dirname(assetsPath)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "TestNote.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(assetsPath).writeAsBytes(bytes, flush: true);
    }

    return assetsPath; // Vracíme cestu k assets databázi (typu String)
  }

  insertItem() async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    final db = await initializeDB();
    await db.execute('''INSERT INTO Notes values("ahoj")''');
  }
}

/*
class dbHelper {
  late Database _database;

  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    var assetsPath;
    var appPath;

    databaseFactoryOrNull = null; //odstraní sql kecy
    databaseFactory = databaseFactoryFfi;
    //adresář databází
    String databasesPath = await getDatabasesPath();
    print("Cesta k adresáři databází:${databasesPath}"); //kde cesta k databázím

    //vytvoření assets databáze
    assetsPath = join(databasesPath, "TestNote.db");
    print("Cesta k assets databázi:${assetsPath}"); //cesta k TestNote.db
    var exists = await databaseExists(assetsPath);
    print("ověření existence databáze${exists}"); //true / false
    if (!exists) {
      print("\nVytváření databáze");
      try {
        await Directory(dirname(assetsPath)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets", "TestNote.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Write and flush the bytes written
      await File(assetsPath).writeAsBytes(bytes, flush: true);

      ///
      ///
      ///
    } else {
      print("\nOpening existing assets database");
      // otevření assets databáze
      var a = await openDatabase(assetsPath, readOnly: true);
      // print("Cesta k assets databázi:${assetsDb}");
      var result = await a.query('TestNotes');
      print("Assets databáze:\n${result}\n");

      //vytvoření aplikační databáze
      print("Otevření aplikační databáze");
      appPath = join(databasesPath, 'database.db');
      print("Cesta k aplikační databázi:${appPath}");
      _database = await openDatabase(join(appPath),
          onCreate: (database, version) async {
        debugPrint("Vytváření databáze");
        await database.execute(
          "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL)",
        );
        debugPrint("Databáze byla votvořena");
      }, version: 1);
      var resultDb = await _database.query('Notes');
      print("Aplikační databáze:\n${resultDb}");

      ///
      ///
      ///
      ///
      await _database
          .rawQuery("ATTACH DATABASE '$appPath' as 'DATABASE'")
          .catchError((e) {
        print(e);
      }).whenComplete(() {
        print("attach complete");
      });
      print("\n\n\n");
      var result1 = await _database.query('DATABASE');
      print(result1);
    }

    /* var db = openDatabase(data);
    await attachUserDb(db: db, databaseName: "TestNote.db");
    return db;*/
    //var allDatabases = attachUserDb(db: db, databaseName: databaseName)
    return openDatabase(assetsPath);
  }

/* 
  someMethod() async {
    final Database db = await initializeDB();
    print("attach database");
    var a = await attachUserDb(db: db, databaseName: "DATABASE");
    print(a);
    var result = await a.query('DATABASE.Notes');

    ///tabulky se jmenují:
    /// TestNotes
    /// Notes
    print(result);
  }

  Future<Database> attachUserDb(
      {required Database db, required String databaseName}) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String absoluteEndPath = join(documentDirectory.path, databaseName);
    print(absoluteEndPath);
    await db
        .rawQuery("ATTACH DATABASE '$absoluteEndPath' as '$databaseName'")
        .catchError((e) {
      print(e);
    }).whenComplete(() {
      print("attach complete");
    });
    return db;
  }
*/
  /*
  Future<Database> attachDb(
      {Database db, String databaseName, String databaseAlias}) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String absoluteEndPath = join(documentDirectory.path, databaseName);
    await db.rawQuery("ATTACH DATABASE '$absoluteEndPath' as '$databaseAlias'");
    return db;
  }
  */
  insertDatabase() async {}
  createItem(Note note) async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    final Database db = await initializeDB();
    final id = await db.insert('Notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // await db.execute('''ALTER TABLE Notes ADD order numeric''');
  }

  getItems() async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    final db = await initializeDB();
    var result = await db.query('Notes');
    print(result);
  }

  insertItem() async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    final db = await initializeDB();
    await db.execute('''INSERT INTO Notes values(5,"ahoj")''');
  }
}
*/
class Note {
  final int id;
  final String description;

  Note({this.id = -1, required this.description});

  Note.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        description = item["description"];

  Map<String, Object> toMap() {
    return {'id': id, 'description': description};
  }
}
