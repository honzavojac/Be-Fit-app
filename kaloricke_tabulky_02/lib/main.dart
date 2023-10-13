// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'food_record_page.dart';
import 'fitness_record_page.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _pages = [
    const HomeScreen(),
    const FoodRecordScreen(),
    const FitnessRecordScreen(),
    const SettingsScreen(),
  ];

  static final List<Widget> _appBars = [
    const HomeAppBar(),
    const FoodRecordAppBar(),
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
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56), // 56 is the default height
          child: _appBars[_selectedIndex],
        ),
        body: _pages[_selectedIndex],
        key: scaffoldKey,
        drawer: Drawer(
          // backgroundColor: Colors.blue,
          child: ListView(
            children: [
              ListTile(
                title: Text('Domovská stránka'),
                leading: Icon(Icons.home),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                title: Text('Záznam jídla'),
                leading: Icon(Icons.fastfood),
                onTap: () {
                  _onItemTapped(
                      1); // Zavolat metodu s indexem 0 při klepnutí na položku
                },
              ),
              ListTile(
                title: Text('Záznam tréninku'),
                leading: Icon(Icons.fitness_center),
                onTap: () {
                  _onItemTapped(
                      2); // Zavolat metodu s indexem 0 při klepnutí na položku
                },
              ),
              ListTile(
                title: Text('Nastavení'),
                leading: Icon(Icons.settings),
                onTap: () {
                  _onItemTapped(
                      3); // Zavolat metodu s indexem 0 při k  //Navigator.pop(context); // Zavřít menu
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