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

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _pages = [
    const HomeScreen(),
    const FoodRecordScreen(),
    const FoodAddcreen(),
    const FitnessRecordScreen(),
    const SettingsScreen(),
  ];

  static final List<Widget> _appBars = [
    const HomeAppBar(),
    const FoodRecordAppBar(),
    const FoodAddAppBar(),
    const FitnessRecordAppBar(),
    const SettingsAppBar(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.closeDrawer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), //56 je defaultně
          child: _appBars[_selectedIndex],
        ),
        body: _pages[_selectedIndex],
        key: scaffoldKey,
        drawer: Drawer(
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
                  _onItemTapped(1); // Zavolat metodu s indexem 1
                },
              ),
              ListTile(
                title: const Text('Přidání potraviny'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  _onItemTapped(2); // Zavolat metodu s indexem 2
                },
              ),
              ListTile(
                title: const Text('Záznam tréninku'),
                leading: const Icon(Icons.fitness_center),
                onTap: () {
                  _onItemTapped(
                      3); // Zavolat metodu s indexem 0 při klepnutí na položku
                },
              ),
              ListTile(
                title: const Text('Nastavení'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  _onItemTapped(4); // Zavolat metodu s indexem 0
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Poznámky:
/* final scaffoldKey = GlobalKey<ScaffoldState>();

Scaffold(
   key: scaffoldKey,
   drawer: Drawer(),
)

if(scaffoldKey.currentState!.isDrawerOpen){
    scaffoldKey.currentState!.closeDrawer();
    //close drawer, if drawer is open
}else{
    scaffoldKey.currentState!.openDrawer();
    //open drawer, if drawer is closed
} 
*/
