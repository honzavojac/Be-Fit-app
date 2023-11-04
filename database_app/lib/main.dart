import 'package:database_app/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database App'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  insertDbRows();
                  printDatabaseContents();
                  deleteDbRow(1);
                },
                child: Text('insert'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<List<DbRow>>(
                future: AllDbRows(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final AllDbRowsList = snapshot.data;

                    if (AllDbRowsList != null) {
                      return ListView.builder(
                        itemCount: AllDbRowsList.length,
                        itemBuilder: (context, index) {
                          final dog = AllDbRowsList[index];
                          return ListTile(
                            title: Text(dog.task),
                            subtitle: Text(dog.info),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Databáze je prázdná.'),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('Chyba při čtení databáze: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> printDatabaseContents() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> data = await db.query('ToDoData');
  print(data);
}

Future<void> insertDbRows() async {
  final db = await getDatabase();
  final batch = db.batch();

  batch.insert('ToDoData', DbRow(task: 'Fido', info: '35').toMap());
  batch.insert('ToDoData', DbRow(task: 'Buddy', info: '42').toMap());
  batch.insert('ToDoData', DbRow(task: 'Max', info: '29').toMap());

  await batch.commit();
}

Future<List<DbRow>> AllDbRows() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> maps = await db.query('ToDoData');
  return List.generate(maps.length, (i) {
    return DbRow(
      id: maps[i]['id'] as int,
      task: maps[i]['task'] as String,
      info: maps[i]['info'] as String,
    );
  });
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
    return {
      'task': task,
      'info': info,
    };
  }
}
