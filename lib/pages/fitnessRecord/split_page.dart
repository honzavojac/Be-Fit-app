import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_exercise_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_muscle_box.dart';
import 'package:provider/provider.dart';

import '../../colors_provider.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> with TickerProviderStateMixin {
  late FirestoreService dbFirebase;
  List<Map<String, dynamic>> listSplits = [];
  List<Map<String, dynamic>> listMuscles = [];
  List<Map<String, dynamic>> listExercises = [];
  late int clickedTab = 0;
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
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadData() async {
    var dbFirebase = await Provider.of<FirestoreService>(context, listen: false);

    listSplits = await dbFirebase.getSplits();
    _tabController = await TabController(length: listSplits.length, vsync: this, initialIndex: clickedTab);
    listMuscles = await dbFirebase.getSplitMuscles(listSplits[clickedTab]["name"]);
    listExercises = await dbFirebase.getSplitExercises(listSplits[clickedTab]["name"], listMuscles);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

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
      body: FutureBuilder(
        future: dbFirebase.getSplits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorsProvider.color_2,
                ),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'You have to click this',
                          style: TextStyle(fontSize: 20, color: ColorsProvider.color_1),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 45,
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.add_circle_outline_outlined, color: ColorsProvider.color_2, size: 50),
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
                        Text(
                          'for create new split',
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorsProvider.color_1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  // color: Colors.blue,
                  child: DefaultTabController(
                    length: listSplits.length,
                    initialIndex: clickedTab,
                    child: Container(
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: ColorsProvider.color_1,
                        dividerColor: ColorsProvider.color_4,
                        labelColor: ColorsProvider.color_1,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: listSplits.map((record) {
                          return Container(
                            height: 35,
                            constraints: BoxConstraints(
                              minWidth: 80,
                            ),
                            child: Center(
                              child: Text(
                                "${record["name"]}",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onTap: (value) {
                          clickedTab = value;

                          loadData();
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
                    itemCount: listMuscles.length,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> filteredExercises = [];
                      filteredExercises = listExercises.where((exercise) => exercise['muscleName'] == listMuscles[index]["name"]).toList();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: ColorsProvider.color_2, width: 3), color: ColorsProvider.color_7, borderRadius: BorderRadius.circular(10)),
                              height: 37,
                              child: Center(
                                child: Text(
                                  listMuscles[index]["name"],
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
                                      // height: 160,
                                      constraints: BoxConstraints(minHeight: 80),
                                      child: Container(
                                        child: ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          reverse: true,
                                          itemCount: filteredExercises.length,
                                          itemBuilder: (context, index) {
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
                                                                "${filteredExercises[index]["exerciseName"]}",
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
                                                dbFirebase.chosedMuscle = listMuscles[index]["name"];
                                                dbFirebase.splitName = listSplits[clickedTab]["name"];
                                                // print(dbFirebase.chosedMuscle);
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
                                      dbFirebase.deleteSplit(listSplits[clickedTab]["name"]);
                                      loadData();
                                      setState(() {});
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
            );
          }
        },
      ),
    );
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