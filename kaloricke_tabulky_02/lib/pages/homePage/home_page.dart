// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/globals_variables/nutri_data.dart';
import 'package:provider/provider.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Home page'),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        ],
      ),
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
                height: 30,
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
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    border: Border.all(style: BorderStyle.none),
                    // Default border style
                  ),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      //reverse: true,
                      itemCount: listOfFood.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            //Container(
                                            //  child: Text(
                                            //    listOfFood[index])),
                                            Container(
                                              child: Text(listOfFood[index][2]),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Icon(Icons.edit),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Icon(
                                                      Icons.delete_outline),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 0.15,
                              color: Colors.amber[800],
                            )
                          ],
                        );
                      }),
                ),
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
