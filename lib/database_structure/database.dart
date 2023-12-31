import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

//data.db je databáze s tabulkami nově přidanými jídly a ukládání denních hodnot
class DbController extends ChangeNotifier {
  late Database _database;

  Future<void> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("initilizing DB");

    // create data database
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dataDbPath = path.join(applicationDirectory.path, "assets/db/");
    debugPrint('cesta k databázi:${dataDbPath}');

    _database = await openDatabase(
      dataDbPath,
      onCreate: (db, version) async {
        debugPrint("creating dataDb tables...");
        //newFoodData je nová databáze pro ukládání nově přidaných jídel
        //dailyData je databáze pro ukládání denních hodnot, neukládají se gramy protože v programu vše převedu na gramy a budu to násobit požadovanou hodnotou
        await db.execute('''
          CREATE TABLE "newFoodData" (
            "ID"	INTEGER NOT NULL,
            "CZFOODNAME"	TEXT,
            "ENERGYKCAL"	INTEGER,
            "PROTEIN"	REAL,
            "CARBS"	INTEGER,
            "FAT"	INTEGER,
            "FIBER"	INTEGER,
            "SUGGAR"	TEXT,
            "FATSATURATED"	INTEGER,
            "FATMONOSATURATED"	INTEGER,
            "FATTRANS"	TEXT,
            "FATPOLYUNSATURATED"	INTEGER,
            "WATER[g]"	REAL,
            "CHOLESTEROL"	INTEGER,
            "NA[mg]"	INTEGER,
            "NACL[g]"	INTEGER,
            "VITAMIN_A"	INTEGER,
            "VITAMIN_B1"	INTEGER,
            "VITAMIN_B2"	INTEGER,
            "VITAMIN_B3"	INTEGER,
            "VITAMIN_B4"	INTEGER,
            "VITAMIN_B5"	INTEGER,
            "VITAMIN_B6"	INTEGER,
            "VITAMIN_B7"	INTEGER,
            "VITAMIN_B9"	INTEGER,
            "VITAMIN_B12"	INTEGER,
            "VITAMIN_C"	INTEGER,
            "VITAMIN_D"	INTEGER,
            "VITAMIN_E"	INTEGER,
            "VITAMIN_K"	INTEGER,
            "ENFOODNAME"	TEXT,
            PRIMARY KEY("ID")
            );
            CREATE TABLE "dailyData" (
                "ID" INTEGER PRIMARY KEY ,
                "servingSize" NUMERIC NOT NULL
            );

          ''');
      },
      version: 1,
    );
    // oddělat komentáře ctrl shift ú
    debugPrint("databáze zavřena");
    //   mainFoodDatabase database
    String mainFoodDatabasePath =
        path.join(applicationDirectory.path, "mainFoodDatabase.db");

    // Copy from asset
    debugPrint("kopírování db z assetu");
    ByteData data =
        await rootBundle.load(path.join("assets/db", "mainFoodDatabase.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // Write and flush the bytes written
    await io.File(mainFoodDatabasePath).writeAsBytes(bytes, flush: true);

    _database = await openDatabase(mainFoodDatabasePath);

    // attach dataDb
    // try {
    debugPrint("spojování databáze");
    debugPrint(dataDbPath);
    await _database.rawQuery(
        "ATTACH DATABASE '$dataDbPath' as 'dataDb'"); //ověřit že funguje
    var hhh = await _database.rawQuery("select * from dataDb.newFoodData");
    debugPrint("${hhh}");
//NutriFoodDatabaze
//newFoodData

    // } catch (e) {
    // database is already attached ignore
    // debugPrint("databáze už byla spojena");
  }

// Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    await _database.rawQuery('''
      insert into newFoodData (czfoodname,energykcal) values ('${dog.czfoodname}', '${dog.energykcal}');
    ''');
  }

  Future<List<Dog>> getDogs() async {
    debugPrint("getDogs");
    List<Map<String, Object?>> result = await _database.rawQuery('''
      
      select id, czfoodname, energykcal from dataDb.NutriDatabaze;
    ''');
    //NutriDatabaze
    //newFoodData

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
      delete from newFoodData where id = $id;
    ''');
  }
}

class Dog {
  final String id;
  final String czfoodname;
  final String energykcal;

  const Dog({
    this.id = "-1",
    required this.czfoodname,
    required this.energykcal,
  });

  Dog.fromMap(Map<String, dynamic> item)
      : id = item["ID"].toString(),
        czfoodname = item["CZFOODNAME"].toString(),
        energykcal = item["ENERGYKCAL"].toString();

  // Convert a Dog into a Map. The keys must correspond to the czfoodnames of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'czfoodname': czfoodname,
      'energykcal': energykcal,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, czfoodname: $czfoodname, energykcal: $energykcal}';
  }
}
