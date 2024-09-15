// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/my_search_bar.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/nutri_intake_listview.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

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
  List<IntakeCategories> intakeCategories = [];
  DateTime dataTime = DateTime.now();
  SearchController searchController = SearchController();
  load() async {
    if (!mounted) return;
    calories = 0;
    protein = 0;
    carbs = 0;
    fat = 0;
    fiber = 0;
    foodList = [];

    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntakes = await dbFitness.SelectNutriIntake("${selectedDate.toString().replaceRange(10, null, "")}");
    // print(selectedDate.toString().replaceRange(10, null, ""));
    for (var nutriIntake in nutriIntakes) {
      if (nutriIntake.action == 3) {
      } else {
        // print(nutriIntake.action);

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
        foodList.add(food);
        // print(food.action);
        calories += food.kcal!;
        protein += food.protein!;
        carbs += food.carbs!;
        fat += food.fat!;
        fiber += food.fiber!;
      }
    }
    if (mounted) {
      intakeCategories = await dbFitness.SelectIntakeCategories();
    }

    print("load***************");
    if (mounted) {
      // Check if the widget is still mounted before calling setState
      show = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Add any cleanup code here, like cancelling timers or streams
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    var variablesProvider = Provider.of<VariablesProvider>(context, listen: false);

    return Stack(
      children: [
        Positioned(
          top: -100, // Mimo zobrazení
          right: -100, // Mimo zobrazení
          child: Container(
            key: keyDummy2, // Používáme prázdný prvek jako cíl
            width: 0,
            height: 0,
          ),
        ),
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
                                        'now'.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        // backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context).withAlpha(50)),
                                        foregroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Container(
                              height: 35,
                              // width: 145,
                              child: ElevatedButton.icon(
                                key: keyNewFood,
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
                                  'new_food'.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
                                  foregroundColor: WidgetStateProperty.all(ColorsProvider.getColor8(context)),
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
              intakeCategories: intakeCategories,
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
                    color: ColorsProvider.getColor2(context),
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
                                selectedDate = value;
                                load();
                                Navigator.of(context).pop(); // Close the dialog when a date is selected
                              },
                              currentDateDecoration: BoxDecoration(
                                border: Border.all(color: ColorsProvider.getColor2(context)),
                                shape: BoxShape.circle,
                              ),
                              daysOfTheWeekTextStyle: TextStyle(color: ColorsProvider.getColor2(context)),
                              enabledCellsDecoration: BoxDecoration(),
                              initialPickerType: PickerType.days,
                              leadingDateTextStyle: TextStyle(color: ColorsProvider.getColor2(context)),
                              slidersColor: ColorsProvider.getColor2(context),
                              slidersSize: 25,
                              selectedCellDecoration: BoxDecoration(
                                color: ColorsProvider.getColor2(context),
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
                          color: ColorsProvider.getColor2(context),
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
                    color: ColorsProvider.getColor2(context),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 30),
                  ),
                ),
              ],
            ),
            Expanded(
              child: show == true
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        // color: Colors.green[900],
                        child: Column(
                          children: [
                            Expanded(
                              child: ReorderableListView.builder(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                itemCount: intakeCategories.length,
                                onReorder: (int oldIndex, int newIndex) async {
                                  print("oldIndex: $oldIndex    newIndex: $newIndex");

                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }

                                  final IntakeCategories item = intakeCategories.removeAt(oldIndex);
                                  intakeCategories.insert(newIndex, item);

                                  // Seřazení dočasných kategorií podle jména
                                  List<IntakeCategories> tempIntakeCategories = List.from(intakeCategories);
                                  tempIntakeCategories.sort((a, b) => a.name!.compareTo(b.name!));

                                  // První smyčka: Aktualizace s negativním ID
                                  for (var i = 0; i < intakeCategories.length; i++) {
                                    await dbFitness.UpdateDailyNutriIntakeToMinus(i * -1, "${selectedDate.toString().replaceRange(10, null, "")}", intakeCategories[i].supabaseIdIntakeCategory!);
                                    print("${intakeCategories[i].name}    ${tempIntakeCategories[i].name}");
                                  }

                                  // Druhá smyčka: Aktualizace kategorií na základě action
                                  for (var i = 0; i < intakeCategories.length; i++) {
                                    for (var element in nutriIntakes) {
                                      if (element.intakeCategory == intakeCategories[i].supabaseIdIntakeCategory) {
                                        int action = 0; // Defaultní hodnota pro action
                                        // Vyhodnocení a aktualizace action na základě hodnoty element.action
                                        switch (element.action) {
                                          case 0:
                                            print("object 0");
                                            action = 2; // Nebo uprav podle logiky
                                            break;
                                          case 1:
                                            print("object 1");
                                            action = 1; // Nebo uprav podle logiky
                                            break;
                                          case 2:
                                            print("object 2");
                                            action = 2; // Nebo uprav podle logiky
                                            break;
                                          case 3:
                                          case 4:
                                            print("No action needed for object ${element.action}");
                                            break;
                                          default:
                                            print("Unknown action for element ${element.action}");
                                        }

                                        // Aktualizace v databázi s novou action
                                        await dbFitness.UpdateDailyNutriIntakeToOriginal(tempIntakeCategories[i].supabaseIdIntakeCategory!, "${selectedDate.toString().replaceRange(10, null, "")}", i * -1, action);
                                      }
                                    }
                                  }

                                  // Znovu načtení dat
                                  await load();
                                },
                                itemBuilder: (context, index) {
                                  var category = intakeCategories[index];
                                  List<Food> newFoodList = [];
                                  foodList.forEach(
                                    (element) {
                                      if (category.supabaseIdIntakeCategory == element.intakeCategory) {
                                        newFoodList.add(element);
                                      }
                                    },
                                  );
                                  double sumOfKcal = 0;
                                  for (var food in newFoodList) {
                                    sumOfKcal += food.kcal!;
                                  }
                                  return // Změna Container na použití 'Expanded' a nastavení výšky 'ListView.builder'
                                      Padding(
                                    key: Key('$index'),
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsProvider.getColor2(context),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: SingleChildScrollView(
                                        physics: NeverScrollableScrollPhysics(),
                                        child:
                                            // Zajištění, že Row má pevně daný prostor
                                            Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              // color: Colors.blue,
                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                              child: Row(
                                                children: [
                                                  ReorderableDragStartListener(
                                                    index: index,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Icon(
                                                        Icons.drag_handle_rounded,
                                                        size: 30,
                                                        color: ColorsProvider.getColor8(context),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      '${category.name}'.tr(),
                                                      style: TextStyle(
                                                        color: ColorsProvider.getColor8(context),
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        sumOfKcal <= 0
                                                            ? Container()
                                                            : Text(
                                                                '${sumOfKcal.round()} Kcal',
                                                                style: TextStyle(
                                                                  color: ColorsProvider.getColor8(context),
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5, left: 15),
                                                    child: openSearchBar(searchController, category.supabaseIdIntakeCategory!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              // color: Colors.blue,
                                              child: Column(
                                                children: [
                                                  ...newFoodList.map(
                                                    (food) => Stack(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                                          child: GestureDetector(
                                                            // onLongPress: () {
                                                            //   print("Logn press");
                                                            // },
                                                            onTap: () async {
                                                              print("tap press");
                                                              print(food.idNutriIntake);
                                                              dbFitness.selectedIntakeCategoryValue = food.intakeCategory!;
                                                              await Navigator.of(context).pushNamed('/addIntakePage', arguments: [food, quantity, false, intakeCategories]);

                                                              await load();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Color.fromARGB(100, 0, 0, 0),
                                                                borderRadius: variablesProvider.zaobleni,
                                                              ),
                                                              // height: 80,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center, // Center the container content
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                                                                            child: TextScroll(
                                                                              "${food.name.toString()}",
                                                                              mode: TextScrollMode.endless,
                                                                              velocity: Velocity(pixelsPerSecond: Offset(35, 0)),
                                                                              delayBefore: Duration(milliseconds: 500),
                                                                              pauseBetween: Duration(milliseconds: 1000),
                                                                              style: TextStyle(
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: ColorsProvider.getColor8(context),
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                              // textDirection: TextDirection.LTR,
                                                                              selectable: false,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 60,
                                                                      ),
                                                                      customText("Weight", (food.weight ?? 0).toDouble(), context),
                                                                      customText("Kcal", food.kcal ?? 0, context),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          // height: 80,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            print("delete");
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text('confirm_delete'.tr()),
                                                                                  content: Text('${"delete_nutri_intake_question".tr()} ${food.weight}g ${food.name}?'),
                                                                                  actions: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 40,
                                                                                            width: 100,
                                                                                            decoration: BoxDecoration(
                                                                                              color: ColorsProvider.getColor2(context),
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                'cancel'.tr(),
                                                                                                style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            NutriIntake nutriIntake = NutriIntake(
                                                                                              idFood: food.idFood,
                                                                                              idNutriIntake: food.idNutriIntake,
                                                                                              intakeCategory: food.intakeCategory,
                                                                                              quantity: food.quantity,
                                                                                              createdAt: food.createdAt,
                                                                                              weight: food.weight,
                                                                                              action: food.action,
                                                                                            );
                                                                                            try {
                                                                                              switch (food.action) {
                                                                                                case 0:
                                                                                                  // nastavit 3 a pak se to odstraní ze supabase při sync

                                                                                                  await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, 3);
                                                                                                  break;
                                                                                                case 1:
                                                                                                  // odstranit hned ze sqflite

                                                                                                  print(food.idNutriIntake);
                                                                                                  await dbFitness.DeleteNutriIntake(food.idNutriIntake!);

                                                                                                  break;
                                                                                                case 2:
                                                                                                  // nastavit 3 a pak se to odstraní ze supabase při sync
                                                                                                  await dbFitness.UpdateNutriIntake(food.idNutriIntake!, nutriIntake, 3);

                                                                                                  break;
                                                                                                case 3:
                                                                                                  // nic, při sync se to odstraní ze supabase
                                                                                                  break;
                                                                                                case 4:
                                                                                                  // asi nenastane nikdy
                                                                                                  break;
                                                                                                default:
                                                                                                  print("!!! NEZNÁMÝ STAV, NĚCO SELHALO !!!");
                                                                                              }
                                                                                              for (int i = 0; i < newFoodList.length; i++) {
                                                                                                if (newFoodList[i].idNutriIntake == food.idNutriIntake) {
                                                                                                  newFoodList.removeAt(i);
                                                                                                }
                                                                                              }
                                                                                              for (int i = 0; i < foodList.length; i++) {
                                                                                                if (foodList[i].idNutriIntake == food.idNutriIntake) {
                                                                                                  foodList.removeAt(i);
                                                                                                }
                                                                                              }
                                                                                            } on Exception catch (e) {
                                                                                              print(e);
                                                                                            }

                                                                                            setState(() {});

                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 40,
                                                                                            width: 100,
                                                                                            // padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                                                                            decoration: BoxDecoration(
                                                                                              color: ColorsProvider.color_9,
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                'yes_delete'.tr(),
                                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            height: 60, // color: Colors.red,
                                                                            width: 45,
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.close_rounded,
                                                                                color: ColorsProvider.getColor8(context),
                                                                                size: 30,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }

  Widget openSearchBar(SearchController searchController, int idIntakeCategory) {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    return GestureDetector(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: ColorsProvider.getColor8(context)),
        child: Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: ColorsProvider.getColor2(context),
          ),
        ),
      ),
      onTap: () {
        searchController.openView();

        for (var i = 0; i < intakeCategories.length; i++) {
          if (intakeCategories[i].supabaseIdIntakeCategory == idIntakeCategory) {
            dbFitness.selectedIntakeCategoryValue = idIntakeCategory;
            print(dbFitness.selectedIntakeCategoryValue);
          }
        }
      },
    );
  }
}

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;

  MarqueeText({
    required this.text,
    required this.style,
    required this.width,
  });

  @override
  _MarqueeTextState createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double textWidth = _calculateTextWidth(widget.text, widget.style);
            double offset = textWidth * _animation.value;

            return SizedBox(
              width: widget.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(initialScrollOffset: offset),
                child: Text(
                  widget.text,
                  style: widget.style,
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      // textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
