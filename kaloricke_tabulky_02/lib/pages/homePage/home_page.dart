// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/globals_variables/nutri_data.dart';
import 'package:provider/provider.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Domovská obrazovka'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
//deklarace dvourozměrného pole jídel
    List<List<dynamic>> listOfFood = [
      [1, 100, 'kuřecí maso', 21, 0, 1, 0, 121],
      [2, 20, 'rohlík', 1, 2, 3, 4, 90],
      [3, 30, 'protein', 21, 0, 0, 0, 100],
      [4, 150, 'brambory', 2, 35, 0, 4, 160],
      [5, 50, 'Svíčková na smetaně s hosukovým knedlíkem', 1, 5, 0, 2, 20],
      [6, 25, 'mrkev', 0, 6, 0, 3, 10],
    ];

    EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);
    final _verticalController = ScrollController();
    final nutrition = Provider.of<NutritionIncremment>(context);
    return Stack(
      children: [
        Container(
          //color: Colors.black26,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                //color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 30),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        //padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        //color: Colors.blue,
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        nutrition.incrementKcal();
                      },
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 30),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      //   border: borderBorder,
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7), // Zaoblení rohů
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
                    child: Column(
                      children: [
                        Text(
                          'Calories:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '${nutrition.kcalData}',
                          style: TextStyle(
                              fontSize: 20, color: Colors.yellowAccent),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      //   border: borderBorder,
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7), // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: Column(
                      children: [
                        Text(
                          'Protein',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '${nutrition.proteinData}',
                          style: TextStyle(
                              fontSize: 18, color: Colors.yellowAccent),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      //   border: borderBorder,
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7), // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: Column(
                      children: [
                        Text(
                          'Carbs',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '${nutrition.carbsData}',
                          style: TextStyle(
                              fontSize: 18, color: Colors.yellowAccent),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      //   border: borderBorder,
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7), // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: const Column(
                      children: [
                        Text(
                          'Fats',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'data',
                          style: TextStyle(
                              fontSize: 18, color: Colors.yellowAccent),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      //   border: borderBorder,
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(7), // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: const Column(
                      children: [
                        Text(
                          'Fiber',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'data',
                          style: TextStyle(
                              fontSize: 18, color: Colors.yellowAccent),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      nutrition.incrementKcal();
                      nutrition.incrementProtein();
                      nutrition.incrementCarbs();
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Add',
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(150, 40)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.transparent),
                        color: Colors.black12),
                    margin: const EdgeInsets.all(5),
                    //tableview 2D
                    child: Container(
                      child: TableView.builder(
                        verticalDetails: ScrollableDetails.vertical(
                            controller: _verticalController),
                        cellBuilder: (
                          BuildContext context,
                          TableVicinity vicinity,
                        ) {
                          return Row(
                            children: [
                              Container(
                                child: Text(
                                    '${listOfFood[vicinity.row][1]}g ${listOfFood[vicinity.row][2]}  B:${listOfFood[vicinity.row][3]} S:${listOfFood[vicinity.row][4]} T:${listOfFood[vicinity.row][4]} V:${listOfFood[vicinity.row][6]} Kcal:${listOfFood[vicinity.row][7]}'),
                              ),
                              InkWell(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  print('you can edit this row');
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                child: Icon(Icons.delete_outline),
                                onTap: () {
                                  print('you delete this row');
                                },
                              )
                            ],
                          );
                        },
                        columnCount: 1,
                        columnBuilder: (int index) {
                          return const TableSpan(
                            extent: FractionalTableSpanExtent(2),
                            //onEnter: (_) => print('Entered column $index'),
                          );
                        },
                        rowCount: listOfFood.length,
                        rowBuilder: (int index) {
                          return const TableSpan(
                            backgroundDecoration: TableSpanDecoration(
                              border: TableSpanBorder(
                                trailing:
                                    BorderSide(width: 1, color: Colors.amber),
                              ),
                            ),
                            extent:
                                FixedTableSpanExtent(50), //přiblížení tabulky
                            //  cursor: SystemMouseCursors.click,
                          );
                        },
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
