// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database_structure/database.dart';

class ExerciseAppBar extends StatelessWidget {
  const ExerciseAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Exercise'),
    );
  }
}

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen();
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final DatabaseAllFood databaseHelper = DatabaseAllFood();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Po stisknutí tlačítka provede následující operace:

              // Získání přístupu k databázi
              Database db = await databaseHelper.getDB();

              // Příklad: Přidání psa do databáze
              Dog newDog = Dog(id: 5, name: 'Buddy');
              int insertedDogId = await databaseHelper.insertDog(newDog);

              // Příklad: Získání seznamu všech psů z databáze
              List<Dog> allDogs = await databaseHelper.getAllDogs();
              for (var dog in allDogs) {
                print('Dog: ${dog.id}, ${dog.name}');
              }

              // Další operace s databází zde

              // Uzavření databáze po použití
              await db.close();
            },
            child: Text('Provést operace s databází'),
          ),
        ],
      ),
    );
  }
}
