import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_exercise_box.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_muscle_box.dart';
import 'package:provider/provider.dart';

import 'add_exercise_box.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    late TabController tabController;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Edit your split'),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: NewExerciseBox(),
                    );
                  },
                );
              },
              child: Text(
                "Add exercise",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Record>>(
                    future: dbHelper.Split(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No data availableeeeeeeeeee.'),
                        );
                      } else {
                        List<Record> splitData = snapshot.data!;
                        return DefaultTabController(
                          length: splitData.length,
                          initialIndex: dbHelper.initialIndex,
                          child: TabBar(
                            tabs: splitData.map((record) {
                              var i = record.idSplitu;
                              // print(i);
                              return Text(
                                "${record.nazevSplitu}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                            onTap: (int index) async {
                              dbHelper.initialIndex = index;
                              dbHelper.tab = index + 1;
                              print(
                                "číslo tabu: ${dbHelper.tab}",
                              );

                              setState(() {});
                            },
                            indicatorColor: Colors.amber,
                            // indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.amber,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  color: Colors.black,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.amber[800])),
                  icon: Icon(Icons.add),
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
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: Colors.black12,
                child: FutureBuilder<List<Record>>(
                  future: dbHelper.getSvalyForSplitId(dbHelper.tab),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Chyba: ${snapshot.error}'));
                    } else {
                      List<Record> records = snapshot.data!;
                      // Inicializace seznamu isCheckedList na základě počtu záznamů

                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return Expanded(
                            child: Container(
                              color: Colors.blue,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.amber[800],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        "${records[index].nazevSvalu}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(25, 0, 25, 5),
                                    child: Container(
                                      color: Colors.red,
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FutureBuilder<List<Record>>(
                                              future: dbHelper.Cviky(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Chyba: ${snapshot.error}'));
                                                } else {
                                                  List<Record> records =
                                                      snapshot.data!;
                                                  // Inicializace seznamu isCheckedList na základě počtu záznamů

                                                  return ListView.builder(
                                                    itemCount: records.length,
                                                    // physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30,
                                                                      color: Colors
                                                                          .green,
                                                                      width: 50,
                                                                      child: Text(
                                                                          "${records[index].nazevCviku}"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Center(
                                                          child:
                                                              AddExerciseBox(),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    "exercises",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 70,
          ),
        ],
      ),
    );
  }
}
