// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';

import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_main_add_boxes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_secondary_add_boxes.dart';
import 'package:provider/provider.dart';

import 'vitamins_box.dart';

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
    var dbHelper = Provider.of<DBHelper>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add new food'),
            IconButton(
              //zavolání funkce v widgetech pro odstranění hodnot z boxů
              onPressed: () {
                dbHelper.resetBoxes();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: ListView(
              children: [
                foodMainAddBoxes(),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Others values',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                foodSecondaryAddBoxes(),
                SizedBox(
                  height: 15,
                ),
                VitaminsBox(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
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
                        onPressed: () {
                          //přidání hodnot do databáze
                          dbHelper.insertNewFood();
                        },
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
          ),
        ],
      ),
    );
  }
}
