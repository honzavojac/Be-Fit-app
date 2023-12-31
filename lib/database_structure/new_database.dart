import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });
}

OpenDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "dbName.db");
  print(databasesPath);
// Make sure the directory exists
  try {
    await Directory(databasesPath).create(recursive: true);
  } catch (_) {}
}

void main(List<String> args) {
  
}
