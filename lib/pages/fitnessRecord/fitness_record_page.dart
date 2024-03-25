// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/exercise_page.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/statistics_page.dart';
import 'package:kaloricke_tabulky_02/variables_provider.dart';
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
  String? selectedSplit;
  int initializedSplit = 0;

  @override
  void didChangeDependencies() {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: true);
    if (dbFirebase.readyState == 0) {
      setState(() {
        dbFirebase.readyState = 1;
      });
    }

    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: false);

    //získání splitů do proměnné v provideru
    await dbFirebase.getSplits();

    // Nastavte výchozí hodnotu na první split, pokud není seznam prázdný
    if (dbFirebase.listSplits.isNotEmpty && initializedSplit == 0) {
      selectedSplit = dbFirebase.listSplits[0]["name"];
      dbFirebase.splitName = dbFirebase.listSplits[0]["name"];
      initializedSplit = 1;
    } else if (dbFirebase.listSplits.isNotEmpty) {
      //nothing - data is in list
    } else {
      selectedSplit = " ";
      dbFirebase.splitName = " ";
    }

    //získání svalů ze splitu do proměnné v provideru

    // await dbFirebase.getTrueSplitExercise(selectedSplit!);

    //získání cviků ze svalu se bude provádět při chodu listview.builderu -- zatím nevím
    await dbFirebase.getCurrentSplitExercises(dbFirebase.splitName ?? dbFirebase.mapSplits[0]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);
    var variablesProvider = Provider.of<VariablesProvider>(context);

    if (dbFirebase.listSplits.isEmpty == true && dbFirebase.listSplits == " ") {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Container(
                      height: 40,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedSplit,
                          items: dbFirebase.listSplits.map<DropdownMenuItem<String>>((split) {
                            return DropdownMenuItem<String>(
                              value: split["name"],
                              child: Center(
                                child: Text(
                                  split["name"].toString().toUpperCase(),
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
                          onChanged: (value) {
                            setState(() {
                              selectedSplit = value!; // Aktualizace vybraného splitu
                              dbFirebase.splitName = value;
                              dbFirebase.getTrueSplitExercise(value);
                              setState(() {});
                              loadData();
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            width: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: variablesProvider.zaobleni,
                              border: Border.all(
                                color: ColorsProvider.color_2,
                                width: 0.5,
                              ),
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            iconSize: 17,
                            iconEnabledColor: ColorsProvider.color_1,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: variablesProvider.zaobleni,
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
        ],
      );
    } else {
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Container(
                          // width: 150,
                          height: 40,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              value: selectedSplit,
                              items: dbFirebase.listSplits.map<DropdownMenuItem<String>>((split) {
                                return DropdownMenuItem<String>(
                                  value: split["name"],
                                  child: Center(
                                    child: Text(
                                      split["name"].toString().toUpperCase(),
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
                              onChanged: (value) {
                                setState(() {
                                  selectedSplit = value!; // Aktualizace vybraného splitu
                                  dbFirebase.splitName = value;
                                  dbFirebase.getTrueSplitExercise(value);
                                  setState(() {});
                                  loadData();
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                width: 180,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  borderRadius: variablesProvider.zaobleni,
                                  border: Border.all(
                                    color: ColorsProvider.color_2,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                iconSize: 17,
                                iconEnabledColor: ColorsProvider.color_1,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                decoration: BoxDecoration(
                                  borderRadius: variablesProvider.zaobleni,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                    borderRadius: variablesProvider.zaobleni,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: dbFirebase.mapFinalExercises[selectedSplit]?.length ?? 0,
                          itemBuilder: (context, muscleIndex) {
                            String muscle = dbFirebase.mapFinalExercises[selectedSplit].keys.toList()[muscleIndex];

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: ColorsProvider.color_2,
                                      borderRadius: variablesProvider.zaobleni,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "$muscle",
                                        style: TextStyle(
                                          color: ColorsProvider.color_8,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 25, right: 25),
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: dbFirebase.mapFinalExercises[dbFirebase.splitName][muscle]?.length ?? 0,
                                      itemBuilder: (context, exerciseIndex) {
                                        String exercise = dbFirebase.mapFinalExercises[dbFirebase.splitName][muscle][exerciseIndex];

                                        return GestureDetector(
                                          onTap: () async {
                                            dbFirebase.selectedMuscle = muscle;
                                            dbFirebase.chosedExercise = exercise;

                                            await dbFirebase.LoadExerciseData(dbFirebase.splitName, "${dbFirebase.selectedMuscle}", "${dbFirebase.chosedExercise}");
                                            //zakázání synchronizace s firebase
                                            dbFirebase.disableSync();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ExercisePage(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: ColorsProvider.color_2,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "$exercise",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                                                      child: Container(
                                                        decoration: BoxDecoration(color: Color.fromARGB(111, 0, 0, 0), borderRadius: variablesProvider.zaobleni),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                              child: Container(
                                                                width: 60,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    Text("Set"),
                                                                    Text("Weight"),
                                                                    Text("Reps"),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 1,
                                                              color: Colors.black,
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                child: Container(
                                                                  child: ListView.builder(
                                                                    itemCount: dbFirebase.exerciseData[muscle]?[exercise]?.length ?? 0,
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemBuilder: (context, index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                        child: Container(
                                                                          width: 60,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text("${index + 1}"),
                                                                              Text("${dbFirebase.exerciseData[muscle][exercise]["set ${index + 1}"]["weight"]}"),
                                                                              Text("${dbFirebase.exerciseData[muscle][exercise]["set ${index + 1}"]["reps"]}"),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        print(dbFirebase.exerciseData);
                      },
                      icon: Icon(Icons.add, size: 30),
                      label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2),
                          foregroundColor: MaterialStateProperty.all(
                            ColorsProvider.color_8,
                          ) // Nastavení barvy zde
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
}
