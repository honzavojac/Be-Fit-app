import 'package:dart_application_database/dart_application_database.dart'
    as dart_application_database;
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main(List<String> arguments) {
  print('Hello world');
  DbHelper dbhelper = DbHelper();
  dbhelper.InitDatabase();
}

class DbHelper {
  InitDatabase() {
    print("object");
  }
}
