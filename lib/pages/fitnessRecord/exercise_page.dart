import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  final String nameOfExercise;
  final int idExercise;
  final int splitId;
  final int? idStartedCompleted;
  final int splitIndex;
  final int muscleIndex;
  final int exerciseIndex;
  final Function()? loadData;
  final Function() notifyParent;
  const ExercisePage({
    super.key,
    required this.nameOfExercise,
    required this.idExercise,
    required this.splitId,
    this.idStartedCompleted,
    required this.splitIndex,
    required this.muscleIndex,
    required this.exerciseIndex,
    this.loadData,
    required this.notifyParent,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

// double initialDragableSize = 0.1;

class _ExercisePageState extends State<ExercisePage> with WidgetsBindingObserver {
  bool showWidget = false;
  late List<ExerciseData> exerciseData;

  List<TextEditingController> weightController = [];
  List<TextEditingController> repsController = [];
  List<int> difficultyController = [];
  TextEditingController _descriptionController = TextEditingController();

  String? nameOfExercise;

  late int idExercise;

  AppLifecycleState? _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    bool paused = false;
    // Pokud je aktuální stav stejný jako poslední stav, neprovádějte nic
    if (_lastLifecycleState == state) return;

    if (state == AppLifecycleState.paused) {
      print("save immediately, app may be exit");
      if (mounted) {
        try {
          print("saved");
          await saveDataToDatabase();
          paused = true;
        } catch (e) {
          print("chyba v exercisePage při vkládání dat změněním stavu aplikace (zavřená app): $e");
        }
      } else if (state == AppLifecycleState.resumed) {
        paused = false;
      }
    }
    _lastLifecycleState = state;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("initState called");
    loadOldData();
    loadData();
  }

  late Future<int?> idSplitStartedCompleted;

  Future<void> loadData() async {
    print("load called");
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    var dataDb = await dbSupabase.exerciseData;

    // Kontrola, zda dataDb není prázdné
    if (dataDb.isNotEmpty) {
      var selectedMuscleList = dataDb[widget.splitIndex].selectedMuscle;

      // Kontrola, zda selectedMuscleList není prázdné
      if (selectedMuscleList != null && selectedMuscleList.isNotEmpty && widget.muscleIndex < selectedMuscleList.length) {
        var selectedExercisesList = selectedMuscleList[widget.muscleIndex].selectedExercises;

        // Kontrola, zda selectedExercisesList není prázdné
        if (selectedExercisesList != null && selectedExercisesList.isNotEmpty && widget.exerciseIndex < selectedExercisesList.length) {
          var exData = selectedExercisesList[widget.exerciseIndex].exercises;

          // Kontrola, zda exData není null a exData.exerciseData není prázdné
          if (exData != null && exData.exerciseData != null && exData.exerciseData!.isNotEmpty) {
            exerciseData = exData.exerciseData!;
          } else {
            print("exData je empty");
            exerciseData = List.empty(growable: true); // Ujistěte se, že seznam lze rozšířit
          }
        } else {
          print("selectedExercisesList je empty nebo neplatný index");
          exerciseData = List.empty(growable: true); // Ujistěte se, že seznam lze rozšířit
        }
      } else {
        print("selectedMuscleList je empty nebo neplatný index");
        exerciseData = List.empty(growable: true); // Ujistěte se, že seznam lze rozšířit
      }
    } else {
      print("dataDb je empty nebo neplatný index");
      exerciseData = List.empty(growable: true); // Ujistěte se, že seznam lze rozšířit
    }

    print("konečně showwidget");
    setState(() {
      showWidget = true;
    });
  }

  List<SplitStartedCompleted> oldDataFinal = [];
  loadOldData() async {
    oldDataFinal.clear();
    print("load old data");
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    List<Split> oldData = await dbSupabase.getOldExerciseData(widget.idExercise);
    print("old data ${oldData.length}");
    for (var element in oldData) {
      // print(element.nameSplit);
      for (var splitStartedCompleted in element.splitStartedCompleted!) {
        for (var element in splitStartedCompleted.exerciseData!) {
          if (element.exercisesIdExercise == widget.idExercise) {
            oldDataFinal.add(splitStartedCompleted);
            break;
          }
        }

        // print(element.createdAt);
        // for (var element in element.exerciseData!) {
        //   print(element.weight);
        // }
      }
    }
    oldDataFinal.sort((a, b) => b.idStartedCompleted!.compareTo(a.idStartedCompleted!));
    setState(() {});
  }

  saveDataToDatabase() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    var idStartedCompleted;
    //generování idStartedCompleted pokud není ... false
    if (exerciseData.isNotEmpty) {
      print("fffffffffffffffff --- ${dbSupabase.boolInsertSplitStartedCompleted}");
      if (dbSupabase.boolInsertSplitStartedCompleted == true) {
        idStartedCompleted = await dbSupabase.insertSplitStartedCompleted(widget.splitId);
      } else {
        idStartedCompleted = await widget.idStartedCompleted;
        print(idStartedCompleted);
      }

      await dbSupabase.actionExerciseData(exerciseData, idExercise, idStartedCompleted);
      var newExerciseData = await dbSupabase.exerciseData[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises.exerciseData!;
      print(newExerciseData.length);
      print(exerciseData.length);
      print("-------------------------------------------------------------------------------");
      for (var i = 0; i < newExerciseData.length; i++) {
        print(exerciseData[i].difficulty);
        exerciseData[i].idExData = newExerciseData[i].idExData;
      }
      print("-------------------------------------------------------------------------------");
      for (var i = 0; i < exerciseData.length; i++) {
        print(exerciseData[i].idExData);
        exerciseData[i].operation = 0;
      }
      // setState(() {});
      // updateExerciseData();
    }
  }

  actionExerciseRow(int idData, int value) {
    //0 nic se nestane
    //1 insert
    //2 update
    //3 delete
    //4 nebude se insertovat
    for (var i = 0; i < exerciseData.length; i++) {
      if (exerciseData[i].operation == null) {
        exerciseData[i].operation = 0;
      }
      if (idData == exerciseData[i].id) {
        if (value == 3 && exerciseData[i].operation == 1) {
          //nebude se insertrovat
          exerciseData[i].operation = 4;
        } else if (value == 2 && exerciseData[i].operation == 1) {
          //nothing, hodnota se jen insertuje
        } else {
          //
          exerciseData[i].operation = value;
        }
      }
    }
  }

  saveValues(List<ExerciseData> data) {
    //insert do tabulky split_started_completed o startu splitu
    for (var i = 0; i < exerciseData.length; i++) {
      for (var j = 0; j < data.length; j++) {
        if (data[j].id == exerciseData[i].id) {
          try {
            exerciseData[i].weight = int.parse(weightController[j].text.trim());
            exerciseData[i].reps = int.parse(repsController[j].text.trim());
            exerciseData[i].difficulty = difficultyController[j];
          } catch (e) {
            print("problém: $e");
          }
        }
      }
    }
  }

  List<ExerciseData> finalData = [];
  updateExerciseData() {
    finalData = [];
    weightController = [];
    repsController = [];
    difficultyController = [];

    for (var i = 0; i < exerciseData.length; i++) {
      print("operation: ${exerciseData[i].operation}");
      //odstranění hodnot
      if (exerciseData[i].operation == 3 || exerciseData[i].operation == 4) {
        //nothing
      } else {
        finalData.add(exerciseData[i]);
        weightController.add(TextEditingController(text: exerciseData[i].weight.toString()));
        repsController.add(TextEditingController(text: exerciseData[i].reps.toString()));
        difficultyController.add(exerciseData[i].difficulty);
      }
    }
    // int i = 1;
    // for (var element in exerciseData) {
    //   print("$i: weight: ${element.weight}, reps: ${element.reps}, difficulty: ${element.difficulty}, operation: ${element.operation}");
    //   i++;
    // }
    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    print("show widget: $showWidget");
    nameOfExercise = widget.nameOfExercise;
    idExercise = widget.idExercise;
    final _sheet = GlobalKey();
    final _controller = DraggableScrollableController();
    List<ExerciseData> finalExerciseData = updateExerciseData();

    print("final exercise data: ${finalExerciseData.length}");

    if (showWidget == false) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: ColorsProvider.color_3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${nameOfExercise}',
                style: TextStyle(fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
              ),
              // GestureDetector(
              //   child: Container(
              //       decoration: BoxDecoration(
              //         color: ColorsProvider.color_2,
              //         border: Border.all(color: ColorsProvider.color_8),
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
              //         child: Text(
              //           "Specials",
              //           style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 15),
              //         ),
              //       )),
              //   onTap: () {},
              // )
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            print("focus changed");
          },
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 30,
                                child: Center(
                                  child: Text(
                                    "Set",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    "Weight",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    "Reps",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    "difficulty",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                width: 50,
                                child: Center(
                                  child: Text(
                                    "Special",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                key: _sheet,
                // shouldCloseOnMinExtent: false,
                initialChildSize: 0.1,
                maxChildSize: 0.6,
                minChildSize: 0.1, snapAnimationDuration: Duration(milliseconds: 100),
                expand: true,
                snap: false,
                snapSizes: [
                  0.1,
                  0.6,
                ],
                // snapAnimationDuration: Duration(milliseconds: 100),
                controller: _controller,
                builder: (context, scrollController) {
                  return Stack(
                    children: [
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(123, 0, 0, 0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                height: 90,
                                // color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Swipe up',
                                        style: TextStyle(
                                          color: ColorsProvider.color_1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 25,
                                        color: ColorsProvider.color_1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // SliverList.list(
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.all(10.0),
                            //       child: Container(
                            //         // constraints: BoxConstraints(maxHeight: 150),
                            //         child: TextField(
                            //           maxLines: 8,
                            //           minLines: 2,
                            //           onTap: () {},
                            //           controller: _descriptionController,
                            //           decoration: const InputDecoration(
                            //             label: Text(
                            //               "Enter description of today split...",
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //             labelStyle: TextStyle(
                            //               color: ColorsProvider.color_1,
                            //             ),
                            //             enabledBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                 Radius.circular(12),
                            //               ),
                            //               borderSide: BorderSide(
                            //                 color: ColorsProvider.color_2,
                            //                 width: 0.5,
                            //               ),
                            //             ),
                            //             focusedBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                 Radius.circular(12),
                            //               ),
                            //               borderSide: BorderSide(
                            //                 color: ColorsProvider.color_2,
                            //                 width: 2.0,
                            //               ),
                            //             ),
                            //             contentPadding: EdgeInsets.symmetric(
                            //               vertical: 10,
                            //               horizontal: 15,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.all(10.0),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             "old values".toUpperCase(),
                            //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SliverList(
                            //   delegate: SliverChildBuilderDelegate(
                            //     childCount: splitData[widget.splitIndex].splitStartedCompleted!.length,
                            //     (BuildContext context, int splitStartedindex) {
                            //       String? rawDate = splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].createdAt!.substring(0, 25 - 15);
                            //       DateTime dateTime = DateTime.parse(rawDate);
                            //       DateFormat formatter = DateFormat('dd.MM.yyyy');
                            //       String date = formatter.format(dateTime);
                            //       return Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Container(
                            //           height: 135,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(10),
                            //             color: ColorsProvider.color_2,
                            //           ),
                            //           child: Column(
                            //             children: [
                            //               Padding(
                            //                 padding: const EdgeInsets.only(
                            //                   top: 5,
                            //                 ),
                            //                 child: Row(
                            //                   mainAxisAlignment: MainAxisAlignment.center,
                            //                   children: [
                            //                     Text(
                            //                       "$date",
                            //                       style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 20),
                            //                     )
                            //                   ],
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                            //                   child: Container(
                            //                     decoration: BoxDecoration(color: Color.fromARGB(135, 0, 0, 0), borderRadius: BorderRadius.circular(12)),
                            //                     child: Row(
                            //                       children: [
                            //                         Padding(
                            //                           padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                            //                           child: Container(
                            //                             width: 60,
                            //                             child: Column(
                            //                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                               children: [
                            //                                 Text(
                            //                                   "Set",
                            //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                            //                                 ),
                            //                                 Text(
                            //                                   "Weight",
                            //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                            //                                 ),
                            //                                 Text(
                            //                                   "Reps",
                            //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                            //                                 ),
                            //                                 SizedBox(
                            //                                   height: 2,
                            //                                 )
                            //                               ],
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         Container(
                            //                           width: 1,
                            //                           color: ColorsProvider.color_8,
                            //                         ),
                            //                         Expanded(
                            //                           child: Padding(
                            //                             padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                            //                             child: Container(
                            //                               child: ListView.builder(
                            //                                 itemCount: splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].exerciseData!.length,
                            //                                 scrollDirection: Axis.horizontal,
                            //                                 itemBuilder: (context, index) {
                            //                                   var data = splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].exerciseData![index];
                            //                                   int reps;
                            //                                   int weight;
                            //                                   int difficulty;
                            //                                   // if (DateTime.now().toString().replaceRange(10, null, '') == splits[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                            //                                   reps = data.reps;
                            //                                   weight = data.weight;
                            //                                   difficulty = data.difficulty;
                            //                                   // } else {}
                            //                                   return Padding(
                            //                                     padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                            //                                     child: Container(
                            //                                       width: 30,
                            //                                       child: Column(
                            //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //                                         children: [
                            //                                           Text(
                            //                                             "${index + 1}",
                            //                                             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                            //                                           ),
                            //                                           Text(
                            //                                             "$weight",
                            //                                             style: TextStyle(
                            //                                               fontWeight: FontWeight.bold,
                            //                                               fontSize: 16,
                            //                                               color: difficulty == 0
                            //                                                   ? Colors.white
                            //                                                   : difficulty == 1
                            //                                                       ? Colors.green
                            //                                                       : difficulty == 2
                            //                                                           ? Colors.lightGreen
                            //                                                           : difficulty == 3
                            //                                                               ? Colors.yellow
                            //                                                               : difficulty == 4
                            //                                                                   ? Colors.orange
                            //                                                                   : ColorsProvider.color_9,
                            //                                             ),
                            //                                           ),
                            //                                           Text(
                            //                                             "$reps",
                            //                                             style: TextStyle(
                            //                                               fontWeight: FontWeight.bold,
                            //                                               fontSize: 16,
                            //                                               color: difficulty == 0
                            //                                                   ? Colors.white
                            //                                                   : difficulty == 1
                            //                                                       ? Colors.green
                            //                                                       : difficulty == 2
                            //                                                           ? Colors.lightGreen
                            //                                                           : difficulty == 3
                            //                                                               ? Colors.yellow
                            //                                                               : difficulty == 4
                            //                                                                   ? Colors.orange
                            //                                                                   : ColorsProvider.color_9,
                            //                                             ),
                            //                                           ),
                            //                                           SizedBox(
                            //                                             height: 2,
                            //                                           )
                            //                                         ],
                            //                                       ),
                            //                                     ),
                            //                                   );
                            //                                 },
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         )
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 0,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                try {
                                  print("přidána položka");
                                  // weightController.add(TextEditingController(text: "0"));
                                  // repsController.add(TextEditingController(text: "0"));
                                  // difficultyController.add(0);
                                  exerciseData.add(
                                    ExerciseData(
                                      weight: 0,
                                      reps: 0,
                                      difficulty: 0,
                                      exercisesIdExercise: idExercise,
                                      operation: 1,
                                      // idStartedCompleted:
                                    ),
                                  );
                                  print(exerciseData.length);
                                  // widget.notifyParent;
                                  updateExerciseData();
                                  // setState(() {});
                                } catch (e) {
                                  print("chyba při přidávání hodnot $e");
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(50),
                                  shape: BoxShape.circle,
                                  color: ColorsProvider.color_8,
                                ),
                                child: Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: ColorsProvider.color_2,
                                  size: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return PopScope(
        onPopInvoked: (didPop) async {
          if (mounted) {
            await saveDataToDatabase();

            // widget.notifyParent;
            // widget.loadData;
            print("popscope---------------------------");
          }
          try {} on Exception catch (e) {
            print(e);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: ColorsProvider.color_2,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${nameOfExercise}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
              onPressed: () async {
                print("icon");
                // saveDataToDatabase();
                try {
                  // await widget.notifyParent;
                } on Exception catch (e) {
                  print(e);
                }

                Navigator.of(context).pop(true);
              },
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 2, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 22,
                                  child: Center(
                                    child: Text(
                                      "Set",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Weight",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Reps",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "difficulty",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 50,
                                //   child: Center(
                                //     child: Text(
                                //       "Special",
                                //       style: TextStyle(fontWeight: FontWeight.bold),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: false,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: finalExerciseData.length,
                                itemBuilder: (context, itemIndex) {
                                  int setNumber = itemIndex + 1;
                                  int difficulty = finalExerciseData[itemIndex].difficulty;
                                  return Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        // color: ColorsProvider.color_7,
                                        child: Dismissible(
                                          direction: DismissDirection.endToStart,
                                          key: ValueKey<int>(finalExerciseData[itemIndex].id),
                                          background: Container(
                                            color: ColorsProvider.color_9,
                                            child: Align(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Icon(Icons.delete),
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ),
                                          onDismissed: (direction) async {},
                                          confirmDismiss: (direction) async {
                                            await saveValues(finalExerciseData);
                                            actionExerciseRow(finalData[itemIndex].id, 3);
                                            setState(() {});
                                            return true;
                                          },
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 22,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${setNumber}",
                                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: Container(
                                                    height: 38,
                                                    child: Center(
                                                      child: TextField(
                                                        controller: weightController[itemIndex],
                                                        onTap: () {
                                                          weightController[itemIndex].selectAll();
                                                          actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                        },
                                                        onChanged: (value) {
                                                          saveValues(finalExerciseData);
                                                        },
                                                        keyboardType: TextInputType.numberWithOptions(),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(3),
                                                          FilteringTextInputFormatter.allow(
                                                            RegExp(r'[0-9]'),
                                                          )
                                                        ],
                                                        decoration: const InputDecoration(
                                                          filled: false,
                                                          fillColor: ColorsProvider.color_2,
                                                          labelStyle: TextStyle(
                                                            color: ColorsProvider.color_1,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
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
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: Container(
                                                    height: 38,
                                                    child: Center(
                                                      child: TextField(
                                                        onTap: () {
                                                          repsController[itemIndex].selectAll();
                                                          actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                        },
                                                        onChanged: (value) {
                                                          saveValues(finalExerciseData);
                                                        },
                                                        controller: repsController[itemIndex],
                                                        keyboardType: TextInputType.numberWithOptions(),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(3),
                                                          FilteringTextInputFormatter.allow(
                                                            RegExp(r'[0-9]'),
                                                          )
                                                        ],
                                                        decoration: const InputDecoration(
                                                          labelStyle: TextStyle(
                                                            color: ColorsProvider.color_1,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
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
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton2<int>(
                                                      alignment: Alignment.center,
                                                      style: TextStyle(
                                                        // color: ColorsProvider.color_8,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 5,
                                                      ),
                                                      isDense: true,
                                                      menuItemStyleData: MenuItemStyleData(
                                                        height: 37,
                                                      ),
                                                      isExpanded: true,
                                                      dropdownStyleData: DropdownStyleData(
                                                        offset: Offset(-0, -3),
                                                        elevation: 2,
                                                        // width: 90,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Color.fromARGB(195, 0, 0, 0),
                                                        ),
                                                      ),
                                                      buttonStyleData: ButtonStyleData(
                                                        height: 38,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(width: 0.5, color: ColorsProvider.color_2),
                                                        ),
                                                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                                      ),
                                                      value: difficultyController[itemIndex] == 0 ? null : difficultyController[itemIndex],
                                                      onChanged: (int? value) async {
                                                        difficultyController[itemIndex] = value ?? 0;

                                                        saveValues(finalExerciseData);
                                                        actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                        updateExerciseData();
                                                        setState(() {});
                                                      },
                                                      items: List.generate(
                                                        5,
                                                        (index) {
                                                          int difficulty = index + 1; // Začíná od 1 místo 0
                                                          return DropdownMenuItem<int>(
                                                            value: difficulty,
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              difficulty.toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
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
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   width: 50,
                                                //   child: Text("Normal"),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  key: _sheet,
                  // shouldCloseOnMinExtent: false,
                  initialChildSize: 0.1,
                  maxChildSize: 0.6,
                  minChildSize: 0.1, snapAnimationDuration: Duration(milliseconds: 100),
                  expand: true,
                  snap: false,
                  snapSizes: [
                    0.1,
                    0.6,
                  ],
                  // snapAnimationDuration: Duration(milliseconds: 100),
                  controller: _controller,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(123, 0, 0, 0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Container(
                                  height: 90,
                                  // color: Colors.amber,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Swipe up',
                                          style: TextStyle(
                                            color: ColorsProvider.color_1,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_upward_rounded,
                                          size: 25,
                                          color: ColorsProvider.color_1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // SliverList.list(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Container(
                              //         // constraints: BoxConstraints(maxHeight: 150),
                              //         child: TextField(
                              //           maxLines: 8,
                              //           minLines: 2,
                              //           onTap: () {},
                              //           controller: _descriptionController,
                              //           decoration: const InputDecoration(
                              //             label: Text(
                              //               "Enter description of today split...",
                              //               style: TextStyle(color: Colors.white),
                              //             ),
                              //             labelStyle: TextStyle(
                              //               color: ColorsProvider.color_1,
                              //             ),
                              //             enabledBorder: OutlineInputBorder(
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(12),
                              //               ),
                              //               borderSide: BorderSide(
                              //                 color: ColorsProvider.color_2,
                              //                 width: 0.5,
                              //               ),
                              //             ),
                              //             focusedBorder: OutlineInputBorder(
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(12),
                              //               ),
                              //               borderSide: BorderSide(
                              //                 color: ColorsProvider.color_2,
                              //                 width: 2.0,
                              //               ),
                              //             ),
                              //             contentPadding: EdgeInsets.symmetric(
                              //               vertical: 10,
                              //               horizontal: 15,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Text(
                              //             "old values".toUpperCase(),
                              //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: oldDataFinal.length,
                                  (BuildContext context, int splitStartedindex) {
                                    String? rawDate = oldDataFinal[splitStartedindex].createdAt!.substring(0, 25 - 15);
                                    DateTime dateTime = DateTime.parse(rawDate);
                                    DateFormat formatter = DateFormat('dd.MM.yyyy');
                                    String date = formatter.format(dateTime);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 135,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: ColorsProvider.color_2,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "$date",
                                                    style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 20),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(color: Color.fromARGB(135, 0, 0, 0), borderRadius: BorderRadius.circular(12)),
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
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                          child: Container(
                                                            child: ListView.builder(
                                                              itemCount: oldDataFinal[splitStartedindex].exerciseData!.length,
                                                              scrollDirection: Axis.horizontal,
                                                              itemBuilder: (context, index) {
                                                                var data = oldDataFinal[splitStartedindex].exerciseData![index];
                                                                int reps;
                                                                int weight;
                                                                int difficulty;
                                                                // if (DateTime.now().toString().replaceRange(10, null, '') == splits[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                                                                reps = data.reps;
                                                                weight = data.weight;
                                                                difficulty = data.difficulty;
                                                                // } else {}
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                  child: Container(
                                                                    width: 30,
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  try {
                                    print("přidána položka");
                                    // weightController.add(TextEditingController(text: "0"));
                                    // repsController.add(TextEditingController(text: "0"));
                                    // difficultyController.add(0);
                                    exerciseData.add(
                                      ExerciseData(
                                        weight: 0,
                                        reps: 0,
                                        difficulty: 0,
                                        exercisesIdExercise: idExercise,
                                        operation: 1,
                                        // idStartedCompleted:
                                      ),
                                    );

                                    // widget.notifyParent;
                                    updateExerciseData();
                                    setState(() {});
                                  } catch (e) {
                                    print("chyba při přidávání hodnot $e");
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(50),
                                    shape: BoxShape.circle,
                                    color: ColorsProvider.color_8,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: ColorsProvider.color_2,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

extension TextEditingControllerExt on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
