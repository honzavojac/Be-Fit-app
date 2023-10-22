// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:kaloricke_tabulky_02/pages/foodAdd/food_main_add_boxes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_secondary_add_boxes.dart';

class FoodNewAppbar extends StatelessWidget {
  const FoodNewAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Add new food'),
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
bool isChecked = false;

class _FoodNewScreenState extends State<FoodNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('A', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B1', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B2', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B3', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('B4', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B5', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B6', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B7', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('B9', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('B12', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('C', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('D', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('E', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('K', style: TextStyle(fontSize: 20)),
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0))), // Rounded Checkbox
                              value: isChecked,
                              onChanged: (inputValue) {
                                setState(() {
                                  isChecked = inputValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
        ),
      ],
    );
  }
}
