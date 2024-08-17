// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/split_page%20copy%203.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'exercise_page copy.dart';

// class FitnessRecordAppBarCopy extends StatelessWidget {
//   const FitnessRecordAppBarCopy({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: CustomAppBar(),
//     );
//   }
// }

class FitnessRecordScreenCopy extends StatefulWidget {
  const FitnessRecordScreenCopy({super.key});

  @override
  State<FitnessRecordScreenCopy> createState() => _FitnessRecordScreenCopyState();
}

int selectedSplit = 0;

class _FitnessRecordScreenCopyState extends State<FitnessRecordScreenCopy> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

//proměnná pro vykreslení žádného widgetu
  List<MySplit> exercisesData = [];
  // int? idStartedCompleted;
  late bool foundActiveSplit;
  bool loaded = false;
  Future<void> loadData() async {
    try {
      var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
      foundActiveSplit = false;
      exercisesData = await dbFitness.SelectAllData();

      int i = 0;
      activeSplit:
      for (var split in exercisesData) {
        for (var splitStartedCompleted in split.splitStartedCompleted!) {
          if (splitStartedCompleted.ended == false) {
            idSplitStartedCompleted = splitStartedCompleted.supabaseIdStartedCompleted!;
            foundActiveSplit = true;
            selectedSplit = i;
            List<ExerciseData> exerciseDataItems = await dbFitness.SelectCurrentExerciseDataWhereId(idSplitStartedCompleted!);

            for (var selectedMuscle in split.selectedMuscle!) {
              for (var selectedExercise in selectedMuscle.selectedExercises!) {
                selectedExercise.exercises!.exerciseData = [];
                for (var item in exerciseDataItems) {
                  if (selectedExercise.exercises!.supabaseIdExercise == item.exercisesIdExercise) {
                    selectedExercise.exercises!.exerciseData!.add(item);
                  }
                }
                selectedExercise.exercises!.exerciseData!.removeWhere((data) => data.action == 3);
              }
              selectedMuscle.selectedExercises!.removeWhere((exercise) => exercise.action == 3);
            }
            break activeSplit;
          }
        }
        i++;
      }

      for (var split in exercisesData) {
        for (var selectedMuscle in split.selectedMuscle!) {
          selectedMuscle.selectedExercises!.removeWhere((selectedExercise) => selectedExercise.action == 3);
        }
      }
      loaded = true;

      setState(() {});
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  Future<void> refresh() async {
    selectedSplit = 0;
    loadData();
    setState(() {});
  }

  String? splitName;
  int? supabaseIdSplit = 0;
  int? idSplitStartedCompleted;

  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);
    if (exercisesData.isNotEmpty) {
      supabaseIdSplit = exercisesData[selectedSplit].supabaseIdSplit!;
    }

    return Container(
      child: Stack(
        children: [
          loaded == true
              ? exercisesData.isNotEmpty
                  ? Container(
                      // color: const Color.fromARGB(66, 33, 149, 243),
                      child: ListView(
                        shrinkWrap: false,
                        children: [
                          SizedBox(
                            height: 65,
                          ),
                          foundActiveSplit == false
                              ? FitnessRecordDropdown(
                                  supabaseIdSplit: supabaseIdSplit,
                                  splits: exercisesData,
                                  splitName: splitName,
                                  selectedSplit: selectedSplit,
                                  refresh: refresh,
                                  onChanged: (value) {
                                    setState(() {
                                      supabaseIdSplit = value;
                                      for (var i = 0; i < exercisesData.length; i++) {
                                        if (exercisesData[i].supabaseIdSplit == value) {
                                          selectedSplit = i;
                                        }
                                      }
                                      // selectedSplit = value - 1;
                                      // for (var i = 0; i < exercisesData.length; i++) {
                                      //   if (exercisesData[i].nameSplit == value) {
                                      //     selectedSplit = i;

                                      //     break;
                                      //   }
                                      // }
                                    });
                                  },
                                )
                              : FitnessRecordEndSplit(
                                  splitName: splitName,
                                  idSplitStartedCompleted: idSplitStartedCompleted!,
                                  refresh: refresh,
                                  loadData: loadData,
                                  onChanged: (value) {},
                                ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            // color: Color.fromARGB(99, 94, 94, 94),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: exercisesData[selectedSplit].selectedMuscle!.length,
                              itemBuilder: (context, muscleIndex) {
                                String muscle = exercisesData[selectedSplit].selectedMuscle![muscleIndex].muscles!.nameOfMuscle!;
                                if (exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsProvider.color_2,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
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
                                                    // letterSpacing: 2,
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
                                                style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold),
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
                                              top: 12,
                                            ),
                                            child: Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises!.length,
                                                itemBuilder: (context, exerciseIndex) {
                                                  String nameOfExercise = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.nameOfExercise!;
                                                  int idExercise = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.supabaseIdExercise!;
                                                  int idSplit = exercisesData[selectedSplit].supabaseIdSplit!;
                                                  var exerciseDataItem = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData;
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      ExerciseData.resetCounter();
                                                      if (idSplitStartedCompleted != null) {}

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ExercisePageCopy(
                                                            onExerciseDataReturned: (List<ExerciseData> returnedData) {
                                                              setState(() {
                                                                exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData = returnedData;

                                                                print("převzány hodnoty");
                                                              });
                                                            },
                                                            loadData: loadData,
                                                            nameOfExercise: nameOfExercise,
                                                            idExercise: idExercise,
                                                            idSplit: idSplit,
                                                          ),
                                                        ),
                                                      );
                                                      // setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 5),
                                                      child: Container(
                                                        height: 105,
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
                                                                  "$nameOfExercise".toUpperCase(),
                                                                  style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 18),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                                                                child: Container(
                                                                  decoration: BoxDecoration(color: Color.fromARGB(125, 0, 0, 0), borderRadius: variablesProvider.zaobleni),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                        child: Container(
                                                                          width: 60,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text(
                                                                                "Set",
                                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              Text(
                                                                                "Weight",
                                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              Text(
                                                                                "Reps",
                                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: 1,
                                                                        color: ColorsProvider.color_8,
                                                                      ),
                                                                      exerciseDataItem != null
                                                                          ? Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                                child: Container(
                                                                                  child: ListView.builder(
                                                                                    itemCount: exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData!.length,
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemBuilder: (context, index) {
                                                                                      var data = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData![index];
                                                                                      String reps;
                                                                                      String? weight;
                                                                                      int? difficulty;
                                                                                      // if (DateTime.now().toString().replaceRange(10, null, '') == exercisesData[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                                                                                      reps = (data.reps == null ? "" : data.reps!).toString();
                                                                                      weight = (data.weight == null ? "" : data.weight!).toString();
                                                                                      ;
                                                                                      difficulty = data.difficulty;
                                                                                      // } else {}
                                                                                      return Padding(
                                                                                        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                                        child: Container(
                                                                                          width: 40,
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Text(
                                                                                                "${index + 1}",
                                                                                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                                              ),
                                                                                              Text(
                                                                                                "$weight",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 16,
                                                                                                  color: difficulty == 0
                                                                                                      ? Colors.white
                                                                                                      : difficulty == 1
                                                                                                          ? Colors.green
                                                                                                          : difficulty == 2
                                                                                                              ? Colors.lightGreen
                                                                                                              : difficulty == 3
                                                                                                                  ? Colors.yellow
                                                                                                                  : difficulty == 4
                                                                                                                      ? Colors.orange
                                                                                                                      : ColorsProvider.color_9,
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                "$reps",
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 16,
                                                                                                  color: difficulty == 0
                                                                                                      ? Colors.white
                                                                                                      : difficulty == 1
                                                                                                          ? Colors.green
                                                                                                          : difficulty == 2
                                                                                                              ? Colors.lightGreen
                                                                                                              : difficulty == 3
                                                                                                                  ? Colors.yellow
                                                                                                                  : difficulty == 4
                                                                                                                      ? Colors.orange
                                                                                                                      : ColorsProvider.color_9,
                                                                                                ),
                                                                                              ),
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
                                                                          : Container(),
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
                          )
                        ],
                      ),
                    )
                  : Container()
              : Container(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          exercisesData.isEmpty
              ? Container(
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomAppBar(
                          loadParent: loadData,
                          foundActiveSplit: foundActiveSplit,
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomAppBar(
                          loadParent: loadData,
                          foundActiveSplit: foundActiveSplit,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  final Function()? refresh;
  final Function() loadParent;
  final bool foundActiveSplit;
  CustomAppBar({
    this.refresh,
    required this.loadParent,
    required this.foundActiveSplit,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 35,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  //tady****************************************************************************************************************************
                  builder: (context) => SplitPageCopy(
                    clickedSplitTab: selectedSplit,
                    notifyParent: widget.refresh,
                    loadParent: widget.loadParent,
                    foundActiveSplit: widget.foundActiveSplit,
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
              elevation: WidgetStatePropertyAll(5),
              // overlayColor: WidgetStatePropertyAll(Colors.blue),
              shadowColor: WidgetStatePropertyAll(Colors.black),
              backgroundColor: WidgetStateProperty.all(ColorsProvider.color_2),
              foregroundColor: WidgetStateProperty.all(ColorsProvider.color_8),
            ),
          ),
        ),
        // SizedBox(
        //   width: 10,
        // ),
      ],
    );
  }
}

class FitnessRecordDropdown extends StatefulWidget {
  final List<MySplit> splits;
  final int? supabaseIdSplit;
  final String? splitName;
  final int selectedSplit;
  final void Function() refresh;
  final void Function(int) onChanged;

  const FitnessRecordDropdown({
    Key? key,
    required this.supabaseIdSplit,
    required this.splits,
    required this.splitName,
    required this.selectedSplit,
    required this.refresh,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FitnessRecordDropdownState createState() => _FitnessRecordDropdownState();
}

class _FitnessRecordDropdownState extends State<FitnessRecordDropdown> {
  @override
  Widget build(BuildContext context) {
    List<MySplit> splits = widget.splits;
    var variablesProvider = Provider.of<VariablesProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(55, 8, 55, 5),
              child: Container(
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<int>(
                    isExpanded: true,
                    value: widget.supabaseIdSplit,
                    items: List<DropdownMenuItem<int>>.generate(
                      splits.length,
                      (index) {
                        final split = splits[index];
                        return DropdownMenuItem<int>(
                          value: split.supabaseIdSplit,
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
                      },
                    ),
                    onChanged: (value) {
                      widget.onChanged(value!);
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
                        thickness: WidgetStateProperty.all(6),
                        thumbVisibility: WidgetStateProperty.all(true),
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
        ],
      ),
    );
  }
}

class FitnessRecordEndSplit extends StatefulWidget {
  final String? splitName;
  final int idSplitStartedCompleted;
  final void Function() refresh;
  final void Function() loadData;
  final void Function(String) onChanged;

  const FitnessRecordEndSplit({
    Key? key,
    required this.splitName,
    required this.idSplitStartedCompleted,
    required this.refresh,
    required this.loadData,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FitnessRecordEndSplitState createState() => _FitnessRecordEndSplitState();
}

class _FitnessRecordEndSplitState extends State<FitnessRecordEndSplit> {
  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(55, 8, 55, 5),
              child: Container(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm End Entry'),
                          content: Text('Do you really want to end the entry?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //no
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: ColorsProvider.color_2,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //yes
                                    DateTime dateTime = DateTime.now();
                                    String now = dateTime.toString();
                                    await dbFitness.UpdateSplitStartedCompleted(true, now, widget.idSplitStartedCompleted);
                                    widget.loadData();
                                    widget.refresh;
                                    dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    // padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                    decoration: BoxDecoration(
                                      color: ColorsProvider.color_9,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(ColorsProvider.color_5),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Aby se řádek smrskl na minimální možnou šířku
                    children: [
                      Text(
                        "End this split",
                        style: TextStyle(color: ColorsProvider.color_3, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8), // Oddělovač mezi textem a ikonou
                      Icon(
                        Icons.check_circle_outline,
                        // Icons.pause,
                        color: ColorsProvider.color_3,
                      ), // Ikonu umístíme na konec
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   height: 35,
          //   child: ElevatedButton.icon(
          //     onPressed: () async {
          //       await Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SplitPage(
          //             notifyParent: widget.refresh,
          //           ),
          //         ),
          //       );
          //       widget.refresh();
          //     },
          //     icon: Icon(Icons.edit_outlined),
          //     label: Text(
          //       'Edit split',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     style: ButtonStyle(
          //       backgroundColor: WidgetStateProperty.all(ColorsProvider.color_2),
          //       foregroundColor: WidgetStateProperty.all(ColorsProvider.color_8),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 10,
          // ),
        ],
      ),
    );
  }
}
