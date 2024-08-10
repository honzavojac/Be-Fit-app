import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_split_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_exercise_box.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../providers/colors_provider.dart';
import 'add_split_box copy.dart';
import 'new_exercise_box copy.dart';

class SplitPageCopy extends StatefulWidget {
  final Function()? notifyParent;
  final Function() loadParent;
  final int clickedSplitTab;
  final bool foundActiveSplit;

  const SplitPageCopy({
    Key? key,
    this.notifyParent,
    required this.loadParent,
    required this.clickedSplitTab,
    required this.foundActiveSplit,
  }) : super(key: key);

  @override
  State<SplitPageCopy> createState() => _SplitPageCopyState();
}

class _SplitPageCopyState extends State<SplitPageCopy> with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 0, vsync: this);
  List<TextEditingController> splitTextEditingControllers = [];
  List<TextEditingController> muscleTextEditingControllers = [];
  List<TextEditingController> exerciseTextEditingControllers = [];

  @override
  void initState() {
    super.initState();
    //
    // dbFirebase = Provider.of<FirestoreService>(context);
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    a = 0;
    setState(() {});
  }

  List<Split> splits = [];
  int a = 0;
  Map<String, List<bool>> isCheckedList = {};
  loadData() async {
    // Stopwatch stopwatch = Stopwatch()..start();
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    splits = await dbFitness.SelectAllData();
    for (var split in splits) {
      splitTextEditingControllers.add(TextEditingController(text: split.nameSplit));
    }
    if (a == 0) {
      clickedSplitTab = widget.clickedSplitTab;
      a++;
    }
    _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
    setState(() {});
    // stopwatch.stop();
    // print("tvralo to: ${stopwatch.elapsed.inMilliseconds}");
  }

  Map<int, String> updateSplits = {};
  Map<int, String> updateMuscles = {};
  Map<int, String> updateExercises = {};

  late int clickedSplitTab;
  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);

    // loadData();
    // print(splits);

    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);

    if (splits.isEmpty) {
      return PopScope(
        onPopInvoked: (didPop) {
          widget.notifyParent;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                widget.notifyParent;
                Navigator.of(context).pop(true);
              },
              icon: Icon(
                Icons.arrow_back,
                color: ColorsProvider.color_2,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit your split',
                  style: TextStyle(),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline_outlined,
                      color: ColorsProvider.color_2,
                      size: 35,
                    ),
                    onPressed: () {
                      dbSupabase.generateFalseMuscleCheckbox();
                      dbSupabase.getAllMuscles();
                      dbSupabase.clearTextController();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AddSplitBoxCopy(
                              loadParent: loadData,
                              splits: splits,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Container(
              // color: const Color.fromARGB(103, 33, 149, 243),
              ),
        ),
      );
    } else {
      return PopScope(
        onPopInvoked: (didPop) {
          widget.notifyParent;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                widget.notifyParent;
                Navigator.of(context).pop(true);
              },
              icon: Icon(
                Icons.arrow_back,
                // color: Colors.amber,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit your split',
                  style: TextStyle(),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.add_circle_outline_outlined, color: ColorsProvider.color_2, size: 35),
                    onPressed: () async {
                      dbSupabase.generateFalseMuscleCheckbox();
                      dbSupabase.getAllMuscles();
                      dbSupabase.clearTextController();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AddSplitBoxCopy(
                              loadParent: loadData,
                              splits: splits,
                            ),
                          );
                        },
                      );
                      await widget.loadParent();
                    },
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            // color: const Color.fromARGB(103, 33, 149, 243),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: DefaultTabController(
                    length: splits.length,
                    initialIndex: 0,
                    child: Container(
                      child: TabBar(
                        splashFactory: NoSplash.splashFactory,
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        indicatorColor: ColorsProvider.color_2,
                        dividerColor: ColorsProvider.color_4,
                        labelColor: ColorsProvider.color_2,
                        unselectedLabelColor: Colors.white,
                        isScrollable: true,
                        tabs: splits.map((record) {
                          return Container(
                            height: 35,
                            constraints: BoxConstraints(minWidth: 80),
                            child: IntrinsicWidth(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0), // 5px padding on each side
                                child: Center(
                                    child: Text(
                                  record.nameSplit,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                )
                                    // TextField(
                                    //   controller: splitTextEditingControllers[splits.indexOf(record)],
                                    //   readOnly: true,
                                    //   enabled: false,
                                    //   textAlign: TextAlign.center,
                                    //   decoration: InputDecoration(
                                    //     border: InputBorder.none,
                                    //   ),
                                    //   style: TextStyle(
                                    //     color: splitTextEditingControllers[splits.indexOf(record)].text != record.nameSplit ? ColorsProvider.color_2 : Colors.white, // Optional: Set the text color
                                    //     fontSize: 19, // Optional: Set the text size
                                    //   ),
                                    // ),
                                    ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: splits.map(
                      (record) {
                        // dbSupabase.clickedSplitTab = splits.indexOf(record);
                        // splitTextEditingControllers[_tabController.index] = TextEditingController(text: record.nameSplit);
                        return Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: ListView(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Container(
                                            height: 50,
                                            width: 200, // Zmenšete šířku podle potřeby
                                            // color: Colors.blue,
                                            child: Center(
                                              child: TextField(
                                                onChanged: (value) async {
                                                  clickedSplitTab = await _tabController.index;
                                                  await dbFitness.UpdateSplit(value, record.supabaseIdSplit!);
                                                  print(clickedSplitTab);
                                                  widget.loadParent();
                                                  record.nameSplit = value;
                                                },
                                                controller: splitTextEditingControllers[splits.indexOf(record)],
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: ColorsProvider.color_2,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: Colors.black, width: 2),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: Colors.black, width: 3.5),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                  ),
                                                ),
                                                cursorColor: ColorsProvider.color_8,
                                                style: TextStyle(
                                                  color: ColorsProvider.color_8,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23,
                                                ),
                                                textAlign: TextAlign.center, // Zarovnání textu na střed
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 5,
                                            decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(50)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: record.selectedMuscle!.length,
                                            itemBuilder: (context, muscleIndex) {
                                              int idSelectedMuscle = record.selectedMuscle![muscleIndex].supabaseIdSelectedMuscle!;
                                              int idMuscle = record.selectedMuscle![muscleIndex].musclesIdMuscle!;
                                              List<Exercise> exercises = record.selectedMuscle![muscleIndex].muscles!.exercises!;
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                                                child: Container(
                                                  decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(20)),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                                        child: Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            // color: ColorsProvider.color_2,
                                                            borderRadius: variablesProvider.zaobleni,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: Container(
                                                                    width: 180,
                                                                    child: TextField(
                                                                      onChanged: (value) async {
                                                                        clickedSplitTab = await _tabController.index;
                                                                        await dbFitness.UpdateMuscle(value, record.selectedMuscle![muscleIndex].muscles!.supabaseIdMuscle!);
                                                                        print(clickedSplitTab);
                                                                        widget.loadParent();
                                                                      },
                                                                      controller: TextEditingController(text: record.selectedMuscle![muscleIndex].muscles!.nameOfMuscle),
                                                                      decoration: InputDecoration(
                                                                        filled: true,
                                                                        fillColor: ColorsProvider.color_2,
                                                                        enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                                                        ),
                                                                        focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.black, width: 3.5),
                                                                        ),
                                                                        border: UnderlineInputBorder(),
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                          horizontal: 20.0,
                                                                        ),
                                                                      ),
                                                                      cursorColor: ColorsProvider.color_8,
                                                                      style: TextStyle(
                                                                        color: ColorsProvider.color_8,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 23,
                                                                      ),
                                                                      textAlign: TextAlign.center, // Zarovnání textu na střed
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  clickedSplitTab = _tabController.index;
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return Center(
                                                                          child: NewExerciseBoxCopy(
                                                                        idMuscle: idMuscle,
                                                                        loadParent: loadData,
                                                                        notifyParent: refresh,
                                                                      ));
                                                                    },
                                                                  );
                                                                },
                                                                child: Icon(
                                                                  Icons.add_circle_outline_outlined,
                                                                  color: Colors.black,
                                                                  size: 35,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 15),
                                                        child: Container(
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: exercises.length,
                                                            itemBuilder: (context, itemIndex) {
                                                              // var exercises = record.selectedMuscle![muscleIndex].muscles!.exercises;
                                                              var selectedExercises = record.selectedMuscle![muscleIndex].selectedExercises!;
                                                              String nameOfExercise = exercises[itemIndex].nameOfExercise!;
                                                              int supabaseIdExercise = exercises[itemIndex].supabaseIdExercise!;
                                                              late int order;

                                                              bool isChecked = false;

                                                              function:
                                                              for (var j = 0; j < selectedExercises.length; j++) {
                                                                // print("${exercises[itemIndex].supabaseIdExercise} == ${selectedExercises[j].exercises!.supabaseIdExercise}");
                                                                print("-- ${selectedExercises[j].action} ${selectedExercises[j].exercises!.nameOfExercise!}");
                                                                if (selectedExercises[j].action == 3) {
                                                                  // selectedExercises.removeAt(j);
                                                                } else {
                                                                  if (exercises[itemIndex].supabaseIdExercise == selectedExercises[j].exercises!.supabaseIdExercise) {
                                                                    isChecked = true;
                                                                    order = j + 1;
                                                                    break function;
                                                                  } else {
                                                                    // order = 1;
                                                                    isChecked = false;
                                                                  }
                                                                }
                                                              }
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 5),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                                                  child: Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.,
                                                                    children: [
                                                                      Expanded(
                                                                        child: TextField(
                                                                          controller: TextEditingController(text: nameOfExercise),
                                                                          onChanged: (value) async {
                                                                            clickedSplitTab = await _tabController.index;
                                                                            await dbFitness.UpdateExercise(value, supabaseIdExercise);
                                                                            print(clickedSplitTab);
                                                                            widget.loadParent();
                                                                          },
                                                                          // controller: exercisesTextEditingControllers[itemIndex],
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: ColorsProvider.color_2,
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              borderSide: BorderSide(color: Colors.black, width: 2),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              borderSide: BorderSide(color: Colors.black, width: 3.5),
                                                                            ),
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                                                          ),
                                                                          cursorColor: ColorsProvider.color_8,
                                                                          style: TextStyle(
                                                                            color: ColorsProvider.color_8,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 25, right: 5),
                                                                        child: Center(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              // print("clickedSplitTab: $clickedSplitTab");
                                                                              // print(isChecked);
                                                                              // print("action: ${exercises[itemIndex].action}");
                                                                              // print("idSelectedMuscle: $idSelectedMuscle");
                                                                              // print("exercise ${exercises[itemIndex].nameOfExercise}");
                                                                              // print("selectedExercise: ${selectedExercises}");

                                                                              clickedSplitTab = _tabController.index;
                                                                              if (isChecked == true) {
                                                                                for (var i = 0; i < selectedExercises.length; i++) {
                                                                                  if (selectedExercises[i].idExercise == exercises[itemIndex].supabaseIdExercise) {
                                                                                    print("update item");
                                                                                    if (selectedExercises[i].action == 1) {
                                                                                      print("delete ze sqflite");
                                                                                      //delete
                                                                                      await dbFitness.DeleteSelectedExercise(selectedExercises[i].idSelectedExercise!);
                                                                                    } else if (selectedExercises[i].action == 0) {
                                                                                      print("delete ze supabase");
                                                                                      // action 3 protože to potřebuju smazat ze supabase
                                                                                      print(selectedExercises[i].exercises!.nameOfExercise!);
                                                                                      print(selectedExercises[i].supabaseIdSelectedExercise);
                                                                                      await dbFitness.UpdateSelectedExercise(3, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                    }
                                                                                  }
                                                                                }
                                                                              } else if (isChecked == false) {
                                                                                funkce:
                                                                                {
                                                                                  for (var i = 0; i < selectedExercises.length; i++) {
                                                                                    if (selectedExercises[i].idExercise == exercises[itemIndex].supabaseIdExercise) {
                                                                                      print("******************");
                                                                                      print(selectedExercises[i].supabaseIdSelectedExercise);
                                                                                      print(selectedExercises[i].action);
                                                                                      print("update item na x");
                                                                                      if (selectedExercises[i].action == 0) {
                                                                                        await dbFitness.UpdateSelectedExercise(2, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                        break funkce;
                                                                                      } else if (selectedExercises[i].action == 2) {
                                                                                        //action zpátky na 0
                                                                                        await dbFitness.UpdateSelectedExercise(0, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                        break funkce;
                                                                                      } else if (selectedExercises[i].action == 3) {
                                                                                        //
                                                                                        await dbFitness.UpdateSelectedExercise(0, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                        break funkce;
                                                                                      }
                                                                                    } else {}
                                                                                  }
                                                                                  int newSupabaseIdSelectedIdExercise = 1 + (selectedExercises.isNotEmpty ? selectedExercises.last.supabaseIdSelectedExercise! : 0);
                                                                                  await dbFitness.InsertSelectedExercise(newSupabaseIdSelectedIdExercise, exercises[itemIndex].supabaseIdExercise!, idSelectedMuscle, 1);

                                                                                  print("newSupabaseIdSelectedExercise: $newSupabaseIdSelectedIdExercise");
                                                                                }
                                                                              }

                                                                              // await dbFitness.InsertSelectedExercise(2, 1, 1, 1);
                                                                              widget.loadParent();
                                                                              loadData();
                                                                            },
                                                                            child: Container(
                                                                              width: 29,
                                                                              height: 29,
                                                                              // child: Icon(Icons.check_box),
                                                                              child: isChecked == false
                                                                                  ? Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.transparent,
                                                                                        border: Border.all(
                                                                                          width: 2,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                      ),
                                                                                    )
                                                                                  : Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.black,
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        border: Border.all(
                                                                                          width: 2,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          "$order",
                                                                                          style: TextStyle(
                                                                                            fontSize: 15,
                                                                                            fontWeight: FontWeight.bold,
                                                                                            color: ColorsProvider.color_2,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //
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
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _deleteSplit(
                              context: context,
                              record: record,
                              a: a,
                              notifyParent: widget.notifyParent,
                              foundActiveSplit: widget.foundActiveSplit,
                              onPressed: () async {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                loadData();
                              },
                            )
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class _deleteSplit extends StatefulWidget {
  final BuildContext context;
  final Split record;
  int a;
  final Function? notifyParent;
  final bool foundActiveSplit;
  final Function() onPressed;
  _deleteSplit({
    super.key,
    required this.context,
    required this.record,
    required this.a,
    required this.notifyParent,
    required this.foundActiveSplit,
    required this.onPressed,
  });

  @override
  State<_deleteSplit> createState() => __deleteSplitState();
}

class __deleteSplitState extends State<_deleteSplit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
      child: Container(
        // width: 50,
        height: 45,

        child: widget.foundActiveSplit == false
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  foregroundColor: ColorsProvider.color_6,
                  backgroundColor: ColorsProvider.color_5,
                ),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      backgroundColor: ColorsProvider.color_2,
                      content: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Do you want delete this split?',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                Text('Data of exercises will stay save in app')
                              ],
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(ColorsProvider.color_8),
                                foregroundColor: MaterialStatePropertyAll(
                                  ColorsProvider.color_1,
                                ),
                              ),
                              onPressed: () async {
                                widget.onPressed();
                              },
                              child: Text("yes"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Delete ${widget.record.nameSplit} split"),
                    SizedBox(width: 20),
                    Icon(Icons.delete),
                  ],
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  foregroundColor: ColorsProvider.color_6,
                  backgroundColor: ColorsProvider.color_5,
                  disabledForegroundColor: ColorsProvider.color_6,
                  disabledBackgroundColor: ColorsProvider.color_5.withOpacity(0.35), // Barva pozadí, když je tlačítko deaktivováno
                ),
                onPressed: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You can't delete ${widget.record.nameSplit.toUpperCase()} right now"),
                    // SizedBox(width: 20),
                    // Icon(Icons.delete),
                  ],
                ),
              ),
      ),
    );
  }
}
/*
Widget _deleteSplit() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
    child: Container(
      // width: 50,
      height: 45,

      child: == true
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                foregroundColor: ColorsProvider.color_6,
                backgroundColor: ColorsProvider.color_5,
              ),
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 5),
                    backgroundColor: ColorsProvider.color_2,
                    content: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Do you want delete this split?',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text('Data of exercises will stay save in app')
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(ColorsProvider.color_8),
                              foregroundColor: MaterialStatePropertyAll(
                                ColorsProvider.color_1,
                              ),
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              int idSplit = record.idSplit!;
                              await dbSupabase.deleteSplit(idSplit);
                              await dbSupabase.getFitness();
                              dbSupabase.clickedSplitTab = 0;
                              a = 0;
                              notifyParent;
                              setState(() {});
                            },
                            child: Text("yes"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Delete ${record.nameSplit} split"),
                  SizedBox(width: 20),
                  Icon(Icons.delete),
                ],
              ),
            )
          : Text("You can't delete this split right now"),
    ),
  );
}

*/