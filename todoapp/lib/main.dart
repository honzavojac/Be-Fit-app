import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todoapp/db_helper.dart';

late DbController databaseInstance;

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  databaseInstance = DbController();
  await databaseInstance.initDatabase();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller_name = TextEditingController();
    TextEditingController _controller_age = TextEditingController();

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('TO DO APP'),
            backgroundColor: Colors.amber,
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    color: const Color.fromARGB(72, 0, 0, 0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            controller: _controller_name,
                            decoration: InputDecoration(
                              labelText: 'NAME',
                              labelStyle: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            controller: _controller_age,
                            decoration: InputDecoration(
                              labelText: 'AGE',
                              labelStyle: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        List<Dog> dogs = await databaseInstance.getDogs();
                        for (Dog dog in dogs) {
                          debugPrint(
                              "ID: ${dog.id}, name: ${dog.name}, age: ${dog.age}");
                        }
                      },
                      child: Text('data'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(_controller_age.text);
                      },
                      child: Text('data'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // insertDog();
                        databaseInstance.insertDog(
                          Dog(
                            name: _controller_name.text,
                            age: _controller_age.text,
                          ),
                        );
                      },
                      child: Text('data'),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}
