import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/change_new_food_box_servingSize.dart';

import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../database/fitness_database.dart';

class AddIntakePage extends StatefulWidget {
  const AddIntakePage({super.key});

  @override
  State<AddIntakePage> createState() => _AddIntakePageState();
}

class _AddIntakePageState extends State<AddIntakePage> {
  late Food food; //food na 100 gramů
  late Food recountedFood; //food na počet zadaných gramů
  late List<String> quantity;
  late bool newItem;
  bool show = false;
  bool selectSecondInfoBox = false;
  double grams = 0;

  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    // dbFitness.selectedQuantity = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Načtení argumentů
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    food = args[0];
    newItem = args[2];
    if (newItem == true) {
      food = Food(
        idFood: food.idFood!,
        name: food.name!,
        unaccentName: removeDiacritics(food.name!.toLowerCase()),
        kcal: food.kcal ?? 0,
        protein: food.protein ?? 0,
        carbs: food.carbs ?? 0,
        fat: food.fat ?? 0,
        fiber: food.fiber ?? 0,
      );
    } else {
      weightController.text = food.weight!.toString();
      food = Food(
        idFood: food.idFood!,
        name: food.name!,
        unaccentName: removeDiacritics(food.name!.toLowerCase()),
        idNutriIntake: food.idNutriIntake,
        kcal: food.kcal != null ? (food.kcal! / food.weight! * 100).toDouble() : null,
        protein: food.protein != null ? (food.protein! / food.weight! * 100).toDouble() : null,
        carbs: food.carbs != null ? (food.carbs! / food.weight! * 100).toDouble() : null,
        fat: food.fat != null ? (food.fat! / food.weight! * 100).toDouble() : null,
        fiber: food.fiber != null ? (food.fiber! / food.weight! * 100).toDouble() : null,
      );
      recountFood();
    }
    print("idNutriIntake: ${food.idNutriIntake}");
    quantity = args[1];

    show = true;
  }

  recountFood() {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    int selectedQuantity = dbFitness.selectedQuantity;
    print("selectedQuantity: $selectedQuantity");
    double weight = double.tryParse(weightController.text.trim()) ?? 0;
    recountedFood = Food(
      idFood: food.idFood,
      kcal: food.kcal != null ? ((food.kcal! / 100 * weight * 1000).round() / 1000.toDouble()) : null,
      protein: food.protein != null ? ((food.protein! / 100 * weight * 1000).round() / 1000.toDouble()) : null,
      carbs: food.carbs != null ? ((food.carbs! / 100 * weight * 1000).round() / 1000.toDouble()) : null,
      fat: food.fat != null ? ((food.fat! / 100 * weight * 1000).round() / 1000.toDouble()) : null,
      fiber: food.fiber != null ? ((food.fiber! / 100 * weight * 1000).round() / 1000.toDouble()) : null,
    );
    grams = weight;
    switch (selectedQuantity) {
      case 0:
        break;
      case 1:
        grams *= 100;
        recountedFood = Food(
          idFood: recountedFood.idFood,
          kcal: recountedFood.kcal != null ? (recountedFood.kcal! * 100).toDouble() : null,
          protein: recountedFood.protein != null ? recountedFood.protein! * 100.toDouble() : null,
          carbs: recountedFood.carbs != null ? recountedFood.carbs! * 100.toDouble() : null,
          fat: recountedFood.fat != null ? recountedFood.fat! * 100.toDouble() : null,
          fiber: recountedFood.fiber != null ? recountedFood.fiber! * 100.toDouble() : null,
        );
        break;
      default:
    }
    if (grams == 0) {
      recountedFood = food;
    } else {
      print(recountedFood.kcal);
      selectSecondInfoBox = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: show == false
          ? Placeholder()
          : ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      "${food.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      // overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                !selectSecondInfoBox ? InfoBox(food, null) : InfoBox(recountedFood, grams.toString()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      inputFoodItems(
                        "Serving size",
                        weightController,
                        100,
                        "numeric",
                        onChanged: (value) {
                          if (value == "") {
                            selectSecondInfoBox = false;
                            setState(() {});
                          } else {
                            recountFood();
                          }
                        },
                      ),
                      changeNewFoodServingSize(
                        quantity: quantity,
                        notifyParent: recountFood,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: show == true
          ? GestureDetector(
              onTap: () async {
                if (weightController.text.isEmpty) {
                  showTopSnackBar(
                    Overlay.of(context),

                    animationDuration: Duration(milliseconds: 1500),
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: CustomSnackBar.error(
                          message: "Serving size box is empty",
                        ),
                      ),
                    ),
                    // persistent: true,
                    onAnimationControllerInit: (controller) => controller,
                    displayDuration: Duration(microseconds: 750),
                    dismissType: DismissType.onSwipe,
                    dismissDirection: [DismissDirection.up, DismissDirection.horizontal],
                    reverseAnimationDuration: Duration(milliseconds: 250),
                    onTap: () {},
                  );
                } else {
                  DateTime dateTime = DateTime.now();
                  String now = dateTime.toString().replaceRange(19, null, "");
                  print(now);

                  NutriIntake nutriIntake = await NutriIntake(
                    createdAt: now,
                    weight: dbFitness.selectedQuantity == 0 ? int.parse(weightController.text.trim()) : int.parse(weightController.text.trim()) * 100,
                    idFood: recountedFood.idFood,
                    quantity: "1g",
                    action: 1,
                  );
                  print(food.idFood);
                  //Insert do Sqflite pro ofline režim
                  await dbFitness.InsertOrUpdateFood(food, 0); //action 0 protože se to nebude insertovat do supabase, tam to je a nepotřeboju duplicity
                  if (newItem == true) {
                    print("INSERT ITEM");
                    await dbFitness.InsertNutriIntake(nutriIntake, 1);
                  } else {
                    print("UPDATE ITEM");
                    print(food.idNutriIntake);
                    await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, 1);
                  }
                  // print("insert nutri intake hotový");
                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorsProvider.color_2,
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        newItem == true ? "Add" : "Update",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorsProvider.color_8,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      newItem == true
                          ? Icon(
                              Icons.add_outlined,
                              color: ColorsProvider.color_8,
                              size: 35,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget InfoBox(Food food, String? grams) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: ColorsProvider.color_2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FoodItem("", double.parse((grams ?? 100).toString()), 3),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FoodItem("Kcal", (food.kcal ?? 0), 2),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FoodItem("Protein", (food.protein ?? 0), 1),
                  SizedBox(
                    height: 15,
                  ),
                  FoodItem("Fat", (food.fat ?? 0), 1),
                ],
              ),
              Column(
                children: [
                  FoodItem("Carbs", (food.carbs ?? 0), 1),
                  SizedBox(
                    height: 15,
                  ),
                  FoodItem("Fiber", (food.fiber ?? 0), 1),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    ),
  );
}

Widget inputFoodItems(
  String labelText,
  TextEditingController item,
  double size,
  String keyboard, {
  Function(String)? onChanged, // Volitelný parametr
}) {
  return SizedBox(
    width: size,
    child: TextField(
      textAlign: TextAlign.center,
      inputFormatters: [
        // Povoluje zadat maximálně 50 znaků pro text nebo 4 znaky pro čísla
        LengthLimitingTextInputFormatter(keyboard == "text" ? 50 : 4),

        // Pokud keyboard není "text", povoluje pouze číslice
        if (keyboard != "text") FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: keyboard == "text" ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: ColorsProvider.color_1,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: ColorsProvider.color_2,
            width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: ColorsProvider.color_2,
            width: 3.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        // hintText: 'Enter name of $latelText:',
        hintStyle: const TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
      ),
      controller: item,
      onChanged: onChanged,
    ),
  );
}

Widget FoodItem(String category, double? value, int widget) {
  TextStyle textStyle = TextStyle(
    fontSize: widget == 1
        ? 20
        : widget == 2
            ? 25
            : 17,
    fontWeight: FontWeight.bold,
    color: ColorsProvider.color_8,
  );
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: widget == 1 || widget == 2
        ? Container(
            width: widget == 2 ? 250 : 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$category:",
                  style: textStyle,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${value! % 1 == 0 ? value.toInt() : ((value * 10).round() / 10) % 1 == 0 ? value.round() : value}",
                  style: textStyle,
                ),
                SizedBox(
                  width: 1,
                ),
                widget == 1
                    ? Text(
                        "g",
                        style: textStyle,
                      )
                    : Container(),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "for ${(value != null && value % 1 == 0) ? value.toInt() : value ?? 100} grams:",
                style: textStyle,
              ),
            ],
          ),
  );
}
