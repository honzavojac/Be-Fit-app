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
  var dbFirebase = FirestoreService();
  List<Map<String, dynamic>> listSplits = [];
  List<Map<String, dynamic>> listMuscles = [];
  late int clickedValue = 0;
  // late TabController _tabController;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    listSplits = await dbFirebase.getSplits();
    listMuscles =
        await dbFirebase.getSplitMuscles(listSplits[clickedValue]["name"]);
    print(listSplits);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // loadData(); // musí být tady pro aktualizaci listu splitů
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
                icon: Icon(Icons.add_circle_outline_outlined,
                    color: ColorsProvider.color_2, size: 35),
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
          if (snapshot.data == null || snapshot.data!.isEmpty) {
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
                          style: TextStyle(
                              fontSize: 20, color: ColorsProvider.color_1),
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
                            icon: Icon(Icons.add_circle_outline_outlined,
                                color: ColorsProvider.color_2, size: 50),
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
                    initialIndex: 0,
                    child: Container(
                      child: TabBar(
                        // controller: _tabController,
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
                          clickedValue = value;
                          print(value);
                          setState(() {});
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorsProvider.color_2, width: 3),
                                  color: ColorsProvider.color_7,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 37,
                              child: Center(
                                child: Text(
                                  listMuscles[index]["name"],
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: ColorsProvider.color_1,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide.none,
                                    bottom: BorderSide(
                                        color: ColorsProvider.color_2,
                                        width: 5),
                                    left: BorderSide(
                                        color: ColorsProvider.color_2,
                                        width: 5),
                                    right: BorderSide(
                                        color: ColorsProvider.color_2,
                                        width: 5),
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
                                      height: 160,
                                      child: Container(
                                        child: ListView.builder(
                                          reverse: true,
                                          itemCount: listMuscles.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                ColorsProvider
                                                                    .color_4,
                                                            border: Border(
                                                              top: BorderSide(
                                                                  width: 2,
                                                                  color: ColorsProvider
                                                                      .color_2),
                                                            ),
                                                          ),
                                                          width: 50,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${listMuscles[index]["name"]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                                    height: 40,
                                                    width: double.infinity),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {});
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Center(
                                                      child: AddExerciseBox(),
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: ColorsProvider
                                                          .color_8), // nastavte šířku a barvu ohraničení

                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorsProvider.color_2,
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
                )
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