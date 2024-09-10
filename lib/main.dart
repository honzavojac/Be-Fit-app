import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/chose_init_data_page.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/login_supabase/auth_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/add_intake_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/settings.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/edit_delete_exercise_data.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_names.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_statistic.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/add_food.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/food_statistic.dart';
import 'package:kaloricke_tabulky_02/side_panel/food/scan_food.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/login_firebase%20copy/firebase_options.dart';

import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/login_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';

import 'login_supabase/reset_password_get_token.dart';
import 'side_panel/body/measurements.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('selected_language_code');
  Locale startLocale;

  if (languageCode != null) {
    startLocale = Locale(languageCode);
  } else {
    startLocale = Locale('en'); // Defaultní jazyk, pokud žádný není uložen
  }

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
  // dbSupabase.initFoodApi();

  // DBHelper dbHelper = DBHelper();
  // await dbHelper.initializeDB();

  FirestoreService dbFirebase = FirestoreService();
  ColorsProvider colorsProvider = ColorsProvider();
  VariablesProvider variablesProvider = VariablesProvider();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: dbHelper),
        ChangeNotifierProvider.value(value: dbFirebase),
        ChangeNotifierProvider.value(value: dbSupabase),
        ChangeNotifierProvider.value(value: dbFitness),
        ChangeNotifierProvider.value(value: colorsProvider),
        ChangeNotifierProvider.value(value: variablesProvider),
      ],
      child: EasyLocalization(
        supportedLocales: locales,
        path: 'assets/langs',
        fallbackLocale: Locale('en'),
        startLocale: startLocale,
        child: MyApp(),
      ),
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
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeModeString = prefs.getString('themeMode');
    setState(() {
      if (themeModeString == 'light') {
        _themeMode = ThemeMode.light;
        darkTheme = false;
      } else if (themeModeString == 'dark') {
        _themeMode = ThemeMode.dark;
        darkTheme = true;
      } else {
        _themeMode = ThemeMode.dark;
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        if (isDarkMode) {
          darkTheme = true;
        } else {
          darkTheme = false;
        }
      }
    });
  }

  notifyMyApp(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = themeMode;
    });
    prefs.setString('themeMode', themeMode.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode, // Použití ThemeMode
      home: SplashPage(),
      initialRoute: '/',
      routes: {
        '/account': (context) => InitPage(),
        '/initData': (context) => ChoseInitDataPage(),
        '/login': (context) => LoginPage(),
        '/resetPassword': (context) => ResetPasswordGetToken(),
        '/splash': (context) => SplashPage(),
        '/settings': (context) => Settings(
              notifyMyApp: notifyMyApp,
            ),
        '/auth': (context) => AuthPage(),
        '/fitnessNames': (context) => FitnessNames(),
        '/editDeleteExerciseData': (context) => EditDeleteExerciseData(),
        '/fitnessStatistic': (context) => FitnessStatistic(),
        '/scanFood': (context) => ScanFood(),
        '/addFood': (context) => AddFood(),
        '/newFood': (context) => FoodAddPage(
              quantity: <String>[
                '1g',
                '100g',
              ],
            ),
        '/foodStatistic': (context) => foodStatistic(),
        '/measurements': (context) => MeasurementsWidget(),
        '/addIntakePage': (context) => AddIntakePage(),
      },
    );
  }
}
