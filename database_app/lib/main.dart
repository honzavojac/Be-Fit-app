import 'package:database_app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
  getDatabase();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Databáze úkolů'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Úkol'),
            ),
            TextField(
              controller: infoController,
              decoration: InputDecoration(labelText: 'Info'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Vytvoření nového záznamu na základě zadaných hodnot
                    final newDbRow = DbRow(
                      task: taskController.text,
                      info: infoController.text,
                    );

                    // Volání funkce pro vložení nového záznamu do databáze
                    insertDbRow(newDbRow);

                    // Vymazání textových polí po vložení
                    //  taskController.clear();
                    //  infoController.clear();
                  },
                  child: Text('Přidat úkol'),
                ),
                ElevatedButton(
                  onPressed: () {
                    printDatabaseContents();
                  },
                  child: Text('zobrazit databázi'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DbRow {
  final int id;
  final String task;
  final String info;

  DbRow({
    this.id = 0,
    required this.task,
    required this.info,
  });
  Map<String, dynamic> toMap() {
    // pro uložení dat v DB -- data ve formě kterou databáze rozumí v podobě mapy s klíčema (názvy sloupců v 'ToDoData')
    return {
      //'klíč':hodnota
      'id': id,
      'task': task,
      'info': info,
    };
  }
}

Future<void> insertDbRow(DbRow dbRow) async {
  final db = database;
  await db.insert('ToDoData', dbRow.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  print(
      'Vložení úkolu do databáze: ID: ${dbRow.id}, Task: ${dbRow.task}, Info: ${dbRow.info}');
}
