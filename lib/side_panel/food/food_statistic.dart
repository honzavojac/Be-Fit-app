import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:provider/provider.dart';

import '../../data.dart';
import '../../init_page.dart';
import '../../pages/fitnessRecord/exercise_page copy.dart';
import '../../pages/fitnessRecord/split_page copy 3.dart';
import '../../providers/colors_provider.dart';
import '../../providers/variables_provider.dart';
import '../../supabase/supabase.dart';
import '../../variables.dart';
import 'dart:async';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

class foodStatistic extends StatefulWidget {
  const foodStatistic({super.key});

  @override
  State<foodStatistic> createState() => _foodStatisticState();
}

// int selectedSplit = 0;

class _foodStatisticState extends State<foodStatistic> {
  void initState() {
    super.initState();
    // loadData();
  }

//proměnná pro vykreslení žádného widgetu
  List<MySplit> exercisesData = [];
  // int? idStartedCompleted;
  late bool foundActiveSplit;
  bool loaded = false;

  loadData() {
    print("load");

    // Vytvoření mapy muscleId → Muscle
    muscleMap = {
      for (var muscle in sqfliteMuscleList)
        if (muscle.supabaseIdMuscle != null) muscle.supabaseIdMuscle!: muscle
    };

    exerciseMap = {
      for (var exercise in sqfliteExerciseList)
        if (exercise.supabaseIdExercise != null) exercise.supabaseIdExercise!: exercise
    };

// Vytvoření mapy splitId → List<muscleId>
    // for (var split in sqfliteSplitList) {
    //   selectedMuscleMap[split.supabaseIdSplit!] = [];
    // }

// Přidání svalů do seznamu v mapě
    selectedMuscleMap.clear();
    selectedExerciseMap.clear();

    for (var selectedMuscle in sqfliteSelectedMuscleList) {
      if (!selectedMuscleMap.containsKey(selectedMuscle.splitIdSplit)) {
        selectedMuscleMap[selectedMuscle.splitIdSplit!] = [];
      }

      // Přidání objektu SelectedMuscle místo pouze ID
      selectedMuscleMap[selectedMuscle.splitIdSplit!]!.add(selectedMuscle);
    }
    // selectedMuscleMap = mapa;

    for (var selectedExercise in sqfliteSelectedExerciseList) {
      int muscleId = selectedExercise.idSelectedMuscle!;

      // Zajisti, že pro daný muscleId existuje seznam v mapě
      if (!selectedExerciseMap.containsKey(muscleId)) {
        selectedExerciseMap[muscleId] = []; // Inicializuj prázdný seznam, pokud neexistuje
      }

      // Přidej idExercise do seznamu
      selectedExerciseMap[muscleId]!.add(selectedExercise.idExercise!);
    }

    print(muscleMap);
    print(exerciseMap);
    print("${selectedMuscleMap}");
    print("${selectedExerciseMap}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

// Iterace přes `sqfliteSplitList` s využitím mapy
    // for (var split in sqfliteSplitList) {
    //   print("***** " + split.nameSplit);
    //   int? idSplit = split.supabaseIdSplit;

    //   if (idSplit != null && selectedMuscleMap.containsKey(idSplit)) {
    //     for (var muscleId in selectedMuscleMap[idSplit]!) {
    //       if (muscleMap.containsKey(muscleId)) {
    //         Muscle muscle = muscleMap[muscleId]!;
    //         print("  - " + muscle.nameOfMuscle! + " ${muscleId}");

    //         // Výpis cviků pro tento sval
    //         if (selectedMuscleExerciseMap.containsKey(muscleId) && selectedMuscleExerciseMap[muscleId]!.isNotEmpty) {
    //           for (var exerciseId in selectedMuscleExerciseMap[muscleId]!) {
    //             if (exerciseMap.containsKey(exerciseId)) {
    //               Exercise exercise = exerciseMap[exerciseId]!;
    //               print("    * exercise: ${exercise.nameOfExercise}");
    //             }
    //           }
    //         } else {
    //           print("    (No exercises assigned to this muscle)");
    //         }
    //       }
    //     }
    //   }
    // }

    loaded = true;
  }

  Future<void> refresh() async {
    print("*******************************refresh*******************************");
    selectedSplit = 0;
    loadData();
    setState(() {});
  }

  int? supabaseIdSplit = 0;
  int? idSplitStartedCompleted;

  @override
  Widget build(BuildContext context) {
    idkIndex = sqfliteSplitList[selectedSplit].supabaseIdSplit!;
    loadData();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            loaded == true
                ? Container(
                    // color: Colors.blue,
                    // color: const Color.fromARGB(66, 33, 149, 243),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 65,
                        ),
                        Padding(
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
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        value: sqfliteSplitList[selectedSplit].nameSplit,
                                        items: List.generate(
                                          sqfliteSplitList.length,
                                          (index) {
                                            return DropdownMenuItem(
                                              value: sqfliteSplitList[index].nameSplit,
                                              child: Center(
                                                child: Text(sqfliteSplitList[index].nameSplit),
                                              ),
                                            );
                                          },
                                        ),
                                        onChanged: (value) {
                                          // Přidej logiku pro změnu hodnoty
                                          idkIndex = sqfliteSplitList[selectedSplit].supabaseIdSplit!;
                                          selectedSplit = sqfliteSplitList.indexWhere((split) => split.nameSplit == value);
                                          setState(() {});
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          width: 180,
                                          padding: const EdgeInsets.symmetric(horizontal: 14),
                                          decoration: BoxDecoration(
                                            borderRadius: zaobleni,
                                            border: Border.all(
                                              color: ColorsProvider.getColor2(context),
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: Icon(Icons.keyboard_arrow_down_outlined),
                                          iconSize: 17,
                                          iconEnabledColor: ColorsProvider.getColor2(context),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: zaobleni,
                                            border: Border.all(width: 2, color: ColorsProvider.getColor2(context)),
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
                        ),
                        Container(
                          child: Text(""),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.amber,
                                  child: ListView.builder(
                                    itemCount: selectedMuscleMap[idkIndex]!.length,
                                    itemBuilder: (context, index) {
                                      int musclesIdMuscle = selectedMuscleMap[idkIndex]![index].musclesIdMuscle!;
                                      Muscle muscle = muscleMap[musclesIdMuscle]!;

                                      int supabaseIdSelectedMuscle = selectedMuscleMap[idkIndex]![index].supabaseIdSelectedMuscle!;

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: Container(
                                          // height: 50,
                                          color: index % 2 == 0 ? Colors.blueAccent : Colors.green,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "${muscle.nameOfMuscle.toString()}  || ${supabaseIdSelectedMuscle}",
                                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              selectedExerciseMap[supabaseIdSelectedMuscle] != null
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: selectedExerciseMap[supabaseIdSelectedMuscle]!.length,
                                                      itemBuilder: (context, exerciseIndex) {
                                                        int supabaseIdExercise = selectedExerciseMap[supabaseIdSelectedMuscle]![exerciseIndex];
                                                        Exercise exercise = exerciseMap[supabaseIdExercise]!;
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            // await selectedExerciseMap[supabaseIdSelectedMuscle]!.removeAt(index);
                                                            sqfliteSelectedExerciseList.removeWhere(
                                                              (element) => element.idExercise == supabaseIdExercise,
                                                            );
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            color: exerciseIndex % 2 == 0 ? Colors.pink : Colors.pink.shade700,
                                                            height: 40,
                                                            child: Center(child: Text("${exercise.nameOfExercise}  || ${exercise.supabaseIdExercise}")),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Container(),
                                              ElevatedButton(
                                                  // 217
                                                  onPressed: () {
                                                    sqfliteSelectedExerciseList.add(
                                                      SelectedExercise(
                                                        action: 0,
                                                        idExercise: 217,
                                                        idSelectedMuscle: 83,
                                                      ),
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Text("add"))
                                            ],
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
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  final Function() refresh;
  final Function() loadParent;
  final bool foundActiveSplit;
  CustomAppBar({
    required this.refresh,
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
          key: keyEditWorkouts,
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
            icon: Icon(
              Icons.edit_outlined,
              color: colorBlack,
            ),
            label: Text(
              'edit_split'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(5),
              // overlayColor: WidgetStatePropertyAll(Colors.blue),
              shadowColor: WidgetStatePropertyAll(Colors.black),
              backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
              foregroundColor: WidgetStateProperty.all(ColorsProvider.getColor8(context)),
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
  final int selectedSplit;
  final void Function() refresh;
  final void Function(int) onChanged;

  const FitnessRecordDropdown({
    Key? key,
    required this.supabaseIdSplit,
    required this.splits,
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
                    value: widget.supabaseIdSplit ?? 0,
                    items: List<DropdownMenuItem<int>>.generate(
                      splits.length,
                      (index) {
                        final split = splits[index];
                        return DropdownMenuItem<int>(
                          value: split.supabaseIdSplit,
                          child: Center(
                            child: Text(
                              split.nameSplit.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorsProvider.getColor2(context),
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
                        borderRadius: zaobleni,
                        border: Border.all(
                          color: ColorsProvider.getColor2(context),
                          width: 0.5,
                        ),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: 17,
                      iconEnabledColor: ColorsProvider.getColor2(context),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: zaobleni,
                        border: Border.all(width: 2, color: ColorsProvider.getColor2(context)),
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
  final int idSplitStartedCompleted;
  final void Function() refresh;
  final void Function() loadData;
  final void Function(String) onChanged;

  const FitnessRecordEndSplit({
    Key? key,
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
    Provider.of<VariablesProvider>(context);
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
                                      color: ColorsProvider.getColor2(context),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
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
                        "end_this_split".tr(),
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
          //       backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
          //       foregroundColor: WidgetStateProperty.all(ColorsProvider.getColor8(context)),
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
