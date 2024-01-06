import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///
///pro rebuild aplikace
///flutter clean
///flutter run
///

///toto je pro ovládání

class DBHelper extends ChangeNotifier {
  late Database _database;
  late String _assetsDatabasePath;
  late String databasesPath;

  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    databaseFactoryOrNull = null;
    databaseFactory = databaseFactoryFfi;
    databasesPath = (await getApplicationDocumentsDirectory()).path;
    String appPath = join(databasesPath, 'database.db');

    _database = await openDatabase(appPath, version: 1,
        onCreate: (Database db, int version) {
      db.execute(
        "CREATE TABLE Notes(ID INTEGER PRIMARY KEY AUTOINCREMENT, GRAMS INTEGER, CZFOODNAME TEXT NOT NULL, ENERGYKCAL INTEGER,PROTEIN REAL,CARBS REAL,FAT REAL,FIBER REAL)",
      );
      print("Databáze byla vytvořena");
    });

    _assetsDatabasePath = await assetsDB();
    print(_assetsDatabasePath);

    await _database
        .rawQuery('''ATTACH DATABASE '$_assetsDatabasePath' AS DB''');

    var result = await _database.query('Notes');
    print("Notes database:$result");

    print("inicializace proběhla úspěšně\n\n\n\n\n\n\n");

    return _database;
  }

  Future<void> deleteFile(String fileName) async {
    try {
      // Získání cesty k adresáři, kde jsou ukládány soubory
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Vytvoření cesty k souboru
      String filePath = '${appDocDir.path}/$fileName';

      // Kontrola, zda soubor existuje
      if (await File(filePath).exists()) {
        // Pokud existuje, smazat soubor
        await File(filePath).delete();
        print('Soubor $fileName byl smazán.');
      } else {
        print('Soubor $fileName neexistuje.');
      }
    } catch (e) {
      print('Chyba při mazání souboru: $e');
    }
  }

  Future<String> assetsDB() async {
    String databasesPath = (await getApplicationDocumentsDirectory()).path;
    String assetsPath = join(databasesPath, "foodDatabase.db");
    // print("Cesta k assets databázi: $assetsPath");

    var exists = await databaseExists(assetsPath);
    // print("Ověření existence databáze: $exists");

    if (exists) {
      print("\nVytváření assets databáze");
      try {
        await Directory(dirname(assetsPath)).create(recursive: true);
      } catch (_) {
        print("chyba");
      }

      ByteData data = await rootBundle.load(join("assets", "foodDatabase.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(assetsPath).writeAsBytes(bytes, flush: true);
      print("vytvoření assets databáze proběhlo úspěšně");
    }

    return assetsPath;
  }

  Future<List<Note>> Notes() async {
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        '''SELECT ID,CZFOODNAME,ENERGYKCAL,PROTEIN,CARBS,FAT,FIBER FROM Notes''');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['ID'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
        kcal: maps[i]['ENERGYKCAL'] as int,
        protein: maps[i]['PROTEIN'] as double,
        carbs: maps[i]['CARBS'] as double,
        fat: maps[i]['FAT'] as double,
        fiber: maps[i]['FIBER'] as double,
      );
    });
  }

  Future<List<Map<String, Object?>>> a() async {
    var joinResult =
        await _database.rawQuery('''SELECT CZFOODNAME FROM Notes''');
    print("vše------------$joinResult");
    return joinResult;
  }

  Future<List<String>> getCzFoodNames() async {
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('''SELECT CZFOODNAME FROM NutriDatabaseData''');

    return List.generate(maps.length, (i) {
      return maps[i]['CZFOODNAME'].toString();
    });
  }

  Future<int> getKcalForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT ENERGYKCAL FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['ENERGYKCAL'];
    } else {
      // Vracet defaultní hodnotu nebo vyvolat chybu, pokud není hodnota nalezena
      return 0;
    }
  }

  Future<double> getProteinForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT PROTEIN FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['PROTEIN'];
    } else {
      return 0;
    }
  }

  Future<double> getCarbsForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT CARBS FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['CARBS'];
    } else {
      return 0;
    }
  }

  Future<double> getFatForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT FAT FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['FAT'];
    } else {
      return 0;
    }
  }

  Future<double> getFiberForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT FIBER FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['FIBER'];
    } else {
      return 0;
    }
  }

  Future<List<String>> getNotes() async {
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        '''SELECT ID,CZFOODNAME,ENERGYKCAL,PROTEIN,CARBS,FAT,FIBER FROM NutriDatabaseDataData''');

    print(maps);
    for (var h in maps) {
      print(h['FIBER'].runtimeType);
    }

    return List.generate(maps.length, (i) {
      double fiber;
      if (maps[i]['FIBER'] == Null) {
        fiber = 0;
        print("NULLLLL");
      } else {
        // print(maps[i]['FIBER']);
        fiber = double.parse(maps[i]['FIBER'].toString());
      }

      return Note(
        id: maps[i]['ID'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
        kcal: maps[i]['ENERGYKCAL'] as int,
        protein: maps[i]['PROTEIN'] as double,
        carbs: double.parse((maps[i]['CARBS']).toString()),
        fat: double.parse(maps[i]['FAT'].toString()),
        fiber: fiber,
      ).toString();
    });
  }

  late int grams;
  late String nameOfFood;
  late int kcal;
  late double protein;
  late double carbs;
  late double fat;
  late double fiber;

  NutritionsData(String text, int kcal, double protein, double carbs,
      double fat, double fiber) async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    this.nameOfFood = text;
    this.kcal = kcal;
    this.protein = protein;
    this.carbs = carbs;
    this.fat = fat;
    this.fiber = fiber;
  }

  late double finalGrams;
  late int finalKcal;
  late double finalProtein;
  late double finalCarbs;
  late double finalFat;
  late double finalFiber;

  Grams(int grams) async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    this.grams = grams;
    print(this.grams);
  }

  late String finalSelectedValue = "grams";
  setSelectedValue(String selectedValue) {
    this.finalSelectedValue = selectedValue;
  }

  selectedMultiply() {
    if (this.finalSelectedValue == "grams") {
      print("grams");
      this.finalGrams = double.parse((this.grams / 100).toString());
    } else if (this.finalSelectedValue == "100g") {
      print("100g");
      this.finalGrams = double.parse((this.grams).toString());
    }
  }

  countData() {
    selectedMultiply();
    this.finalKcal =
        int.parse((this.kcal * this.finalGrams).round().toString());
    this.finalProtein =
        (((this.protein * this.finalGrams * 10).round() / 10)).toDouble();
    this.finalCarbs =
        (((this.carbs * this.finalGrams * 10).round() / 10)).toDouble();
    this.finalFat =
        (((this.fat * this.finalGrams * 10).round() / 10)).toDouble();
    this.finalFiber =
        (((this.fiber * this.finalGrams * 10).round() / 10)).toDouble();
  }

  insertAllData() async {
    await countData();
    databaseFactoryOrNull = null; //odstraní sql kecy
    if (this.nameOfFood.isEmpty ||
        this.grams == null ||
        this.finalKcal == null ||
        this.finalProtein == null ||
        this.finalCarbs == null ||
        this.finalFat == null ||
        this.finalFiber == null) {
      return false;
    } else {
      await _database.rawQuery(
          '''INSERT INTO Notes  values(Null,${this.finalGrams},'${this.nameOfFood}',${this.finalKcal},${this.finalProtein},${this.finalCarbs},${this.finalFat},${this.finalFiber})''');
      print(_database.rawQuery('''select * from Notes'''));
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id) async {
    databaseFactoryOrNull = null;

    await _database.delete('Notes', where: 'id = ?', whereArgs: [id]);

    var updatedData = await _database.query('Notes');
    print(updatedData);
  }

  where(Function(dynamic food) param0) {}
}


class Note {
  final int id;
  final int grams;
  final String czfoodname;
  final int kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  Note({
    this.id = 1,
    this.grams = 0,
    this.czfoodname = 'CZFOODNAME',
    this.kcal = 1,
    this.protein = 1,
    this.carbs = 1,
    this.fat = 1,
    this.fiber = 1,
  });

  Note.fromMap(Map<String, dynamic> item)
      : id = item["ID"],
        grams = item["GRAMS"],
        czfoodname = item["CZFOODNAME"],
        kcal = item["ENERGYKCAL"],
        protein = item["PROTEIN"],
        carbs = item["CARBS"],
        fat = item["FAT"],
        fiber = item["FIBER"];

  Map<String, Object> toMap() {
    return {
      'ID': id,
      'GRAMS': grams,
      'CZFOODNAME': czfoodname,
      'ENERGYKCAL': kcal,
      'PROTEIN': protein,
      'CARBS': carbs,
      'FAT': fat,
      'FIBER': fiber,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id,GRAMS: $grams, CZFOODNAME: $czfoodname, ENERGYKCAL: $kcal,PROTEIN: $protein,CARBS:$carbs,FAT:$fat,FIBER:$fiber}';
  }
}
