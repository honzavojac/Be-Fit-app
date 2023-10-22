// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/chose_your_split.dart';
import 'split_page.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Exercise recording'),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.moving),
          label: Text(
            'Statistics',
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ],
    ));
  }
}

List<NavigationDestination> generateNavigationDestinations(List<String> data) {
  List<NavigationDestination> destinations = [];

  for (String item in data) {
    destinations.add(
      NavigationDestination(
        selectedIcon: Text(
          item,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        icon: Text(
          item,
        ), // Také zde nastavte ikonu dle vašich požadavků
        label: '', // Použijete položku ze seznamu jako popisek
      ),
    );
  }

  return destinations;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                choseYourSplit(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SplitPage()),
                      );
                    },
                    child: SizedBox(
                      width: 85,
                      height: 20,
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Edit split',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                //color: Colors.blue,
                // padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    //  border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          //reverse: true,
                          itemCount: exerciseIndex.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: InkWell(
                                    child: Icon(Icons.more_vert, size: 35),
                                    onTap: () {},
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),

                                      elevation: MaterialStateProperty.all(
                                          0), // Zvýraznění tlačítka
                                    ),
                                    child: Icon(
                                      Icons.add_circle_outline_sharp,
                                      color: Colors.white,
                                      size: 40, // Velikost ikony
                                    ),
                                  ),
                                  title: Text('${exerciseIndex[index]}'),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 0.15,
                                  color: Colors.amber[800],
                                )
                              ],
                            );
                          }),
                    )
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
                        exerciseIndex
                            .add('Exercise ${exerciseIndex.length + 1}');
                        print(exerciseIndex);
                      });
                      // Po přidání položky posuňte pohled dolů
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: Icon(Icons.add, size: 30),
                    label: Text('Add',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber[800]),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.black) // Nastavení barvy zde
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
