import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dog {
  final int id;
  final String name;

  Dog({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseAllFood {
  Future<Database> getDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'foodDatabase.db');

    // Otevření existující databáze
    return await openDatabase(path);
  }

  // Přidání psa do databáze
  Future<int> insertDog(Dog dog) async {
    final db = await getDB();
    return await db.insert('dogs', dog.toMap());
  }

  // Získání seznamu všech psů z databáze
  Future<List<Dog>> getAllDogs() async {
    final db = await getDB();
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  // Aktualizace informací o psovi v databázi
  Future<int> updateDog(Dog dog) async {
    final db = await getDB();
    return await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  // Smazání psa z databáze
  Future<int> deleteDog(int id) async {
    final db = await getDB();
    return await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
}
