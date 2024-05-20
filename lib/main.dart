// ignore_for_file: library_private_types_in_public_api
//

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/login/check_page.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/variables_provider.dart';

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

  //inicializace supabase
  SupabaseProvider dbSupabase = SupabaseProvider();
  await dbSupabase.initialize();

  await dbHelper.initializeDB();
  FirestoreService dbFirebase = FirestoreService();
  ColorsProvider colorsProvider = ColorsProvider();
  VariablesProvider variablesProvider = VariablesProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: dbHelper,
        ),
        ChangeNotifierProvider.value(
          value: dbFirebase,
        ),
        ChangeNotifierProvider.value(
          value: dbSupabase,
        ),
        ChangeNotifierProvider.value(
          value: colorsProvider,
        ),
        ChangeNotifierProvider.value(value: variablesProvider),
      ],
      child: MyApp(),
      // child: Container(),
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
