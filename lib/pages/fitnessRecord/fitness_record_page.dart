// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

//import 'dart:html';

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/exercise_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'split_page copy 3.dart';
import 'split_page.dart';

class FitnessRecordAppBar extends StatelessWidget {
  const FitnessRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomAppBar(),
    );
  }
}

class FitnessRecordScreen extends StatefulWidget {
  const FitnessRecordScreen({super.key});

  @override
  State<FitnessRecordScreen> createState() => _FitnessRecordScreenState();
}

class _FitnessRecordScreenState extends State<FitnessRecordScreen> {
  StreamController<List<Split>> _streamController = StreamController<List<Split>>();

  @override
  void initState() {
    super.initState();
    // loadData();
  }

/*v initstate se provede kontrola jestli nějaký ze splitů má nastavené v tabulce split_started_completed v sloupci ended 
    --> true
      -->tak se zobrazí dropdownWidget (na vybrání splitu)  
        --> nastaví se hodnota z provideru (pokud tam je) nebo nultá hodnota
        --> vybere se split a uloží hodnotu do provideru (co bylo vybráno)
        --> selectuje se po tabulku selected_exercise a zobrazí se jejich hodnoty 
        (bez exercise_data hodnot protože jsou null -> není nastavené id_started_completed)
        
          --> klikne se na cvik kde před zápisem první hodnoty se insertuje nový řádek v split_started_completed 
            --> nastaví se boolInsertSplitStartedCompleted na false (pro zobrazení endWidgetu) if(boolInsertSplitStartedCompleted == false) zobraz endWidget
            --> uloží se jeho id_started_completed (pro insertování nové hodnoty) 
              -->insertuje se do exercise_data

    --> false
      --> tak se nastaví indexSplitu (na zobrazení) a uloží se !!! id_started_completed do provideru !!!
      --> hodnota boolInsertSplitStartedCompleted na false (zobrazuje se jen endWidget na zastavení zadávání)
      --> provede se select na (exercise_data) kde id_started_completed je id_started_completed 
        */
//proměnná pro vykreslení žádného widgetu
  List<Split> rawData = [];
  List<Split> exerciseData = [];
  int? idStartedCompleted;
  late bool foundActiveSplit;
  Future<void> loadData() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    idStartedCompleted = null;

    await dbSupabase.getFitness();
    rawData = dbSupabase.splits;

    foundActiveSplit = false;

    // Provedení kontroly, zda existuje aktivní split s ended == false
    for (var i = 0; i < rawData.length; i++) {
      var dataSplit = rawData[i].splitStartedCompleted;
      for (var j = 0; j < dataSplit!.length; j++) {
        var finalData = dataSplit[j];
        // print(dataSplit.length);
        if (finalData.ended == false) {
          print("i: $i");
          print("j: $j");
          print("idStartedCompleted: ${finalData.idStartedCompleted}");
          print("splitId: ${finalData.splitId}");
          print("**************************");
          // for (var element in rawData) {
          //   print("idSplit: ${element.idSplit} nameSplit: ${element.nameSplit}");
          // }
          // for (var element in dataSplit) {
          //   print("idStartedCompleted: ${element.idStartedCompleted}, ${element.splitId}");
          // }
          dbSupabase.boolInsertSplitStartedCompleted = false;
          idStartedCompleted = finalData.idStartedCompleted;
          selectedSplit = i; // Nastavení vybraného splitu
          foundActiveSplit = true;
          break;
        }
      }
      if (foundActiveSplit) break;
    }

    if (foundActiveSplit) {
      await dbSupabase.getCurrentFitness(idStartedCompleted);
      exerciseData = dbSupabase.exerciseData;
    } else {
      exerciseData = rawData;
    }
    // for (var element in exerciseData) {
    //   print(element.nameSplit);
    //   for (var element1 in element.selectedMuscle!) {
    //     print(element1.idSelectedMuscle);
    //     for (var element in element1.selectedExercises!) {
    //       print(element.idSelectedExercise);
    //       for (var element in element.exercises.exerciseData!) {
    //         print("idstartedcompleted: ${element.idStartedCompleted}");
    //       }
    //     }
    //   }
    // }
//sort exerciseData podle idSplitu
    exerciseData.sort((a, b) => a.idSplit!.compareTo(b.idSplit!));
    // for (var i = 0; i < exerciseData.length; i++) {
    //   print("idSplit: ${exerciseData[i].idSplit} ${exerciseData[i].nameSplit}");
    // }
    // Emitování nových dat do streamu
    _streamController.add(exerciseData);
  }

  Future<void> refresh() async {
    selectedSplit = 0;
    loadData();
    setState(() {});
  }

  String? splitName;
  int selectedSplit = 0;
  int? idSplitStartedCompleted;

  @override
  Widget build(BuildContext context) {
    loadData();
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var variablesProvider = Provider.of<VariablesProvider>(context);

    return StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Split> exercisesData = snapshot.data!;
            if (exercisesData.isEmpty) {
              return Container();
            } else {
              return Column(
                children: [
                  Container(
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomAppBar(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: dbSupabase.boolInsertSplitStartedCompleted == true
                        ? FitnessRecordDropdown(
                            splits: exercisesData,
                            splitName: splitName,
                            selectedSplit: selectedSplit,
                            refresh: refresh,
                            onChanged: (value) {
                              setState(() {
                                splitName = value;
                                for (var i = 0; i < exercisesData.length; i++) {
                                  if (exercisesData[i].nameSplit == value) {
                                    selectedSplit = i;
                                    dbSupabase.clickedSplitTab = i;
                                    break;
                                  }
                                }
                              });
                            },
                          )
                        : FitnessRecordEndSplit(
                            splitName: splitName,
                            idStartedCompleted: idStartedCompleted,
                            refresh: refresh,
                            loadData: loadData,
                            onChanged: (value) {},
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
                      // color: Color.fromARGB(99, 94, 94, 94),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
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
                                                  var idSplit = exercisesData[selectedSplit].idSplit!;
                                                  var idMuscle = exercisesData[selectedSplit].selectedMuscle![muscleIndex].idSelectedMuscle;
                                                  var idExercise = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.idExercise;
                                                  var exerciseData = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData;
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      ExerciseData.resetCounter();
                                                      await dbSupabase.getFitness();
                                                      print(idStartedCompleted);
                                                      if (idSplitStartedCompleted != null) {
                                                        await dbSupabase.getCurrentFitness(idStartedCompleted);
                                                      }

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ExercisePage(
                                                            nameOfExercise: nameOfExercise,
                                                            idExercise: idExercise!,
                                                            splitId: idSplit,
                                                            idStartedCompleted: idStartedCompleted,
                                                            splitIndex: selectedSplit,
                                                            muscleIndex: muscleIndex,
                                                            exerciseIndex: exerciseIndex,
                                                            // notifyParent: refresh,
                                                          ),
                                                        ),
                                                      );
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
                                                                      exerciseData != null
                                                                          ? Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                                child: Container(
                                                                                  child: ListView.builder(
                                                                                    itemCount: exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData!.length,
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemBuilder: (context, index) {
                                                                                      var data = exercisesData[selectedSplit].selectedMuscle![muscleIndex].selectedExercises![exerciseIndex].exercises!.exerciseData![index];
                                                                                      int reps;
                                                                                      int weight;
                                                                                      int difficulty;
                                                                                      // if (DateTime.now().toString().replaceRange(10, null, '') == exercisesData[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                                                                                      reps = data.reps!;
                                                                                      weight = data.weight!;
                                                                                      difficulty = data.difficulty!;
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
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Container(
                // color: ColorsProvider.color_8,
                );
          }
        });
  }
}

class CustomAppBar extends StatefulWidget {
  final Function()? refresh; // Přijímá refreshovací funkci jako parametr

  CustomAppBar({this.refresh});

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
                  builder: (context) => SplitPage(
                    // clickedSplitTab: 0,
                    notifyParent: widget.refresh,
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
        // SizedBox(
        //   width: 10,
        // ),
      ],
    );
  }
}

class FitnessRecordDropdown extends StatefulWidget {
  final List<Split> splits;
  final String? splitName;
  final int selectedSplit;
  final void Function() refresh;
  final void Function(String) onChanged;

  const FitnessRecordDropdown({
    Key? key,
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
    List<Split> splits = widget.splits;
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
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: widget.splitName ?? (widget.splits.isNotEmpty ? widget.splits[0].nameSplit : null),
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
        ],
      ),
    );
  }
}

class FitnessRecordEndSplit extends StatefulWidget {
  final String? splitName;
  final int? idStartedCompleted;

  final void Function() refresh;
  final void Function() loadData;
  final void Function(String) onChanged;

  const FitnessRecordEndSplit({
    Key? key,
    required this.splitName,
    required this.idStartedCompleted,
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
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    var variablesProvider = Provider.of<VariablesProvider>(context);
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
                                    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

                                    dbSupabase.exerciseData = [];
                                    dbSupabase.splits = [];
                                    dbSupabase.boolInsertSplitStartedCompleted = true;

                                    await dbSupabase.endSplitStartedCompleted(widget.idStartedCompleted!);
                                    widget.refresh;
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
                    backgroundColor: MaterialStatePropertyAll(ColorsProvider.color_5),
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
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
          //       backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2),
          //       foregroundColor: MaterialStateProperty.all(ColorsProvider.color_8),
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
