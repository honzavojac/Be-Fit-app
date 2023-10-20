// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/foodAdd/change_weight.dart';
import 'package:kaloricke_tabulky_02/foodAdd/food_main_add_boxes.dart';
import 'package:kaloricke_tabulky_02/foodAdd/food_secondary_add_boxes.dart';
import 'package:provider/provider.dart';

import '../globals_variables/nutri_data.dart';

class FoodNewAppbar extends StatelessWidget {
  const FoodNewAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Přidání potraviny'),
    );
  }
}

class FoodNewScreen extends StatefulWidget {
  const FoodNewScreen({super.key});

  @override
  State<FoodNewScreen> createState() => _FoodNewScreenState();
}

const List<String> selectedWeight = <String>[
  'g',
  '100g',
];
String selected = 'g';

class _FoodNewScreenState extends State<FoodNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            foodMainAddBoxes(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text('Secondary', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            foodSecondaryAddBoxes(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 15,
              child: Column(
                children: [
                  Container(
                    //color: Colors.blue,
                    height: 40,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add, size: 30),
                      label: Text('Add',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber[800]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
