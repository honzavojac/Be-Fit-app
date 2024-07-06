import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_split_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_exercise_box.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../providers/colors_provider.dart';

class SplitPage extends StatefulWidget {
  final Function()? notifyParent;
  const SplitPage({Key? key, this.notifyParent}) : super(key: key);

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 0, vsync: this);

  @override
  void initState() {
    super.initState();
    //
    // dbFirebase = Provider.of<FirestoreService>(context);
    // loadData();
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

  late List<Split> splits;
  int a = 0;
  Map<String, List<bool>> isCheckedList = {};
  loadData(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    if (a == 0) {
      int clickedSplitTab = dbSupabase.clickedSplitTab;
      splits = dbSupabase.splits.reversed.toList();
      _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
      // _tabController.addListener(_handleTabSelection);
      dbSupabase.getAllMuscles();
      // generateIsCheckedList(context);
      a = 1;
      // for (var i = 0; i < splits.length; i++) {
      //   splitTextEditingControllers.add(TextEditingController(text: splits[i].nameSplit));
      // }

      setState(() {});
    } else {
      a = 0;
    }
  }

  // late List<TextEditingController> splitTextEditingControllers;
  // late List<TextEditingController> muscleTextEditingControllers;
  // late List<TextEditingController> exerciseTextEditingControllers;

  Map<int, String> updateSplits = {};
  Map<int, String> updateMuscles = {};
  Map<int, String> updateExercises = {};

  void upsertToMap(Map<int, String> map, int id, String name) {
    if (map.containsKey(id)) {
      map[id] = name;
    } else {
      map[id] = name;
    }
  }

  saveText(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    for (var entry in updateSplits.entries) {
      int id = entry.key;
      String name = entry.value;
      await dbSupabase.updateSplit(id, name);
    }
    updateSplits = {};
  }

  late int clickedSplitTab;
  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);

    loadData(context);

    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var splits = dbSupabase.splits;
    clickedSplitTab = dbSupabase.clickedSplitTab;
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
                            child: AddSplitBox(
                              notifyParent: refresh,
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
                    onPressed: () {
                      dbSupabase.generateFalseMuscleCheckbox();
                      dbSupabase.getAllMuscles();
                      dbSupabase.clearTextController();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AddSplitBox(
                              notifyParent: refresh,
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
          body: Column(
            children: [
              Container(
                width: double.infinity,
                child: DefaultTabController(
                  length: splits.length,
                  initialIndex: clickedSplitTab,
                  child: Container(
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      indicatorColor: ColorsProvider.color_2,
                      dividerColor: ColorsProvider.color_4,
                      labelColor: ColorsProvider.color_2,
                      isScrollable: true,
                      tabs: splits.map((record) {
                        return Container(
                          height: 35,
                          constraints: BoxConstraints(minWidth: 80),
                          child: Center(
                            child: Text(
                              "${record.nameSplit}",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
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
                                                dbSupabase.clickedSplitTab = await _tabController.index;
                                                upsertToMap(updateSplits, record.idSplit!, value);
                                              },
                                              controller: TextEditingController(text: record.nameSplit),
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
                                            var muscle = record.selectedMuscle![muscleIndex];
                                            var exercises = record.selectedMuscle![muscleIndex].muscles!.exercises;
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
                                                                    onChanged: (value) {
                                                                      // Vaše logika zde
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
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return Center(
                                                                        child: NewExerciseBox(
                                                                      splitIndex: _tabController.index,
                                                                      muscleIndex: muscleIndex,
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
                                                          itemCount: exercises!.length,
                                                          itemBuilder: (context, itemIndex) {
                                                            var selectedExercises = record.selectedMuscle![muscleIndex].selectedExercises;
                                                            String nameOfExercise = exercises[itemIndex].nameOfExercise;
                                                            late int order;
                                                            bool isChecked = false;

                                                            function:
                                                            for (var j = 0; j < selectedExercises!.length; j++) {
                                                              if (exercises[itemIndex].nameOfExercise == selectedExercises[j].exercises!.nameOfExercise) {
                                                                isChecked = true;
                                                                order = j + 1;
                                                                break function;
                                                              } else {
                                                                isChecked = false;
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
                                                                        // onChanged: (value) {
                                                                        //   updateExercises![muscleIndex]![itemIndex] = true;
                                                                        // },
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
                                                                            dbSupabase.clickedSplitTab = await _tabController.index;
                                                                            await saveText(context);
                                                                            // !isCheckedList["${muscle.nameOfMuscle}"]![itemIndex];
                                                                            await dbSupabase.updateSelectedExercise(
                                                                              exercises[itemIndex].idExercise!,
                                                                              exercises[itemIndex].nameOfExercise,
                                                                              !isChecked,
                                                                              muscle.idSelectedMuscle!,
                                                                              _tabController.index,
                                                                              muscleIndex,
                                                                              itemIndex,
                                                                            );

                                                                            setState(() {});
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
                            dbSupabase: dbSupabase,
                            record: record,
                            a: a,
                            notifyParent: widget.notifyParent,
                            onPressed: () async {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              int idSplit = record.idSplit!;
                              await dbSupabase.deleteSplit(idSplit);
                              await dbSupabase.getFitness();
                              dbSupabase.clickedSplitTab = 0;
                              a = 0;
                              widget.notifyParent;
                              setState(() {});
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
      );
    }
  }
}

class _deleteSplit extends StatefulWidget {
  final BuildContext context;
  final SupabaseProvider dbSupabase;
  final Split record;
  int a;
  final Function? notifyParent;
  final Function() onPressed;
  _deleteSplit({super.key, required this.context, required this.dbSupabase, required this.record, required this.a, required this.notifyParent, required this.onPressed});

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

        child: widget.dbSupabase.boolInsertSplitStartedCompleted == true
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
            : Text("You can't delete this split right now"),
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

      child: dbSupabase.boolInsertSplitStartedCompleted == true
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
