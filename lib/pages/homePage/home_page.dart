// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/date_row.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../init_page.dart';
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
  Measurements? measurement = Measurements();
  load() async {
    if (!mounted) return;
    calories = 0;
    protein = 0;
    carbs = 0;
    fat = 0;
    fiber = 0;

    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntakes = await dbFitness.SelectNutriIntake("${selectedDate.toString().replaceRange(10, null, "")}");
    print(selectedDate.toString().replaceRange(10, null, ""));
    for (var nutriIntake in nutriIntakes) {
      // print(nutriIntake);
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

    if (mounted) {
      await SplitStartedStatistic(); // Only call if still mounted
    }

    if (mounted) {
      measurement = await dbFitness.selectOneMeasurement(selectedDate.toString().replaceRange(10, null, ""));
      setState(() {}); // Only update the UI if still mounted
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Add any cleanup code here, like cancelling timers or streams
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
    load();
  }

  // void printNavigationStack(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    splitstartedcompleteds.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );

    // final visibleSplits = splitstartedcompleteds.skip(3).take(3).toList();

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
          Spacer(),
          Container(
            child: dataBoxes(calories, protein, carbs, fat, fiber, context),
          ),
          Spacer(),
          Container(
            child: lastSplitWidget(),
          ),
          Spacer(),
          Container(
            child: measurement != null
                ? measurentWidget()
                : Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "measurement".tr(),
                                style: TextStyle(
                                  color: ColorsProvider.getColor2(context),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                key: keyMeasurementButton,
                                onTap: () {
                                  Navigator.pushNamed(context, '/measurements');
                                },
                                child: Container(
                                  height: 30,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: ColorsProvider.getColor2(context),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Text(
                                        "add".tr(),
                                        style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Spacer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         controller.jumpTo(0);
          //         hasToOpenDropdown = true;
          //         print(hasToOpenDropdown);
          //       },
          //       child: Text("Start split"),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/measurements');
          //       },
          //       child: Text("Measurements"),
          //     ),
          //     // DemoDropdown(),
          //   ],
          // ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget lastSplitWidget() {
    return splitstartedcompleteds.isEmpty
        ? Container()
        : Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "split".tr(),
                          style: TextStyle(
                            color: ColorsProvider.getColor2(context),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Column(
                      children: splitstartedcompleteds.asMap().entries.map((entry) {
                        SplitStartedCompleted split = entry.value;
                        DateTime parsedDate = DateTime.parse(split.createdAt.toString());
                        final DateFormat formatter = DateFormat('dd.MM.yyyy');
                        final String formattedDate = formatter.format(parsedDate);

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${formattedDate}",
                                    style: TextStyle(
                                      color: parsedDate.toString().replaceRange(10, null, "") == selectedDate.toString().replaceRange(10, null, "") ? ColorsProvider.getColor2(context) : Colors.white.withAlpha(100),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              split.name!,
                                              style: TextStyle(color: ColorsProvider.getColor2(context), fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${"number_of_sets".tr()}:',
                                                  style: TextStyle(color: Colors.grey[400]),
                                                ),
                                                Text(
                                                  '${"total_work_volume".tr()}:',
                                                  style: TextStyle(color: Colors.grey[400]),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${split.numberOfSets ?? "none"}',
                                                  style: TextStyle(color: Colors.grey[400]),
                                                ),
                                                Text(
                                                  formatWorkVolume(split.totalWorkVolume),
                                                  style: TextStyle(color: Colors.grey[400]),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget measurentWidget() {
    if (measurement!.idBodyMeasurements == null) {
      return Container();
    } else {
      DateTime parsedDate = DateTime.parse(measurement!.createdAt.toString());
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      final String formattedDate = formatter.format(parsedDate);
      return Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "measurement".tr(),
                      style: TextStyle(
                        color: ColorsProvider.getColor2(context),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      key: keyMeasurementButton,
                      onTap: () {
                        Navigator.pushNamed(context, '/measurements');
                      },
                      child: Container(
                        height: 30,
                        // width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: ColorsProvider.getColor2(context),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "add".tr(),
                              style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${formattedDate}",
                            style: TextStyle(
                              color: parsedDate.toString().replaceRange(10, null, "") == selectedDate.toString().replaceRange(10, null, "") ? ColorsProvider.getColor2(context) : Colors.white.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${"weight".tr()}:',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${measurement!.weight ?? "-"}',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${"height".tr()}:',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${measurement!.height ?? "-"}',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${'circumference'.tr()} (cm)',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 35.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${"abdominal".tr()}:',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                              Text(
                                                '${"chest".tr()}:',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                              Text(
                                                '${"waist".tr()}:',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${measurement!.abdominalCircumference ?? "-"}',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                              Text(
                                                '${measurement!.chestCircumference ?? "-"}',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                              Text(
                                                '${measurement!.waistCircumference ?? "-"}',
                                                style: TextStyle(color: Colors.grey[400]),
                                              ),
                                              // Text(
                                              //   '${measurement!.waistCircumference!.toInt()}',
                                              //   style: TextStyle(color: Colors.grey[400]),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${"thingh".tr()}:',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            Text(
                                              '${"neck".tr()}:',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            Text(
                                              '${"biceps".tr()}:',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${measurement!.thighCircumference ?? "-"}',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            Text(
                                              '${measurement!.neckCircumference ?? "-"}',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            Text(
                                              '${measurement!.bicepsCircumference ?? "-"}',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            // Text(
                                            //   '${measurement.waistCircumference!.toInt()}',
                                            //   style: TextStyle(color: Colors.grey[400]),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
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
        ],
      );
    }
  }

  String formatWorkVolume(int? totalWorkVolume) {
    // Definování formátování s mezerou jako tisícovým oddělovačem
    final formatter = NumberFormat('#,###.##', 'en_US');

    // Pokud je totalWorkVolume null, vrátí 'none'
    if (totalWorkVolume == null) {
      return 'none';
    }

    // Naformátování čísla s tisícovým oddělovačem
    final formattedNumber = formatter.format(totalWorkVolume).replaceAll(',', ' ');

    return '$formattedNumber Kg';
  }

  List<SplitStartedCompleted> splitstartedcompleteds = [];

  Future<void> SplitStartedStatistic() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    splitstartedcompleteds = await dbFitness.SelectLast5SplitStartedCompleted(selectedDate.toString().replaceRange(10, null, ""));
  }
}


// class DemoDropdown extends StatefulWidget {
//   @override
//   State<DemoDropdown> createState() => DemoDropdownState();
// }

// class DemoDropdownState<T> extends State<DemoDropdown> {
//   /// This is the global key, which will be used to traverse [DropdownButton]s widget tree

//   @override
//   Widget build(BuildContext context) {
//     // openDropdown();
//     final dropdown = DropdownButton<int>(
//       key: _dropdownButtonKey,
//       items: [
//         DropdownMenuItem(value: 1, child: Text('1')),
//         DropdownMenuItem(value: 2, child: Text('2')),
//         DropdownMenuItem(value: 3, child: Text('3')),
//       ],
//       onChanged: (value) {},
//     );

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Offstage(child: dropdown),
//         ElevatedButton(onPressed: openDropdown, child: Text('CLICK ME')),
//       ],
//     );
//   }
// }
