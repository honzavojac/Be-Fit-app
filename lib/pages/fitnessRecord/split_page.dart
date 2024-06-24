import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_exercise_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_split_box.dart';
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

  int a = 0;
  loadData(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    if (a == 0) {
      int clickedSplitTab = dbSupabase.clickedSplitTab;
      var splits = dbSupabase.splits;
      _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
      dbSupabase.getAllMuscles();
      a = 1;
      setState(() {});
    } else {
      a = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);

    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var splits = dbSupabase.splits;
    int clickedSplitTab = dbSupabase.clickedSplitTab;
    if (splits.isEmpty) {
      return PopScope(
        onPopInvoked: (didPop) {
          // print("notifyparent");

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
          // print("notifyparent");
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
                // color: ColorsProvider.color_8,
                child: DefaultTabController(
                  length: splits.length,
                  initialIndex: clickedSplitTab,
                  child: Container(
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: ColorsProvider.color_1,
                      dividerColor: ColorsProvider.color_4,
                      labelColor: ColorsProvider.color_1,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: splits.map((record) {
                        return Container(
                          height: 35,
                          constraints: BoxConstraints(
                            minWidth: 80,
                          ),
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
                      onTap: (value) {
                        dbSupabase.clickedSplitTab = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: splits[clickedSplitTab].selectedMuscle!.length,
                  itemBuilder: (context, muscleIndex) {
                    var muscle = splits[clickedSplitTab].selectedMuscle![muscleIndex];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: ColorsProvider.color_2, width: 3), color: ColorsProvider.color_7, borderRadius: BorderRadius.circular(10)),
                            height: 37,
                            child: Center(
                              child: Text(
                                muscle.muscles!.nameOfMuscle,
                                style: TextStyle(fontSize: 25, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide.none,
                                  bottom: BorderSide(color: ColorsProvider.color_2, width: 5),
                                  left: BorderSide(color: ColorsProvider.color_2, width: 5),
                                  right: BorderSide(color: ColorsProvider.color_2, width: 5),
                                ),
                                color: ColorsProvider.color_4,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    color: ColorsProvider.color_7,
                                    constraints: BoxConstraints(minHeight: 80),
                                    child: Container(
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: muscle.selectedExercises!.length,
                                        itemBuilder: (context, exerciseIndex) {
                                          var exercise = muscle.selectedExercises![exerciseIndex].exercises;
                                          return Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: ColorsProvider.color_4,
                                                          border: Border(
                                                            top: BorderSide(width: 2, color: ColorsProvider.color_2),
                                                          ),
                                                        ),
                                                        width: 50,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "${exercise.nameOfExercise}",
                                                              style: TextStyle(fontSize: 17),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                    width: double.infinity,
                                    color: ColorsProvider.color_2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(height: 40, width: double.infinity),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // dbFirebase.chosedMuscle = muscle;

                                              dbSupabase.muscleIndex = muscleIndex;
                                              // dbSupabase.generateFalseExerciseCheckbox();
                                              dbSupabase.initChecklist = 0;
                                              await dbSupabase.getFitness();
                                              setState(() {});
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: AddExerciseBox(
                                                      splitIndex: clickedSplitTab,
                                                      muscleIndex: muscleIndex,
                                                      notifyParent: refresh,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 2, color: ColorsProvider.color_8),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(25),
                                                  bottomRight: Radius.circular(25),
                                                ),
                                              ),
                                              backgroundColor: ColorsProvider.color_2,
                                            ),
                                            child: Text(
                                              "exercises",
                                              style: TextStyle(
                                                color: ColorsProvider.color_8,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
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
                                          int idSplit = splits[clickedSplitTab].idSplit!.toInt();
                                          await dbSupabase.deleteSplit(idSplit);
                                          await dbSupabase.getFitness();
                                          dbSupabase.clickedSplitTab = 0;
                                          a = 0;
                                          widget.notifyParent;
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
                              Text("Delete current split"),
                              SizedBox(width: 20),
                              Icon(Icons.delete),
                            ],
                          ),
                        )
                      : Text("You can't delete this split right now"),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
