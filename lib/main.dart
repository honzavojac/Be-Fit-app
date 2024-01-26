// ignore_for_file: library_private_types_in_public_api
//

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/page_provider.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:provider/provider.dart';

import 'database/database_provider.dart';
import 'pages/foodAdd/food_entry_page.dart';
import 'pages/homePage/home_page.dart';
import 'pages/fitnessRecord/fitness_record_page.dart';

// late DbController databaseInstance;
void main() async {
  DBHelper dbHelper = DBHelper();

  await dbHelper.initializeDB();

  PageProvider pageProvider = PageProvider();
  ColorsProvider colorsProvider = ColorsProvider();
  print(dbHelper.initialIndex);
  print(dbHelper.tab);
  // await dbHelper.InsertHodnoty();
  // await dbHelper.DeleteSplit();
  // await dbHelper.deleteFile('database.db');

// await dbHelper.Autodelete();
  // await dbHelper.Svaly();
  // await dbHelper.Cviky();
  // await dbHelper.Split();
  // await dbHelper.SplitSval();
  // await dbHelper.PrintSvalCvik();

  // await dbHelper.SplitSval();
  // await dbHelper.Cviky();

  // await dbHelper.vlozitHodnoty();

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<fitnessGlobalVariables>(
          create: (_) => fitnessGlobalVariables(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: _appBars[pageProvider.page],
          ),
          body: PageView(
            controller: controller,
            onPageChanged: (index) {
              pageProvider.page = index;
              setState(() {});
            },
            children: _pages,
          ),
          key: scaffoldKey,
          //bottomnavigationbar------------------------
          bottomNavigationBar: NavigationBar(
            height: 65,
            onDestinationSelected: (index) {
              //controller;
              pageProvider.page = index;
              // print(pageProvider.page);
              controller.jumpToPage(pageProvider.page);
              setState(() {});
            },
            indicatorColor: Colors.amber[800],
            selectedIndex: pageProvider.page,
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
        ),
      ),
    );
  }
}
