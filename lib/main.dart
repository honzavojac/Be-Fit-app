import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/login_supabase/auth_page.dart';
import 'package:kaloricke_tabulky_02/settings.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/edit_delete_exercise_data.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_names.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_statistic.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/add_food.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/food_statistic.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/new_food.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/scan_food.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:kaloricke_tabulky_02/login_firebase%20copy/firebase_options.dart';

import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/login_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FitnessProvider dbFitness = FitnessProvider();
  await dbFitness.initializeDB();
  // await dbFitness.deleteFile("fitnessDatabase.db");
  // dbFitness.DeleteMuscle(1);
  // dbFitness.SelectMuscles();
  // dbFitness.UpdateMuscle("Triceps", 1);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SupabaseProvider dbSupabase = SupabaseProvider();
  await dbSupabase.initialize();
  dbSupabase.getUser();
  dbSupabase.initFoodApi();

  DBHelper dbHelper = DBHelper();
  await dbHelper.initializeDB();

  FirestoreService dbFirebase = FirestoreService();
  ColorsProvider colorsProvider = ColorsProvider();
  VariablesProvider variablesProvider = VariablesProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: dbHelper),
        ChangeNotifierProvider.value(value: dbFirebase),
        ChangeNotifierProvider.value(value: dbSupabase),
        ChangeNotifierProvider.value(value: dbFitness),
        ChangeNotifierProvider.value(value: colorsProvider),
        ChangeNotifierProvider.value(value: variablesProvider),
      ],
      child: MyApp(),
    ),
  );
}

var supabase = Supabase.instance.client;

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
      theme: ThemeData.dark(useMaterial3: true),
      home: SplashPage(),
      initialRoute: '/',
      routes: {
        '/account': (context) => InitPage(),
        '/login': (context) => LoginPage(),
        '/splash': (context) => SplashPage(),
        '/settings': (context) => Settings(),
        '/auth': (context) => AuthPage(),
        '/fitnessNames': (context) => FitnessNames(),
        '/editDeleteExerciseData': (context) => EditDeleteExerciseData(),
        '/fitnessStatistic': (context) => FitnessStatistic(),
        '/scanFood': (context) => ScanFood(),
        '/addFood': (context) => AddFood(),
        '/newFood': (context) => NewFood(),
        '/foodStatistic': (context) => foodStatistic(),
      },
    );
  }
}
