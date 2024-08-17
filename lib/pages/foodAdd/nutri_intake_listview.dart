import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NutriIntakeListview extends StatefulWidget {
  final Function notifyParent;

  final List<Food> foodList;
  final List<String> quantity;
  const NutriIntakeListview({
    super.key,
    required this.notifyParent,
    required this.foodList,
    required this.quantity,
  });

  @override
  State<NutriIntakeListview> createState() => _NutriIntakeListviewState();
}

class _NutriIntakeListviewState extends State<NutriIntakeListview> {
  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context);

    // load();
    return ListView.builder(
      // shrinkWrap: false,
      // physics: NeverScrollableScrollPhysics(),
      itemCount: widget.foodList.length,
      itemBuilder: (context, itemIndex) {
        Food food = widget.foodList[itemIndex];
        int setNumber = itemIndex + 1;
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 80,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          print("Logn press");
                        },
                        onTap: () async {
                          print("tap press");
                          await Navigator.of(context).pushNamed('/addIntakePage', arguments: [food, quantity, false]);
                          widget.notifyParent();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsProvider.color_2,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    food.name.toString(),
                                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: ColorsProvider.color_8),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 60,
                                  ),
                                  customText("Weight", food.weight!.toDouble()),
                                  customText("Kcal", food.kcal),
                                ],
                              ),
                            ],
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
                                          print(food.action);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm delete'),
                                                content: Text(' Do you want delete ${food.weight}g ${food.name}?'),
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
                                                            color: ColorsProvider.color_2,
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          switch (food.action) {
                                                            case 0:
                                                              // nastavit 3 a pak se to odstraní ze supabase při sync
                                                              break;
                                                            case 1:
                                                              // odstranit hned ze sqflite
                                                              await widget.foodList.removeAt(itemIndex);
                                                              await dbFitness.DeleteNutriIntake(food.idNutriIntake!);

                                                              break;
                                                            case 2:
                                                              // nastavit 3 a pak seto odstraní ze supabase při sync
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
                                                              'Yes',
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
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     duration: Duration(seconds: 5),
                                          //     backgroundColor: ColorsProvider.color_2,
                                          //     content: Container(
                                          //       height: 30,
                                          //       child: Row(
                                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             'Do you want delete ${food.weight}g ${food.name}?',
                                          //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          //           ),
                                          //           ElevatedButton(
                                          //             style: ButtonStyle(
                                          //               backgroundColor: WidgetStatePropertyAll(ColorsProvider.color_8),
                                          //               foregroundColor: WidgetStatePropertyAll(
                                          //                 ColorsProvider.color_1,
                                          //               ),
                                          //             ),
                                          //             onPressed: () async {
                                          //               // dbHelper.deleteItem(notes[index].id, notes[index].czfoodname);
                                          //               // notes.removeAt(index);
                                          //               setState(() {});
                                          //               ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          //             },
                                          //             child: Text("yes"),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          height: 70,
                                          // color: Colors.red,
                                          width: 45,
                                          child: Center(
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: ColorsProvider.color_8,
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
                ),

                // Container(
                //   color: Colors.blue,
                //   height: 25,
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget customText(String itemString, double? itemValue) {
  itemValue = (itemValue! * 100).round() / 100;
  TextStyle textStyle = TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: ColorsProvider.color_8);
  TextStyle textStyleKcal = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorsProvider.color_8);

  TextStyle numberStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColorsProvider.color_8);
  TextStyle gStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: ColorsProvider.color_8);
  return Container(
    width: 150,
    child: Row(
      children: [
        Text(
          "$itemString: ",
          style: itemString != "Kcal" ? textStyle : textStyleKcal,
        ),
        Text(
          "${itemValue == null || itemValue == 0 ? 0 : (itemValue % 1 == 0 ? itemValue.toInt() : itemValue)}",
          style: numberStyle,
        ),
        Container(
          width: 1,
        ),
        itemString == "Weight"
            ? Text(
                "g",
                style: gStyle,
              )
            : Container(),
      ],
    ),
  );
}
