import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_exercise_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_muscle_box.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../providers/colors_provider.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

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

  loadData() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    int clickedSplitTab = dbSupabase.clickedSplitTab;
    var splits = dbSupabase.splits;
    _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
  }

  @override
  Widget build(BuildContext context) {
    loadData();

    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var splits = dbSupabase.splits;
    int clickedSplitTab = dbSupabase.clickedSplitTab;
    print('split_length:${splits.length}');
    if (splits.isEmpty) {
      return Scaffold(
        appBar: AppBar(
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AddMuscleBox(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AddMuscleBox(),
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
              // color: Colors.blue,
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
                itemCount: splits[clickedSplitTab].splitMuscles!.length,
                itemBuilder: (context, muscleIndex) {
                  String muscle = splits[clickedSplitTab].splitMuscles![muscleIndex].muscles.nameOfMuscle;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: ColorsProvider.color_2, width: 3), color: ColorsProvider.color_7, borderRadius: BorderRadius.circular(10)),
                          height: 37,
                          child: Center(
                            child: Text(
                              muscle,
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
                                      itemCount: splits[clickedSplitTab].splitMuscles![muscleIndex].muscles.exercises!.length,
                                      itemBuilder: (context, exerciseIndex) {
                                        String exercise = splits[clickedSplitTab].splitMuscles![muscleIndex].muscles.exercises![exerciseIndex].nameOfExercise;
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
                                                            "$exercise",
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

                                            setState(() {});
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: AddExerciseBox(),
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

                child: TextButton(
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
                                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                                  foregroundColor: MaterialStatePropertyAll(
                                    ColorsProvider.color_1,
                                  ),
                                ),
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  setState(() {});
                                },
                                child: Text("yes"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return null;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Delete current split"),
                      SizedBox(width: 20),
                      Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
/*Container(
              color: Colors.blue,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 100,
                      color: Colors.amber[800],
                      child: Center(
                        child: Text(
                          list[index]["name"],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),*/