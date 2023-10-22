import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int _selectedIndex = 0;

class SplitPage extends StatefulWidget {
  const SplitPage();

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your split'),
        ),
        body: Column(
          children: [
            NavigationBar(
              height: 70,
              onDestinationSelected: (index) {
                //controller;
                _selectedIndex = index;
                // controller.jumpToPage(_selectedIndex);
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
              ],
            ),
            Container(
              margin: EdgeInsets.all(40),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  LengthLimitingTextInputFormatter(5),
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                //cursorHeight: 20.0,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  //  border: InputBorder.none,
                  labelText: 'Category 1',
                  labelStyle: TextStyle(color: Colors.amber),
                  // hintText: 'Enter value:',
                  hintStyle: TextStyle(fontSize: 15),
                ),
                onChanged: (input) {},
              ),
            ),
          ],
        ));
  }
}
