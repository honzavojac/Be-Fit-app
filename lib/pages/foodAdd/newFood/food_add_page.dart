// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';

import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';

import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_main_add_boxes.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:provider/provider.dart';
import 'package:diacritic/diacritic.dart';

class FoodAddPage extends StatefulWidget {
  final List<String> quantity;
  const FoodAddPage({
    super.key,
    required this.quantity,
  });

  @override
  State<FoodAddPage> createState() => _FoodAddPageState();
}

TextEditingController nameController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController kcalController = TextEditingController();
TextEditingController proteinController = TextEditingController();
TextEditingController carbsController = TextEditingController();
TextEditingController fatsController = TextEditingController();
TextEditingController fiberController = TextEditingController();

class _FoodAddPageState extends State<FoodAddPage> {
  Future<bool> insertFood() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    var idUser = dbSupabase.user!.idUser;
    int selectedQuantity = dbFitness.selectedQuantity;

    DateTime dateTime = DateTime.now();
    String now = dateTime.toString().replaceRange(19, null, "");

    // String country = "CZ";
    String name = nameController.text.trim();
    int? weight = int.tryParse(weightController.text.trim().replaceAll(',', '.'));
    double? kcal = double.tryParse(kcalController.text.trim().replaceAll(',', '.')) ?? 0;
    double? protein = double.tryParse(proteinController.text.trim().replaceAll(',', '.')) ?? 0;
    double? carbs = double.tryParse(carbsController.text.trim().replaceAll(',', '.')) ?? 0;
    double? fat = double.tryParse(fatsController.text.trim().replaceAll(',', '.')) ?? 0;
    double? fiber = double.tryParse(fiberController.text.trim().replaceAll(',', '.')) ?? 0;

    if (selectedCountry != null && name.isNotEmpty && weight != null && now.isNotEmpty) {
      switch (selectedQuantity) {
        case 0:
          kcal = kcal > 0 ? (kcal / weight * 100).toDouble() : null;
          protein = protein / weight * 100.toDouble();
          carbs = carbs / weight * 100.toDouble();
          fat = fat / weight * 100.toDouble();
          fiber = fiber / weight * 100.toDouble();
          weight = 100;
          break;
        case 1:
          kcal = kcal / weight;
          protein = protein / weight;
          carbs = carbs / weight;
          fat = fat / weight;
          fiber = fiber / weight;
          weight = 100;

          break;
        default:
      }

      Food record = Food(
        country: selectedCountry,
        name: name,
        unaccentName: removeDiacritics(name.toLowerCase()),
        weight: weight,
        quantity: "1g",
        createdAt: now,
        kcal: kcal,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: fiber,
        insertedByIdUser: idUser,
      );

      print(record);

      // Insert do Supabase
      await supabase.from('food').insert(record.toJson());
      return true;
    } else {
      print('Jedna nebo více povinných hodnot chybí, záznam nebude vložen.');
      return false;
    }
  }

  clearControllers() {
    nameController.clear();
    weightController.clear();
    kcalController.clear();
    proteinController.clear();
    carbsController.clear();
    fatsController.clear();
    fiberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('header_new_food'.tr()),
            IconButton(
              onPressed: () {
                clearControllers();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: ListView(
              children: [
                foodMainAddBoxes(
                  nameController: nameController,
                  weightController: weightController,
                  kcalController: kcalController,
                  proteinController: proteinController,
                  carbsController: carbsController,
                  fatsController: fatsController,
                  fiberController: fiberController,
                  quantity: widget.quantity,
                ),
                SizedBox(
                  height: 30,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Others values',
                //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsProvider.getColor2(context)),
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                // foodSecondaryAddBoxes(),
                SizedBox(
                  height: 15,
                ),
                // VitaminsBox(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 15,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      // width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          bool inserted = await insertFood();
                          inserted ? clearControllers() : null;
                        },
                        icon: Icon(Icons.add, size: 30),
                        label: Text('add_food'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
                          foregroundColor: WidgetStateProperty.all(ColorsProvider.color_8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
