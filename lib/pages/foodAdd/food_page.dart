// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/my_search_bar.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/nutri_intake_listview.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:provider/provider.dart';

import '../../database/fitness_database.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

const List<String> quantity = <String>[
  '1g',
  '100g',
];

class FoodRecordScreen extends StatefulWidget {
  const FoodRecordScreen({super.key});

  @override
  State<FoodRecordScreen> createState() => _FoodRecordScreenState();
}

class _FoodRecordScreenState extends State<FoodRecordScreen> {
  initState() {
    super.initState();
    load();
  }

  List<Food> foodList = [];
  bool show = false;
  List<NutriIntake> nutriIntakes = [];
  DateTime dataTime = DateTime.now();
  SearchController searchController = SearchController();
  load() async {
    calories = 0;
    protein = 0;
    carbs = 0;
    fat = 0;
    fiber = 0;
    foodList = [];

    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntakes = await dbFitness.SelectNutriIntake("${selectedDate.toString().replaceRange(10, null, "")}");
    print(selectedDate.toString().replaceRange(10, null, ""));
    for (var nutriIntake in nutriIntakes) {
      int weight = nutriIntake.weight!;
      Food? food = await dbFitness.selectSpecificFood(nutriIntake.idFood!);
      food = Food(
        idFood: food!.idFood,
        name: food.name,
        weight: weight,
        kcal: food.kcal != null ? (food.kcal! / 100 * weight).toDouble() : 0,
        protein: food.protein != null ? (food.protein! / 100 * weight).toDouble() : 0,
        carbs: food.carbs != null ? (food.carbs! / 100 * weight).toDouble() : 0,
        fat: food.fat != null ? (food.fat! / 100 * weight).toDouble() : 0,
        fiber: food.fiber != null ? (food.fiber! / 100 * weight).toDouble() : 0,
        idNutriIntake: nutriIntake.idNutriIntake,
        action: nutriIntake.action,
        createdAt: nutriIntake.createdAt,
      );
      foodList.add(food);
      calories += food.kcal!;
      protein += food.protein!;
      carbs += food.carbs!;
      fat += food.fat!;
      fiber += food.fiber!;
    }

    print("load***************");
    show = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Stack(
      children: [
        /*Positioned(
          top: 5,
          right: 30,
          child: ElevatedButton.icon(
            onPressed: () {},
            label: Text('Add new food', style: TextStyle(fontSize: 10)),
            icon: Icon(Icons.add, size: 20),
          ),
        ),*/
        Column(
          children: [
            Container(
              height: 80,
              // color: Colors.brown,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                      child: Container(
                        // color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: 135,
                            ),
                            selectedDate.toString().replaceRange(10, null, "") != now.toString().replaceRange(10, null, "")
                                ? Container(
                                    height: 35,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        selectedDate = now;
                                        load();
                                      },
                                      // icon: Icon(Icons.add_circle_outline),
                                      label: Text(
                                        'Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        // backgroundColor: WidgetStateProperty.all(ColorsProvider.color_2.withAlpha(50)),
                                        foregroundColor: WidgetStateProperty.all(ColorsProvider.color_2),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              height: 35,
                              width: 135,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      //tady****************************************************************************************************************************
                                      builder: (context) => FoodAddPage(
                                        quantity: quantity,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_circle_outline),
                                label: Text(
                                  'New food',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(ColorsProvider.color_2),
                                  foregroundColor: WidgetStateProperty.all(ColorsProvider.color_8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                ],
              ),
            ),
            MySearchBar(
              notifyParent: load,
              searchController: searchController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectedDate = selectedDate.subtract(Duration(days: 1));
                    load();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ColorsProvider.color_2,
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 30),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: 300, // Define a fixed width
                            height: 300, // Define a fixed height
                            child: DatePicker(
                              centerLeadingDate: true,
                              minDate: DateTime(2020),
                              maxDate: DateTime.now(),
                              initialDate: selectedDate,
                              selectedDate: selectedDate,
                              highlightColor: Colors.transparent,
                              splashRadius: 0,
                              onDateSelected: (value) {
                                print(value);
                                selectedDate = value;
                                load();
                                Navigator.of(context).pop(); // Close the dialog when a date is selected
                              },
                              currentDateDecoration: BoxDecoration(
                                border: Border.all(color: ColorsProvider.color_2),
                                shape: BoxShape.circle,
                              ),
                              daysOfTheWeekTextStyle: const TextStyle(color: ColorsProvider.color_2),
                              enabledCellsDecoration: const BoxDecoration(),
                              initialPickerType: PickerType.days,
                              leadingDateTextStyle: const TextStyle(color: ColorsProvider.color_2),
                              slidersColor: ColorsProvider.color_2,
                              slidersSize: 25,
                              selectedCellDecoration: BoxDecoration(
                                color: ColorsProvider.color_2,
                                shape: BoxShape.circle,
                              ),
                              selectedCellTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              disabledCellsDecoration: BoxDecoration(
                                color: Colors.transparent,
                                backgroundBlendMode: BlendMode.colorBurn,
                                shape: BoxShape.circle,
                              ),
                              currentDateTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              enabledCellsTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 120,
                    // height: 40,
                    // color: Colors.blueAccent,
                    child: Center(
                      child: Text(
                        "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}",
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorsProvider.color_2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate.toString().replaceRange(10, null, "") == now.toString().replaceRange(10, null, "")) {
                    } else {
                      selectedDate = selectedDate.add(Duration(days: 1));
                      load();
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorsProvider.color_2,
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 30),
                  ),
                ),
              ],
            ),
            Expanded(
                child: show == true
                    ? foodList.isNotEmpty
                        ? NutriIntakeListview(
                            notifyParent: load,
                            foodList: foodList,
                            quantity: quantity,
                          )
                        : Center(
                            child: Text(
                              "You have to add food",
                              style: TextStyle(
                                color: ColorsProvider.color_2,
                                fontSize: 20,
                              ),
                            ),
                          )
                    : Container()),
          ],
        ),
      ],
    );
  }

  Widget openSearchBar() {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: ColorsProvider.color_2),
        child: Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: ColorsProvider.color_8,
          ),
        ),
      ),
      onTap: () {
        searchController.openView();
      },
    );
  }
}
