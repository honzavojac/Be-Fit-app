// ignore_for_file: library_private_types_in_public_api
//

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/login/check_page.dart';

import 'package:kaloricke_tabulky_02/page_provider.dart';
import 'package:provider/provider.dart';

import 'database/database_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

// late DbController databaseInstance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper dbHelper = DBHelper();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirestoreService dbFirebase = FirestoreService();
  // dbFirebase.addUser("David","david@gmail.com");
  // dbFirebase.getUsers();
  // dbFirebase.getUser();
  // dbFirebase.updateUser("Marek", "ondra@gmail.com");

  

  await dbHelper.initializeDB();
  PageProvider pageProvider = PageProvider();
  ColorsProvider colorsProvider = ColorsProvider();
  // print(dbHelper.initialIndex);
  // print(dbHelper.tab);

  // if (Platform.isWindows || Platform.isLinux) {
  //   sqfliteFfiInit();
  // }
  // databaseFactory = databaseFactoryFfi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: dbHelper,
        ),
        ChangeNotifierProvider.value(value: pageProvider),
        ChangeNotifierProvider.value(
          value: colorsProvider,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckPage(),
    );
  }
}
