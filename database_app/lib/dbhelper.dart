import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tododatabase.db');

  if (await databaseExists(path)) {
    // Databáze existuje -- otevře databázi
    return openDatabase(path);
  } else {
    // Databáze neexistuje -- udělá se kopie z assetu
    try {
      //vytvoření adresáře s cestou -- pokud existuje tak nemá efekt
      //recursive: true --vytvoření všech nadřazených adresářů
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}
    //načte databázi
    final data = await rootBundle.load('assets/tododatabase.db');
    //převede data z assetové databáze na bity
    final bytes = data.buffer.asUint8List();
    //zapíše bity -- flush: true - až po dokončení operace
    await File(path).writeAsBytes(bytes, flush: true);
// Otevře zkopírovanou databázi
    return openDatabase(path);
  }
}

late Database database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await (getDatabase());
}

//-------------------------------------------------------rozebrat podrobněji
// definování funkce pro insertování dat do databáze
Future<void> insertDbRow(DbRow dbrow) async {
  // získání reference na databázi
  final db = await database;

  // Insert the DbRow into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dbrow is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'ToDoData', //tabulka databáze
    dbrow.toMap(), //řádek co se má insertovat
    //když insertuje řádek se stejným primarním klíčem, tak se vymění
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//metoda pro načtení všech záznamů/dat z tabulky 'ToDoData' z databáze
Future<List<DbRow>> ToDoData() async {
  // získání reference na databázi
  final db = await database;

  // dotaz na tabulku 'ToDoData' -- načtení všech záznamů tabulky
  final List<Map<String, dynamic>> maps = await db.query('ToDoData');

  // převede seznam záznamů na seznam objektů do DbRow s hodnotami z databáze
  return List.generate(maps.length, (i) {
    return DbRow(
      id: maps[i]['id'] as int,
      task: maps[i]['task'] as String,
      info: maps[i]['info'] as String,
    );
  });
}

// aktualizace záznamů v tabulce 'ToDoData'
Future<void> updateDbRow(DbRow dbrow) async {
  // získání reference na databázi
  final db = await database;

  // aktualizace záznamů v tabulce 'ToDoData'
  await db.update(
    'ToDoData', //název tabulky
    // předávání nové hodnoty které se uloží do mapy v objektu dbrow
    dbrow.toMap(),
    //vyhledání záznam s hodnotou id
    where: 'id = ?',
// Pass the DbRow's id as a whereArg to prevent SQL injection.
    // zajišťuje bezpečnost vkládání SQL
    whereArgs: [dbrow.id],
  );
}

// funkce pro odstranění jednoho záznamu z tabulky 'ToDoData'
Future<void> deleteDbRow(int id) async {
  // získání reference na databázi
  final db = await database;

  // odstranění záznamu z tabulky 'ToDoData'
  await db.delete(
    'ToDoData',
    // vyhledání záznamu s hodnotou id
    where: 'id = ?',
    // Pass the DbRow's id as a whereArg to prevent SQL injection.
    // zajišťuje bezpečnost vkládání SQL
    whereArgs: [id],
  );
}

// reprezentace záznamů v DB a převod na formát mapy
class DbRow {
  // sloupce pro práci s databází
  final int id;
  final String task;
  final String info;

// kounstruktory DbRow -- vytvoření nové instance třídy
// required -- nutno poskytnout hodnoty pro atributy (id,task,info)
  const DbRow({
    required this.id,
    required this.task,
    required this.info,
  });

  // metoda pro 'toMap()' konvertování hodnot třídy na mapu kde
  Map<String, dynamic> toMap() {
    // pro uložení dat v DB -- data ve formě kterou databáze rozumí v podobě mapy s klíčema (názvy sloupců v 'ToDoData')
    return {
      //'klíč':hodnota
      'id': id,
      'task': task,
      'info': info,
    };
  }

  // přepsání metody 'toString' z objektu
  @override
  // při print() nebo ladění vrátí řetězec s hodnotami
  String toString() {
    return 'DbRow{id: $id, task: $task, info: $info}';
  }
}
