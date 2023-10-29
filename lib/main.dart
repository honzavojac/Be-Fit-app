// ignore_for_file: library_private_types_in_public_api
//
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:provider/provider.dart';


import 'pages/foodEntry/food_entry_page.dart';
import 'pages/homePage/home_page.dart';
import 'pages/fitnessRecord/fitness_record_page.dart';
import 'exercises_page.dart';

import 'pages/foodAdd/food_add_page.dart';
import 'globals_variables/nutri_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

final List<Widget> _pages = [
  const SettingsScreen(),
  const FitnessRecordScreen(),
  const HomeScreen(),
  const FoodRecordScreen(),
  const FoodNewScreen(),
];

final List<Widget> _appBars = [
  const SettingsAppBar(),
  const FitnessRecordAppBar(),
  const HomeAppBar(),
  const FoodRecordAppBar(),
  const FoodNewAppbar(),
];

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 2;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 2);

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
                controller.jumpToPage(index);
                setState(() {});
                debugPrint('$_selectedIndex');
              },
              children: _pages,
            ),
            key: scaffoldKey,
            //bottomnavigationbar------------------------
            bottomNavigationBar: NavigationBar(
              height: 70,
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
                    Icons.settings,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
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
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.add_circle_outline_sharp),
                  label: 'New food',
                ),
              ],
            ),
          )),
    );
  }
}

        /*  drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Domovská stránka'),
                leading: const Icon(Icons.home),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                title: const Text('Záznam jídla'),
                leading: const Icon(Icons.fastfood),
                onTap: () {
                  _onItemTapped(1);
                },
              ),
              ListTile(
                title: const Text('Přidání potraviny'),
                leading: const Icon(Icons.add_circle_outline_sharp),
                onTap: () {
                  _onItemTapped(2);
                },
              ),
              ListTile(
                title: const Text('Záznam tréninku'),
                leading: const Icon(Icons.fitness_center),
                onTap: () {
                  _onItemTapped(3);
                },
              ),
              ListTile(
                title: const Text('Nastavení'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  _onItemTapped(4);
                },
              ),
            ],
          ),
        ),*/
 