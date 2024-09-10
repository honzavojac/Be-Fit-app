import 'package:diacritic/diacritic.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/change_new_food_box_servingSize.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';

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
  late List<IntakeCategories> intakeCategories;
  bool show = false;
  bool selectSecondInfoBox = false;
  double grams = 0;

  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
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
        action: food.action,
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
        action: food.action,
      );
      recountFood();
    }
    quantity = args[1];
    intakeCategories = args[3];

    show = true;
  }

  recountFood() {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    int selectedQuantity = dbFitness.selectedQuantity;
    // print("selectedQuantity: $selectedQuantity");
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
          : Column(
              children: [
                Expanded(
                  child: ListView(
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
                      !selectSecondInfoBox
                          ? InfoBox(
                              food,
                              null,
                              context,
                            )
                          : InfoBox(
                              recountedFood,
                              grams.toString(),
                              context,
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectFoodCategory(
                              intakeCategories: intakeCategories,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            inputFoodItems(
                              "serving_size".tr(),
                              weightController,
                              130,
                              "numeric",
                              context,
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
                ),
                Container(
                  child: Center(
                    child: Text(
                      newItem == true
                          ? "${food.name} ${"insert_text".tr()} ${selectedDate.toString().replaceRange(0, 8, "").replaceRange(2, null, "")}.${selectedDate.toString().replaceRange(0, 5, "").replaceRange(2, null, "")}.${selectedDate.toString().replaceRange(4, null, "")}  "
                          : "${food.name} ${"update_text".tr()} ${selectedDate.toString().replaceRange(0, 8, "").replaceRange(2, null, "")}.${selectedDate.toString().replaceRange(0, 5, "").replaceRange(2, null, "")}.${selectedDate.toString().replaceRange(4, null, "")}  ",
                      style: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                    ),
                  ),
                )
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

                  NutriIntake nutriIntake = await NutriIntake(
                    createdAt: now,
                    weight: dbFitness.selectedQuantity == 0 ? int.parse(weightController.text.trim()) : int.parse(weightController.text.trim()) * 100,
                    idFood: recountedFood.idFood,
                    intakeCategory: dbFitness.selectedIntakeCategoryValue,
                    quantity: "1g",
                    action: 1,
                  );
                  print("intakeCategory: ${dbFitness.selectedIntakeCategoryValue}");
                  // Insert do Sqflite pro ofline režim
                  await dbFitness.InsertOrUpdateFood(food, 0); //action 0 protože se to nebude insertovat do supabase, tam to je a nepotřeboju duplicity
                  if (newItem == true) {
                    print("INSERT ITEM");
                    NutriIntake? lastSupabaseIdNutriIntake = await dbFitness.SelectLastNutriIntake();
                    int newSupabaseIdNutriIntake = (lastSupabaseIdNutriIntake?.supabaseIdNutriIntake ?? 0) + 1;

                    print(now.toString());
                    print(selectedDate.toString());

                    if (selectedDate.toString().replaceRange(10, null, "") == now.toString().replaceRange(10, null, "")) {
                      await dbFitness.InsertNutriIntake(nutriIntake, newSupabaseIdNutriIntake, 1);
                    } else {
                      nutriIntake.createdAt = selectedDate.toString();
                      await dbFitness.InsertNutriIntake(nutriIntake, newSupabaseIdNutriIntake, 1);
                    }
                  } else {
                    print("UPDATE ITEM");
                    print(food.action);
                    switch (food.action) {
                      case 0 || null:
                        await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, selectedDate.toString(), 2);
                        break;
                      case 1:
                        await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, selectedDate.toString(), 1);
                        break;
                      case 2:
                        await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, selectedDate.toString(), 2);

                        break;
                      case 3:
                        // nenastane
                        break;
                      default:
                        print("action nesedí: ${food.action}");
                    }
                  }
                  print("insert nutri intake hotový");

                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorsProvider.getColor2(context),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        newItem == true ? "add_nutri_intake".tr() : "update_nutri_intake".tr(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorsProvider.getColor8(context),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      newItem == true
                          ? Icon(
                              Icons.add_outlined,
                              color: ColorsProvider.getColor8(context),
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

Widget InfoBox(
  Food food,
  String? grams,
  BuildContext context,
) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: ColorsProvider.getColor2(context),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FoodItem("", double.parse((grams ?? 100).toString()), 3, context),
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
                      FoodItem("Kcal", (food.kcal ?? 0), 2, context),
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
                  FoodItem("protein".tr(), (food.protein ?? 0), 1, context),
                  SizedBox(
                    height: 15,
                  ),
                  FoodItem("fat".tr(), (food.fat ?? 0), 1, context),
                ],
              ),
              Column(
                children: [
                  FoodItem("carbs".tr(), (food.carbs ?? 0), 1, context),
                  SizedBox(
                    height: 15,
                  ),
                  FoodItem("fiber".tr(), (food.fiber ?? 0), 1, context),
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
  String keyboard,
  BuildContext context, {
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
        labelStyle: TextStyle(
          color: ColorsProvider.getColor2(context),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: ColorsProvider.getColor2(context),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: ColorsProvider.getColor2(context),
            width: 3.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        // hintText: 'Enter name of $latelText:',
        hintStyle: TextStyle(color: ColorsProvider.getColor2(context), fontSize: 15), // zobrazí se pokud je textové pole prázdné
      ),
      controller: item,
      onChanged: onChanged,
    ),
  );
}

Widget FoodItem(String category, double? value, int widget, BuildContext context) {
  TextStyle textStyle = TextStyle(
    fontSize: widget == 1
        ? 20
        : widget == 2
            ? 25
            : 17,
    fontWeight: FontWeight.bold,
    color: ColorsProvider.getColor8(context),
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
                  width: 5,
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
                "${"for_intake".tr()} ${(value != null && value % 1 == 0) ? value.toInt() : value ?? 100} ${"grams".tr()}:",
                style: textStyle,
              ),
            ],
          ),
  );
}

class SelectFoodCategory extends StatefulWidget {
  final List<IntakeCategories> intakeCategories;
  const SelectFoodCategory({
    super.key,
    required this.intakeCategories,
  });

  @override
  State<SelectFoodCategory> createState() => _SelectFoodCategoryState();
}

class _SelectFoodCategoryState extends State<SelectFoodCategory> {
  List<String> names = [];
  String selectedValue = "";
  bool show = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  load() {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    names = [];
    for (var intakeCategory in widget.intakeCategories) {
      names.add(intakeCategory.name!);
    }
    show = true;
    funkce:
    for (var i = 0; i < widget.intakeCategories.length; i++) {
      IntakeCategories intakeCategory = widget.intakeCategories[i];
      if (widget.intakeCategories[i].supabaseIdIntakeCategory == dbFitness.selectedIntakeCategoryValue) {
        selectedValue = intakeCategory.name!;
        break funkce;
      } else {
        selectedValue = names[0];
      }
    }

    widget.intakeCategories.forEach(
      (element) {
        if (element.name == selectedValue) {
          dbFitness.selectedIntakeCategoryValue = element.supabaseIdIntakeCategory!;
          print(dbFitness.selectedIntakeCategoryValue);
        }
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    return show == false
        ? Container(
            // color: Colors.red,
            height: 50,
            width: 100,
          )
        : Container(
            width: 200,
            height: 50,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                items: names
                    .map(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item.tr(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorsProvider.getColor2(context)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                value: selectedValue,
                onChanged: (value) async {
                  setState(() {
                    selectedValue = value!;
                    widget.intakeCategories.forEach(
                      (element) {
                        if (element.name == selectedValue) {
                          dbFitness.selectedIntakeCategoryValue = element.supabaseIdIntakeCategory!;
                          print("selectedIntakeCategoryValue: ${dbFitness.selectedIntakeCategoryValue}");
                        }
                      },
                    );
                    setState(() {});
                  });
                },
                alignment: Alignment.center,
                style: TextStyle(
                  // color: ColorsProvider.getColor8(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 5,
                ),
                isDense: true,
                menuItemStyleData: MenuItemStyleData(
                    // height: 37,
                    ),
                isExpanded: true,
                dropdownStyleData: DropdownStyleData(
                  offset: Offset(-0, -3),
                  elevation: 2,
                  // width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromARGB(195, 0, 0, 0),
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.5, color: ColorsProvider.getColor2(context)),
                  ),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                ),
              ),
            ),
          );
  }
}
