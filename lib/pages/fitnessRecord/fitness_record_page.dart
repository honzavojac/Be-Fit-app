// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/exercise_page.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/statistics_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'split_page.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildAppBar(context),
    );
  }
}

class FitnessRecordScreen extends StatefulWidget {
  const FitnessRecordScreen({super.key});

  @override
  State<FitnessRecordScreen> createState() => _FitnessRecordScreenState();
}

class _FitnessRecordScreenState extends State<FitnessRecordScreen> {
  @override
  void initState() {
    super.initState();
  }

  int a = 0;
  Future loadData(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    if (a == 0) {
      // print(a);
      a = 1;
      await dbSupabase.getFitness();
      setState(() {});
    } else {
      // print(a);
      a = 0;
    }
  }

  void refresh() {
    a = 0;
    setState(() {});
  }

  String? splitName;
  int selectedSplit = 0;

  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var variablesProvider = Provider.of<VariablesProvider>(context);
    loadData(context);
    var splits = dbSupabase.splits;
    if (splits.isEmpty) {
      print("1");

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
                      // width: 150,
                      height: 40,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: splitName ?? (splits.isNotEmpty ? splits[0].nameSplit : null),
                          items: splits.map<DropdownMenuItem<String>>((split) {
                            return DropdownMenuItem<String>(
                              value: split.nameSplit,
                              child: Center(
                                child: Text(
                                  split.nameSplit.toString().toUpperCase(),
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
                            splitName = value!;
                            for (var i = 0; i < splits.length; i++) {
                              if (splits[i].nameSplit == value) {
                                selectedSplit = i;
                                dbSupabase.clickedSplitTab = i;
                              }
                            }
                            setState(() {});
                            print(splitName);
                            print(selectedSplit);
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
                          builder: (context) => SplitPage(
                            notifyParent: () {
                              refresh();
                            },
                          ),
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
      // print("2");

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
                              value: splitName ?? (splits.isNotEmpty ? splits[0].nameSplit : null),
                              items: splits.map<DropdownMenuItem<String>>((split) {
                                return DropdownMenuItem<String>(
                                  value: split.nameSplit,
                                  child: Center(
                                    child: Text(
                                      split.nameSplit.toString().toUpperCase(),
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
                                splitName = value!;
                                for (var i = 0; i < splits.length; i++) {
                                  if (splits[i].nameSplit == value) {
                                    selectedSplit = i;
                                    dbSupabase.clickedSplitTab = i;
                                  }
                                }
                                setState(() {});
                                print(splitName);
                                print(selectedSplit);
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
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplitPage(
                                notifyParent: refresh,
                              ),
                            ),
                          );
                          dbSupabase.getFitness();
                          dbSupabase.clickedSplitTab = 0;
                          setState(() {});
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: ColorsProvider.color_7,
                    // border: Border.all(color: Colors.white),
                    borderRadius: variablesProvider.zaobleni,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: splits[selectedSplit].selectedMuscle!.length,
                          itemBuilder: (context, muscleIndex) {
                            String muscle = splits[selectedSplit].selectedMuscle![muscleIndex].muscles!.nameOfMuscle;

                            if (splits[selectedSplit].selectedMuscle![muscleIndex].selectedExercises!.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            // color: ColorsProvider.color_2,
                                            borderRadius: variablesProvider.zaobleni,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "$muscle".toUpperCase(),
                                              style: TextStyle(
                                                color: ColorsProvider.color_8,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                        ),
                                        child: Container(
                                          child: Text(
                                            "No exercises",
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            // color: ColorsProvider.color_2,
                                            borderRadius: variablesProvider.zaobleni,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "$muscle".toUpperCase(),
                                              style: TextStyle(
                                                color: ColorsProvider.color_8,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                        ),
                                        child: Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: splits[selectedSplit].selectedMuscle![muscleIndex].selectedExercises!.length,
                                            itemBuilder: (context, exerciseIndex) {
                                              String exercise = splits[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises.nameOfExercise;

                                              return GestureDetector(
                                                onTap: () async {
                                                  ExerciseData.resetCounter();
                                                  await dbSupabase.getFitness();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ExercisePage(
                                                        splitIndex: selectedSplit,
                                                        muscleIndex: muscleIndex,
                                                        exerciseIndex: exerciseIndex,
                                                        notifyParent: refresh,
                                                      ),
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
                                                              "$exercise".toUpperCase(),
                                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
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
                                                                          itemCount: splits[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises.exerciseData!.length,
                                                                          scrollDirection: Axis.horizontal,
                                                                          itemBuilder: (context, index) {
                                                                            var data = splits[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises.exerciseData![index];
                                                                            int reps;
                                                                            int weight;
                                                                            // if (DateTime.now().toString().replaceRange(10, null, '') == splits[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                                                                            reps = data.reps;
                                                                            weight = data.weight;
                                                                            // } else {}
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                              child: Container(
                                                                                width: 30,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    Text("${index + 1}"),
                                                                                    Text("$weight"),
                                                                                    Text("$reps"),
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
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   //crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Container(
              //       //color: Colors.blue,
              //       height: 40,
              //       width: 150,
              //       child: ElevatedButton.icon(
              //         onPressed: () {
              //           print(dbFirebase.mapFinalExercises[selectedSplit]);
              //         },
              //         icon: Icon(Icons.add, size: 30),
              //         label: Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
              //         style: ButtonStyle(
              //             backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2),
              //             foregroundColor: MaterialStateProperty.all(
              //               ColorsProvider.color_8,
              //             ) // Nastavení barvy zde
              //             ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 20,
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      );
    }
  }
}

/**/
Widget _buildAppBar(BuildContext context) {
  return Row(
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
  );
}
