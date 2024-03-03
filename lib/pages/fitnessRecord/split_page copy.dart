import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/add_muscle_box.dart';
import 'package:provider/provider.dart';

import '../../colors_provider.dart';
import 'add_exercise_box.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  var dbFirebase = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
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
      body: Container(
        child: FutureBuilder(
          future: dbFirebase.getSplits(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorsProvider.color_2,
                  ),
                ),
              );
            } else {
              List splitData = snapshot.data!;
              return Container(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: splitData.length,
                      initialIndex: dbHelper.InitialIndex(),
                      child: TabBar(
                        // controller: dbHelper.InitialIndex(),
                        tabs: splitData.map((record) {
                          return Text(
                            "${record.nazevSplitu}",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                        onTap: (int index) {
                          dbHelper.initialIndex = index;
                          dbHelper.tab = index + 1;
                          print(
                            "číslo tabu: ${dbHelper.tab} index: ${dbHelper.initialIndex}",
                          );
                          // dbHelper.notList();

                          setState(() {});
                        },
                        // controller: dbHelper.notList(),
                        indicatorColor: ColorsProvider.color_1,

                        dividerColor: ColorsProvider.color_4,
                        labelColor: ColorsProvider.color_1,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorsProvider.color_7,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FutureBuilder<List<Record>>(
                            future: dbHelper.getSvalyFromSplitId(dbHelper.tab),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Chyba: ${snapshot.error}'));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsProvider.color_2,
                                    ),
                                  ),
                                );
                              } else {
                                print(
                                    "${dbHelper.hledaniSpravnehoSvalu}aaaaaaaaaaaaaaaa ${dbHelper.temphledaniSpravnehoSvalu} aaaaaaaaaaaaaaa");
                                List<Record> records = snapshot.data!;
                                dbHelper.temphledaniSpravnehoSvalu =
                                    dbHelper.hledaniSpravnehoSvalu;
                                return ListView.builder(
                                  itemCount: records.length,
                                  itemBuilder: (context, index) {
                                    dbHelper.hledaniSpravnehoSvalu =
                                        records[index].idSvalu;
                                    // print(dbHelper.temphledaniSpravnehoSvalu);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        ColorsProvider.color_2,
                                                    width: 3),
                                                color: ColorsProvider.color_7,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            height: 37,
                                            child: Center(
                                              child: Text(
                                                "${records[index].nazevSvalu}",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color:
                                                        ColorsProvider.color_1,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 20, 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide.none,
                                                  bottom: BorderSide(
                                                      color: ColorsProvider
                                                          .color_2,
                                                      width: 5),
                                                  left: BorderSide(
                                                      color: ColorsProvider
                                                          .color_2,
                                                      width: 5),
                                                  right: BorderSide(
                                                      color: ColorsProvider
                                                          .color_2,
                                                      width: 5),
                                                ),
                                                color: ColorsProvider.color_4,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(30),
                                                    bottomRight:
                                                        Radius.circular(30)),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    color:
                                                        ColorsProvider.color_7,
                                                    height: 160,
                                                    child: FutureBuilder<
                                                        List<Record>>(
                                                      future:
                                                          dbHelper.SvalCvik(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Center(
                                                              child: Text(
                                                                  'Chyba: ${snapshot.error}'));
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container(
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    ColorsProvider
                                                                        .color_2,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          List<Record> records =
                                                              snapshot.data!;
                                                          dbHelper.hledaniSpravnehoSvalu =
                                                              dbHelper
                                                                  .temphledaniSpravnehoSvalu;
                                                          return Container(
                                                            child: ListView
                                                                .builder(
                                                              reverse: true,
                                                              itemCount: records
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                print(dbHelper
                                                                    .hledaniSpravnehoSvalu);
                                                                return Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Container(
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
                                                                                    "${records[index].nazevCviku}",
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
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 5,
                                                    width: double.infinity,
                                                    color:
                                                        ColorsProvider.color_2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: ConstrainedBox(
                                                          constraints: BoxConstraints
                                                              .tightFor(
                                                                  height: 40,
                                                                  width: double
                                                                      .infinity),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
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
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Center(
                                                                    child:
                                                                        AddExerciseBox(),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 2,
                                                                    color: ColorsProvider
                                                                        .color_8), // nastavte šířku a barvu ohraničení

                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          25),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  ColorsProvider
                                                                      .color_2,
                                                            ),
                                                            child: Text(
                                                              "exercises",
                                                              style: TextStyle(
                                                                color:
                                                                    ColorsProvider
                                                                        .color_8,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Do you want delete this split?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Text(
                                              'Data of exercises will stay save in app')
                                        ],
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black),
                                          foregroundColor:
                                              MaterialStatePropertyAll(
                                            ColorsProvider.color_1,
                                          ),
                                        ),
                                        onPressed: () async {
                                          print(
                                              "delete split tab ${dbHelper.tab}");
                                          print(
                                              "delete split initialIndex ${dbHelper.initialIndex}");
                                          if (dbHelper.initialIndex >= 0) {
                                            if (dbHelper.initialIndex <= 0 ||
                                                dbHelper.tab <= 1) {
                                              dbHelper.initialIndex = 0;
                                              dbHelper.tab = 1;
                                            }
                                            await dbHelper.DeleteSplit();
                                            if (dbHelper.tab > 1) {
                                              dbHelper.initialIndex--;
                                              dbHelper.tab--;
                                            } else {
                                              dbHelper.initialIndex = 0;
                                              dbHelper.tab = 1;
                                            }
                                          }
                                          dbHelper.hledaniSpravnehoSvalu = 0;

                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
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
          },
        ),
      ),
    );
  }
}
