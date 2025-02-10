import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_state.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:provider/provider.dart';

import '../../../bloc/fitness_event.dart';
import '../../../init_page.dart';
import '../../../pages/fitnessRecord/split_page copy 3.dart';
import '../../../providers/colors_provider.dart';
import '../../../providers/variables_provider.dart';
import '../../../supabase/supabase.dart';
import '../../../variables.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

import 'list_views/muscle_list_view.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

int selectedSplit = 0;

class _TestPageState extends State<TestPage> {
  void initState() {
    super.initState();
    // loadData();
  }

  bool loaded = false;

//   loadData() {
//     print("load");

//     // Vytvoření mapy muscleId → Muscle
//     muscleMap = {
//       for (var muscle in sqfliteMuscleList)
//         if (muscle.supabaseIdMuscle != null) muscle.supabaseIdMuscle!: muscle
//     };

//     exerciseMap = {
//       for (var exercise in sqfliteExerciseList)
//         if (exercise.supabaseIdExercise != null) exercise.supabaseIdExercise!: exercise
//     };
//     for (var startedCompleted in sqfliteSplitStartedCompletedList) {
//       if (startedCompleted.ended == false) {
//         splitStartedCompleted = startedCompleted;
//         int splitIndex = sqfliteSplitList.indexWhere(
//           (split) => split.supabaseIdSplit == startedCompleted.splitId,
//         );
//         context.read<FitnessBloc>().add(UpdateSelectedSplitIndex(splitIndex));
//       }
//     }
//     exerciseData.clear();
//     for (var exerciseDataItem in sqfliteExerciseDataList) {
//       if (splitStartedCompleted != null && exerciseDataItem.idStartedCompleted == splitStartedCompleted!.supabaseIdStartedCompleted) {
//         if (!exerciseData.containsKey(exerciseDataItem.exercisesIdExercise)) {
//           exerciseData[exerciseDataItem.exercisesIdExercise!] = [];
//         }
//         exerciseData[exerciseDataItem.exercisesIdExercise]!.add(exerciseDataItem);
//       }
//     }

// // Vytvoření mapy splitId → List<muscleId>
//     // for (var split in sqfliteSplitList) {
//     //   selectedMuscleMap[split.supabaseIdSplit!] = [];
//     // }

// // Přidání svalů do seznamu v mapě
//     selectedMuscleMap.clear();
//     selectedExerciseMap.clear();

//     for (var selectedMuscle in sqfliteSelectedMuscleList) {
//       if (!selectedMuscleMap.containsKey(selectedMuscle.splitIdSplit)) {
//         selectedMuscleMap[selectedMuscle.splitIdSplit!] = [];
//       }

//       // Přidání objektu SelectedMuscle místo pouze ID
//       selectedMuscleMap[selectedMuscle.splitIdSplit!]!.add(selectedMuscle);
//     }
//     // selectedMuscleMap = mapa;

//     for (var selectedExercise in sqfliteSelectedExerciseList) {
//       int muscleId = selectedExercise.idSelectedMuscle!;

//       // Zajisti, že pro daný muscleId existuje seznam v mapě
//       if (!selectedExerciseMap.containsKey(muscleId)) {
//         selectedExerciseMap[muscleId] = []; // Inicializuj prázdný seznam, pokud neexistuje
//       }

//       // Přidej idExercise do seznamu
//       selectedExerciseMap[muscleId]!.add(selectedExercise.idExercise!);
//     }

//     print(muscleMap);
//     print(exerciseMap);
//     print("${selectedMuscleMap}");
//     print("${selectedExerciseMap}<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

// // Iterace přes `sqfliteSplitList` s využitím mapy
//     // for (var split in sqfliteSplitList) {
//     //   print("***** " + split.nameSplit);
//     //   int? idSplit = split.supabaseIdSplit;

//     //   if (idSplit != null && selectedMuscleMap.containsKey(idSplit)) {
//     //     for (var muscleId in selectedMuscleMap[idSplit]!) {
//     //       if (muscleMap.containsKey(muscleId)) {
//     //         Muscle muscle = muscleMap[muscleId]!;
//     //         print("  - " + muscle.nameOfMuscle! + " ${muscleId}");

//     //         // Výpis cviků pro tento sval
//     //         if (selectedMuscleExerciseMap.containsKey(muscleId) && selectedMuscleExerciseMap[muscleId]!.isNotEmpty) {
//     //           for (var exerciseId in selectedMuscleExerciseMap[muscleId]!) {
//     //             if (exerciseMap.containsKey(exerciseId)) {
//     //               Exercise exercise = exerciseMap[exerciseId]!;
//     //               print("    * exercise: ${exercise.nameOfExercise}");
//     //             }
//     //           }
//     //         } else {
//     //           print("    (No exercises assigned to this muscle)");
//     //         }
//     //       }
//     //     }
//     //   }
//     // }
//   }

  int? supabaseIdSplit = 0;
  int? idSplitStartedCompleted;

  @override
  Widget build(BuildContext context) {
    // idkIndex = sqfliteSplitList[selectedSplit].supabaseIdSplit!;
    // loadData();
    loaded = true;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            loaded == true
                ? BlocBuilder<FitnessBloc, FitnessState>(
                    builder: (context, state) {
                      if (state is FitnessLoaded) {
                        SplitStartedCompleted? splitStartedCompleted = state.splitStartedCompleted;
                        return Container(
                          // color: Colors.blue,
                          // color: const Color.fromARGB(66, 33, 149, 243),
                          child: ListView(
                            children: [
                              splitStartedCompleted == null
                                  ? Container(height: 50, child: FitnessRecordDropdown())
                                  : GestureDetector(
                                      onTap: () {
                                        context.read<FitnessBloc>().add(UpdateSplitStartedCompleted(null));
                                      },
                                      child: Container(
                                        height: 50,
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text("Zrušit split $splitStartedCompleted  ${state.selectedSplitIndex}"),
                                        ),
                                      ),
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: MuscleListViewBuilder(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class FitnessRecordDropdown extends StatefulWidget {
  const FitnessRecordDropdown({super.key});

  @override
  State<FitnessRecordDropdown> createState() => FitnessRecordDropdownState();
}

class FitnessRecordDropdownState extends State<FitnessRecordDropdown> {
  @override
  Widget build(BuildContext context) {
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
                child: BlocBuilder<FitnessBloc, FitnessState>(
                  builder: (context, state) {
                    if (state is FitnessLoaded) {
                      int selectedSplit = state.selectedSplitIndex;
                      List<MySplit> splits = state.splits;

                      return DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: splits[selectedSplit].nameSplit,
                          items: List.generate(
                            splits.length,
                            (index) {
                              return DropdownMenuItem(
                                value: splits[index].nameSplit,
                                child: Center(
                                  child: Text(
                                    splits[index].nameSplit.toString().toUpperCase(),
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
                            // Přidej logiku pro změnu hodnoty
                            // idkIndex = splits[selectedSplit].supabaseIdSplit!;
                            int selectedSplitIndex = splits.indexWhere((split) => split.nameSplit == value);

                            context.read<FitnessBloc>().add(UpdateSelectedSplitIndex(selectedSplitIndex));

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
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        ],
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

class oldFitnessRecordDropdown extends StatefulWidget {
  final List<MySplit> splits;
  final int? supabaseIdSplit;
  final int selectedSplit;
  final void Function() refresh;
  final void Function(int) onChanged;

  const oldFitnessRecordDropdown({
    Key? key,
    required this.supabaseIdSplit,
    required this.splits,
    required this.selectedSplit,
    required this.refresh,
    required this.onChanged,
  }) : super(key: key);

  @override
  old_FitnessRecordDropdownState createState() => old_FitnessRecordDropdownState();
}

class old_FitnessRecordDropdownState extends State<oldFitnessRecordDropdown> {
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
