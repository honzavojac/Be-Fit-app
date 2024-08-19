// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/date_row.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'data_boxes.dart';

DateTime selectedDate = DateTime.now();
double calories = 0;
double protein = 0;
double carbs = 0;
double fat = 0;
double fiber = 0;

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NutriIntake> nutriIntakes = [];
  load() async {
    calories = 0;
    protein = 0;
    carbs = 0;
    fat = 0;
    fiber = 0;

    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntakes = await dbFitness.SelectNutriIntake("${selectedDate.toString().replaceRange(10, null, "")}");
    print(selectedDate.toString().replaceRange(10, null, ""));
    for (var nutriIntake in nutriIntakes) {
      print(nutriIntake);
      if (nutriIntake.action == 3) {
      } else {
        print(nutriIntake.action);

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
          intakeCategory: nutriIntake.intakeCategory,
          action: nutriIntake.action,
          createdAt: nutriIntake.createdAt,
        );
        print(food.action);
        calories += food.kcal!;
        protein += food.protein!;
        carbs += food.carbs!;
        fat += food.fat!;
        fiber += food.fiber!;
      }
    }
    print("load***************");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  // void printNavigationStack(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Provider.of<SupabaseProvider>(context);

    return Container(
      child: Column(
        children: [
          Container(
            height: 80,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
          ),
          dateRow(
            back: () {
              selectedDate = selectedDate.subtract(Duration(days: 1));
              load();
            },
            forward: () {
              if (selectedDate.toString().replaceRange(10, null, "") == now.toString().replaceRange(10, null, "")) {
              } else {
                selectedDate = selectedDate.add(Duration(days: 1));
                load();
              }
            },
            onDateSelected: (value) {
              print(value);
              selectedDate = value;
              load();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          dataBoxes(calories, protein, carbs, fat, fiber),
        ],
      ),
    );
  }
}
