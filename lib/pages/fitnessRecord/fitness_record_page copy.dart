// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/statistics_page.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/chose_your_split.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';

import 'split_page.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Exercise recording '),
          Container(
            height: 37,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsScreen(),
                  ),
                );
              },
              icon: Icon(Icons.moving),
              label: Text(
                'Statistics',
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(ColorsProvider.color_1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FitnessRecordScreen extends StatefulWidget {
  const FitnessRecordScreen({super.key});

  @override
  State<FitnessRecordScreen> createState() => _FitnessRecordScreenState();
}

ScrollController _scrollController = ScrollController();

class _FitnessRecordScreenState extends State<FitnessRecordScreen> {
  List<String> exerciseIndex = [];

  //final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    // List<NavigationDestination> destinations =

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: choseYourSplit(),
                  ),
                  Container(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplitPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_outlined),
                      label: Text(
                        'Edit split',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2),
                        foregroundColor: MaterialStateProperty.all(ColorsProvider.color_8),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: ColorsProvider.color_7,
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorsProvider.color_2),
                            height: 80,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Bicepsový zdvih s činkami",
                                              style: TextStyle(fontSize: 18, color: ColorsProvider.color_8, fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: ColorsProvider.color_8, width: 2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 45,
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Set:",
                                                      style: TextStyle(
                                                        color: ColorsProvider.color_8,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Reps:",
                                                      style: TextStyle(
                                                        color: ColorsProvider.color_8,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: 5,
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        width: 35,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${index + 1}",
                                                              style: TextStyle(
                                                                color: ColorsProvider.color_8,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "12",
                                                              style: TextStyle(
                                                                color: ColorsProvider.color_8,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  // color: Colors.red,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit, color: ColorsProvider.color_8),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //color: Colors.blue,
                  height: 40,
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        exerciseIndex.add('Exercise ${exerciseIndex.length + 1}');
                        // print(exerciseIndex);
                      });
                      // Po přidání položky posuňte pohled dolů
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: Icon(Icons.add, size: 30),
                    label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2), foregroundColor: MaterialStateProperty.all(ColorsProvider.color_8) // Nastavení barvy zde
                        ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
