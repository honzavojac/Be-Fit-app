// ignore_for_file: library_private_types_in_public_api
//

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:provider/provider.dart';

import 'database/database_provider.dart';
import 'pages/foodAdd/food_entry_page.dart';
import 'pages/homePage/home_page.dart';
import 'pages/fitnessRecord/fitness_record_page.dart';

import 'globals_variables/nutri_data.dart';

// late DbController databaseInstance;
void main() async {
  print('object');
  DBHelper dbHelper = DBHelper();
  await dbHelper.initializeDB();
  // await dbHelper.deleteFile('database.db');

  // print(await dbHelper.getNotes());
  // dbHelper.deleteFile("foodDatabase.db");
  // await dbHelper.initializeDB();
  // // await dbHelper.insertItem("text");
  // // print(await dbHelper.assetsDB());
  // await dbHelper.a();

  // if (Platform.isWindows || Platform.isLinux) {
  //   sqfliteFfiInit();
  // }
  // databaseFactory = databaseFactoryFfi;

  runApp(
    ChangeNotifierProvider.value(
      value: dbHelper,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

final List<Widget> _pages = [
  const FitnessRecordScreen(),
  const HomeScreen(),
  const FoodRecordScreen(),
];

final List<Widget> _appBars = [
  const FitnessRecordAppBar(),
  const HomeAppBar(),
  const FoodRecordAppBar(),
];

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NutritionIncremment>(
          create: (_) => NutritionIncremment(),
        ),
        ChangeNotifierProvider<fitnessGlobalVariables>(
          create: (_) => fitnessGlobalVariables(),
        ),
        // ChangeNotifierProvider<DBHelper>(
        //   create: (_) => DBHelper(),
        // ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(useMaterial3: true),
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: _appBars[_selectedIndex],
            ),
            body: PageView(
              controller: controller,
              onPageChanged: (index) {
                _selectedIndex = index;
                setState(() {});
                debugPrint('$_selectedIndex');
              },
              children: _pages,
            ),
            key: scaffoldKey,
            //bottomnavigationbar------------------------
            bottomNavigationBar: NavigationBar(
              height: 65,
              onDestinationSelected: (index) {
                //controller;
                _selectedIndex = index;
                controller.jumpToPage(_selectedIndex);
                setState(() {});
                //debugPrint('$_selectedIndex');
              },
              indicatorColor: Colors.amber[800],
              selectedIndex: _selectedIndex,
              animationDuration: Duration(milliseconds: 1000),
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.fitness_center_rounded),
                  label: 'Fitness',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.fastfood_rounded,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.fastfood),
                  label: 'Add food',
                ),
              ],
            ),
          )),
    );
  }
}
