import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DbHelper {
  Future initDb() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "tododatabase.db"); //název databáze

    final exist = await databaseExists(path);

    if (exist) {
      print('cesta k databázi existuje');
      await openDatabase(path);
    } else {
      print('vytváření kopie databáze z assetu dokončeno');

      try {
        await Directory(dirname(path)).create(recursive: true); //vysvětlit
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "tododatabase.db"));
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print('databáze byla zkopírovaná');
    }
    await openDatabase(path);
    
  }
  //další akce s databází
}
