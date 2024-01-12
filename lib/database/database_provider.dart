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
///databáze vždy jsou na 100g

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
        '''CREATE TABLE Notes (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            GRAMS INTEGER,
            CZFOODNAME TEXT NOT NULL,
            ENERGYKCAL INTEGER,
            PROTEIN REAL,
            CARBS REAL,
            FAT REAL,
            FIBER REAL
        );

        CREATE TABLE AppNutrients (
            ID INTEGER PRIMARY KEY,
            CZFOODNAME TEXT NOT NULL,
            ENERGYKCAL INTEGER,
            PROTEIN REAL,
            CARBS REAL,
            FAT REAL,
            FIBER REAL
        );

        CREATE TABLE Muscle (
            ID INTEGER PRIMARY KEY,
            NAME TEXT
        );

        CREATE TABLE Split (
            ID_SPLITU INTEGER PRIMARY KEY,
            ID_SVALU INTEGER
        );

        CREATE TABLE Sval (
            ID_SVALU INTEGER PRIMARY KEY,
            NAZEV_SVALU TEXT
        );

        CREATE TABLE Cvik (
            ID_CVIKU INTEGER PRIMARY KEY,
            ID_SVALU INTEGER,
            NAZEV_CVIKU TEXT
        );

        CREATE TABLE DataCviku (
            ID_DATA_CVIKU INTEGER PRIMARY KEY,
            ID_CVIKU INTEGER,
            SERIE INTEGER,
            VAHA REAL,
            OPAKOVANI INTEGER,
            KOMENTAR TEXT,
            DATUM DATE
        );
        CREATE TABLE PromenaSplitu (
           INT_ID INTEGER PRIMARY KEY
        );
        ''',
      );
      print("Databáze byly vytvořeny");
    });

    _assetsDatabasePath = await assetsDB();

    await _database
        .rawQuery('''ATTACH DATABASE '$_assetsDatabasePath' AS DB''');

    var result = await _database.query('Notes');
    print("Notes database:$result");

    print("inicializace proběhla úspěšně");

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

    var exists = await databaseExists(assetsPath);

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
        '''SELECT ID,GRAMS,CZFOODNAME,ENERGYKCAL,PROTEIN,CARBS,FAT,FIBER FROM Notes''');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['ID'] as int,
        grams: maps[i]['GRAMS'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
        kcal: maps[i]['ENERGYKCAL'] as int,
        protein: maps[i]['PROTEIN'] as double,
        carbs: maps[i]['CARBS'] as double,
        fat: maps[i]['FAT'] as double,
        fiber: maps[i]['FIBER'] as double,
      );
    });
  }

  Future<List<Note>> countNotes() async {
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('''SELECT ID,
        CZFOODNAME,
        SUM(ENERGYKCAL)as ENERGYKCAL,
        ROUND(SUM(PROTEIN),1)AS PROTEIN,
        ROUND(SUM(CARBS),1)AS CARBS,
        ROUND(SUM(FAT),1)AS FAT,
        ROUND(SUM(FIBER),1)AS FIBER 
        FROM Notes''');
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

  Future<List<String>> getCzFoodNames() async {
    final List<Map<String, dynamic>> maps = await _database.rawQuery('''
        SELECT CZFOODNAME FROM AppNutrients  UNION ALL
                SELECT CZFOODNAME FROM NutriDatabaseData''');

    return List.generate(maps.length, (i) {
      return maps[i]['CZFOODNAME'].toString();
    });
  }

  Future<int> getKcalForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT ENERGYKCAL FROM AppNutrients WHERE CZFOODNAME = '$food' UNION ALL
SELECT ENERGYKCAL FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['ENERGYKCAL'];
    } else {
      return 0;
    }
  }

  Future<double> getProteinForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT PROTEIN FROM AppNutrients WHERE CZFOODNAME = '$food' UNION ALL SELECT PROTEIN FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['PROTEIN'];
    } else {
      return 0;
    }
  }

  Future<double> getCarbsForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT CARBS FROM AppNutrients WHERE CZFOODNAME = '$food' UNION ALL SELECT CARBS FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['CARBS'];
    } else {
      return 0;
    }
  }

  Future<double> getFatForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT FAT FROM AppNutrients WHERE CZFOODNAME = '$food' UNION ALL SELECT FAT FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['FAT'];
    } else {
      return 0;
    }
  }

  Future<double> getFiberForFood(String food) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
        '''SELECT FIBER FROM AppNutrients WHERE CZFOODNAME = '$food' UNION ALL SELECT FIBER FROM NutriDatabaseData WHERE CZFOODNAME = '$food' ''');

    if (result.isNotEmpty) {
      return result[0]['FIBER'];
    } else {
      return 0;
    }
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
  }

  late String finalSelectedValue = "grams";
  setSelectedValue(String selectedValue) {
    this.finalSelectedValue = selectedValue;
  }

  selectedMultiply() {
    if (this.finalSelectedValue == "grams") {
      this.finalGrams = double.parse((this.grams / 100).toString());
    } else if (this.finalSelectedValue == "100g") {
      this.finalGrams = double.parse((this.grams).toString());
    }
  }

  countData() async {
    await selectedMultiply();
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

    if (this.finalSelectedValue == "grams") {
      this.finalGrams = double.parse((this.grams).toString());
    } else if (this.finalSelectedValue == "100g") {
      this.finalGrams = double.parse((this.grams * 100).toString());
    }
  }

  insertAllDataToNotes() async {
    await countData();
    databaseFactoryOrNull = null; //odstraní sql kecy

    await _database.rawQuery(
        '''INSERT INTO Notes values(Null,${this.finalGrams},'${this.nameOfFood}',${this.finalKcal},${this.finalProtein},${this.finalCarbs},${this.finalFat},${this.finalFiber})''');

    notifyListeners();
  }

  late double newFoodGrams = 0;
  late String newFoodNameOfFood = "";
  late int newFoodKcal = 0;
  late double newFoodProtein = 0;
  late double newFoodCarbs = 0;
  late double newFoodFat = 0;
  late double newFoodFiber = 0;

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  TextEditingController textEditingController3 = TextEditingController();
  TextEditingController textEditingController4 = TextEditingController();
  TextEditingController textEditingController5 = TextEditingController();
  TextEditingController textEditingController6 = TextEditingController();
  TextEditingController textEditingController7 = TextEditingController();
  resetBoxes() {
    this.textEditingController1.clear();
    this.textEditingController2.clear();
    this.textEditingController3.clear();
    this.textEditingController4.clear();
    this.textEditingController5.clear();
    this.textEditingController6.clear();
    this.textEditingController7.clear();
  }

  late String finalNewFoodSelectedValue = "grams";
  setNewFoodSelectedValue(String selectedValue) {
    this.finalNewFoodSelectedValue = selectedValue;
    selectedNewFoodMultiply();
  }

  selectedNewFoodMultiply() {
    if (this.finalNewFoodSelectedValue == "grams") {
      this.newFoodGrams = double.parse((this.newFoodGrams).toString());
    } else if (this.finalNewFoodSelectedValue == "100g") {
      this.newFoodGrams = double.parse((this.newFoodGrams * 100).toString());
    }
  }

  countNewFoodData() {
    selectedNewFoodMultiply();
    this.newFoodKcal = int.parse(
        (this.newFoodKcal / this.newFoodGrams * 100).round().toString());
    this.newFoodProtein = this.newFoodProtein / this.newFoodGrams * 100;
    this.newFoodCarbs = this.newFoodCarbs / this.newFoodGrams * 100;
    this.newFoodFat = this.newFoodFat / this.newFoodGrams * 100;
    this.newFoodFiber = this.newFoodFiber / this.newFoodGrams * 100;
  }

  insertNewFood() async {
    await countNewFoodData();
    databaseFactoryOrNull = null; //odstraní sql kecy
    await _database.rawQuery(
        '''INSERT INTO AppNutrients values(Null,'${this.newFoodNameOfFood}',${this.newFoodKcal},${this.newFoodProtein},${this.newFoodCarbs},${this.newFoodFat},${this.newFoodFiber})''');

    resetBoxes();
    notifyListeners();

    deleteNewFoodValues();
  }

  deleteNewFoodValues() {
    this.newFoodNameOfFood = "";
    this.newFoodGrams = 0;
    this.newFoodKcal = 0;
    this.newFoodProtein = 0;
    this.newFoodCarbs = 0;
    this.newFoodFat = 0;
    this.newFoodFiber = 0;
  }

  Future<void> deleteItem(int id, String text) async {
    databaseFactoryOrNull = null;

    await _database.delete('Notes',
        where: 'ID = ? AND CZFOODNAME = ?', whereArgs: [id, text]);

    var updatedData = await _database.query('Notes');
    print(updatedData);
    notifyListeners();
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
