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
        "CREATE TABLE Notes(ID INTEGER PRIMARY KEY AUTOINCREMENT, CZFOODNAME TEXT NOT NULL, ENERGYKCAL INTEGER)",
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
      print("\nVytváření databáze");
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

    return assetsPath; // Vracíme cestu k assets databázi (typu String)
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Note>> Notes() async {
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('''SELECT ID,CZFOODNAME,ENERGYKCAL FROM Notes''');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
        kcal: maps[i]['ENERGYKCAL'] as int,
        // description: maps[i]['description'] as String,
      );
    });
  }

  Future<List<Map<String, Object?>>> a() async {
    var joinResult =
        await _database.rawQuery('''SELECT CZFOODNAME FROM Notes''');
    print("vše------------$joinResult");

    // List<int> cisla = joinResult.map((data) => data['id'] as int).toList();
    // List<String> description =
    //     joinResult.map((data) => data['CZFOODNAME'] as String).toList();
    // // Opravené zakomentované řádky
    // print(cisla);
    // print(description);
    return joinResult;
  }

  Future<List<String>> getCzFoodNames() async {
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('''SELECT CZFOODNAME FROM NutriDatabase''');

    return List.generate(maps.length, (i) {
      return maps[i]['CZFOODNAME'].toString();
    });
  }

  Future<List<String>> getNotes() async {
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('''SELECT ID,CZFOODNAME,ENERGYKCAL FROM NutriDatabase''');

    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['ID'] as int,
        czfoodname: maps[i]['CZFOODNAME'] as String,
        kcal: maps[i]['ENERGYKCAL'] as int,
      ).toString();
    });
  }

  insertItem(String text,int kcal) async {
    databaseFactoryOrNull = null; //odstraní sql kecy
    await _database.rawQuery('''INSERT INTO Notes  values(Null,'$text',$kcal)''');
    print(_database.rawQuery('''select * from Notes'''));
    notifyListeners();
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

  where(Function(dynamic food) param0) {}
}

class Note {
  final int id;
  final String czfoodname;
  final int kcal;
  // final String description;

  Note({this.id = 1, this.czfoodname = 'CZFOODNAME',  this.kcal=1});

  Note.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        czfoodname = item["CZFOODNAME"],
        kcal = item["ENERGYKCAL"]
  // description = item["description"];
  ;
  Map<String, Object> toMap() {
    return {'id': id, 'CZFOODNAME': czfoodname,'ENERGYKCAL': kcal};
  }

  @override
  String toString() {
    return 'Dog{id: $id, CZFOODNAME: $czfoodname, ENERGYKCAL: $kcal}';
  }
}
