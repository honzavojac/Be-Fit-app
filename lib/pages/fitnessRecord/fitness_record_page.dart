// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/exercise_page.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/statistics_page.dart';
import 'package:provider/provider.dart';

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
  List<Map<String, dynamic>> listSplits = [];
  List<Map<String, dynamic>> listFinalExercises = [];
  List<Map<String, dynamic>> listSplitMuscles = [];
  String? selectedSplit;
  int initializedSplit = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: false);

    listSplits = await dbFirebase.getSplits();

    // Nastavte výchozí hodnotu na první sval, pokud není seznam prázdný
    if (listSplits.isNotEmpty && initializedSplit == 0) {
      selectedSplit = listSplits[0]["name"];
      dbFirebase.splitName = listSplits[0]["name"];
      initializedSplit = 1;
    } else if (listSplits.isNotEmpty) {
    } else {
      selectedSplit = " ";
      dbFirebase.splitName = " ";
    }
    listSplitMuscles = await dbFirebase.getSplitMuscles(selectedSplit!);
    print("list split muscles ${listSplitMuscles}");
    listFinalExercises = await dbFirebase.getCurrentSplitExercises();
    print("list final exercises ${listFinalExercises}");

    //vložení hodnot do provideru
    dbFirebase.listSplits = listSplits;
    dbFirebase.listFinalExercises = listFinalExercises;
    dbFirebase.listSplitMuscles = listSplitMuscles;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Container(
                        // width: 150,
                        height: 40,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: listSplits.map<DropdownMenuItem<String>>((Map<String, dynamic> muscle) {
                              // print(dbFirebase.chosedMuscle);
                              return DropdownMenuItem<String>(
                                value: muscle["name"],
                                child: Center(
                                  child: Text(
                                    muscle["name"].toString().toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsProvider.color_1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: selectedSplit,
                            onChanged: (value) {
                              selectedSplit = value!; // Aktualizace vybraného splitu
                              dbFirebase.splitName = value;
                              print("chosed split: ${dbFirebase.splitName.toString().toUpperCase()}");
                              loadData();
                              print(listSplitMuscles);
                              // setState(() {});
                            },
                            buttonStyleData: ButtonStyleData(
                              // height: 80,
                              width: 180,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: ColorsProvider.color_2,
                                  width: 0.5,
                                ),
                              ),
                              // elevation: 2,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                              ),
                              iconSize: 17,
                              iconEnabledColor: ColorsProvider.color_1,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              // width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(width: 2, color: ColorsProvider.color_2),
                              ),
                              offset: const Offset(0, -0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility: MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 0, right: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                  color: Color.fromARGB(146, 184, 1, 1),
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listSplitMuscles.length,
                        itemBuilder: (context, muscleIndex) {
                          // nacteni(index);
                          List<String> finalList = [];
                          for (var i = 0; i < listFinalExercises.length; i++) {
                            if (listFinalExercises[i]["muscle"] == listSplitMuscles[muscleIndex]["name"]) {
                              finalList.add(listFinalExercises[i]["exercise"]);
                            }
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                child: Container(
                                  height: 50,
                                  color: ColorsProvider.color_2,
                                  child: Center(
                                    child: Text(
                                      "${listSplitMuscles[muscleIndex]["name"].toString().toUpperCase()}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25, right: 25),
                                child: Container(
                                  // color: Colors.black,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: finalList.length,
                                    itemBuilder: (context, exerciseIndex) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: Container(
                                            height: 80,
                                            color: ColorsProvider.color_1,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${finalList[exerciseIndex]}",
                                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.teal,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              // width: 60,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    // height: 20,
                                                                    width: 50,
                                                                    color: Colors.red,
                                                                    child: Text("Weight:"),
                                                                  ),
                                                                  Container(
                                                                    // height: 20,
                                                                    width: 50,
                                                                    color: Colors.red,
                                                                    child: Text("Reps:"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              // height: 50,
                                                              // width: 100,
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount: 5,
                                                                scrollDirection: Axis.horizontal,
                                                                itemBuilder: (context, index) {
                                                                  return Container(
                                                                    // height: 40,
                                                                    width: 40,
                                                                    color: Colors.black26,
                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                    child: Column(
                                                                      children: [
                                                                        Text("set ${index + 1}"),
                                                                        Text("15"),
                                                                        Text("15"),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons.edit),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          dbFirebase.disableSync();

                                          dbFirebase.chosedExercise = finalList[exerciseIndex];
                                          dbFirebase.selectedMuscle = listSplitMuscles[muscleIndex]["name"];
                                          print(dbFirebase.selectedMuscle);
                                          print(finalList[exerciseIndex]);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ExercisePage(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
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
