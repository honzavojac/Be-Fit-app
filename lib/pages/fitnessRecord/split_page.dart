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
                              // dbHelper.notList();

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
                  future: dbHelper.getSvalyFromSplitId(dbHelper.tab),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Chyba: ${snapshot.error}'));
                    } else {
                      List<Record> records = snapshot.data!;
                      dbHelper.temphledaniSpravnehoSvalu =
                          dbHelper.hledaniSpravnehoSvalu;
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          dbHelper.hledaniSpravnehoSvalu =
                              records[index].idSvalu;
                          // print(dbHelper.temphledaniSpravnehoSvalu);
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 250,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 0, 25, 5),
                                      child: Expanded(
                                        child: Container(
                                          color: Colors.red,
                                          height: 200,
                                          child: Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child:
                                                    FutureBuilder<List<Record>>(
                                                  future: dbHelper.SvalCvik(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                          child: Text(
                                                              'Chyba: ${snapshot.error}'));
                                                    } else {
                                                      List<Record> records =
                                                          snapshot.data!;
                                                      dbHelper.hledaniSpravnehoSvalu =
                                                          dbHelper
                                                              .temphledaniSpravnehoSvalu;
                                                      return ListView.builder(
                                                        itemCount:
                                                            records.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          print(dbHelper
                                                              .hledaniSpravnehoSvalu);
                                                          return Container(
                                                            color: Colors.brown,
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
                                                                        width:
                                                                            50,
                                                                        child: Text(
                                                                            "${records[index].nazevCviku}"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.delete),
                                                                        iconSize:
                                                                            20,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
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
                                                      onPressed: () async {
                                                        print(
                                                            "nazev_svalu: ${records[index].nazevSvalu}");

                                                        dbHelper.hledaniSpravnehoSvalu =
                                                            await dbHelper
                                                                .getIdSvaluFromName(
                                                                    records[index]
                                                                        .nazevSvalu);
                                                        dbHelper.selectedValue =
                                                            records[index]
                                                                .nazevSvalu;

                                                        setState(() {});
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
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
