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
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
          appBar: AppBar(
            title: Text('TO DO APP', style: TextStyle(color: Colors.amber)),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
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
                height: 200,
                // color: Colors.white,
                child: Column(
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
                      child: Text('database view'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        debugPrint(_controller_age.text);
                      },
                      child: Text('recount database id'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        databaseInstance.insertDog(
                          Dog(
                            name: _controller_name.text,
                            age: _controller_age.text,
                          ),
                        );
                      },
                      child: Text('insert'),
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
