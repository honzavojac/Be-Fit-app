// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'food_record_page.dart';
import 'fitness_record_page.dart';
import 'settings_page.dart';
import 'food_add_page.dart';

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
  const FoodAddScreen(),
];

final List<Widget> _appBars = [
  const SettingsAppBar(),
  const FitnessRecordAppBar(),
  const HomeAppBar(),
  const FoodAddAppBar(),
];

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 2;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 2);

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer(); // Close the drawer
      }
      controller
          .jumpToPage(index); // Update PageView when a drawer item is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            onDestinationSelected: (index) {
              _selectedIndex = index;
              controller.jumpToPage(_selectedIndex);
              setState(() {});
              //debugPrint('$_selectedIndex');
            },
            indicatorColor: Colors.amber[800],
            selectedIndex: _selectedIndex,
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
        ));
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
 