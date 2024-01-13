import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/change_new_food_box_servingSize.dart';
import 'package:provider/provider.dart';



class foodMainAddBoxes extends StatefulWidget {
  const foodMainAddBoxes({super.key});

  @override
  State<foodMainAddBoxes> createState() => _foodMainAddBoxesState();
}

class _foodMainAddBoxesState extends State<foodMainAddBoxes> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return Column(children: [
      const SizedBox(
        height: 30,
      ),
      SizedBox(
        width: 250,
        child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'[A-Za-z0-9ěščřžýáíéóůú)(\-_\s]')),
// povoluje zadat pouze string hodnotu => použiju pro vyhledávání v databázi
            LengthLimitingTextInputFormatter(50)
          ],
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              labelText: 'Food',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide:
                      BorderSide(strokeAlign: BorderSide.strokeAlignInside)),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              hintText: 'Enter name of food:',
              hintStyle: TextStyle(
                  fontSize: 15) // zobrazí se pokud je textové pole prázdné
              //  icon: Icon(Icons.text_fields), //
              ),
          controller: dbHelper.textEditingController1,
          onChanged: (input) {
            if (input == "") {
              dbHelper.newFoodNameOfFood = "";
            } else {
              var value = input;
              dbHelper.newFoodNameOfFood = value;
            }
          },
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 150,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(
                    4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
              ],
              decoration: const InputDecoration(
                  labelText: 'Serving size',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 179, 0, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 143, 0, 1),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 143, 0, 1),
                      width: 3.0,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(
                      fontSize: 15) // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                  ),
              controller: dbHelper.textEditingController2,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodGrams = 0;
                } else {
                  var value = double.parse(input);
                  dbHelper.newFoodGrams = value;
                }
              },
            ),
          ),
          changeNewFoodServingSize(),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(
                    4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
              ],
              decoration: const InputDecoration(
                  labelText: 'Kcal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(
                      fontSize: 15) // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                  ),
              controller: dbHelper.textEditingController3,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodKcal = 0;
                } else {
                  var value = int.parse(input);
                  dbHelper.newFoodKcal = value;
                }
              },
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    r'[0-9.]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                LengthLimitingTextInputFormatter(
                    4) //omezí kolik znaků je možno zadat
              ],
              decoration: const InputDecoration(
                  labelText: 'Protein',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(
                      fontSize: 15) // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                  ),
              controller: dbHelper.textEditingController4,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodProtein = 0;
                } else {
                  var value = double.parse(input);
                  dbHelper.newFoodProtein = value;
                }
              },
            ),
          ),
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    r'[0-9.]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                LengthLimitingTextInputFormatter(4)
              ],
              decoration: const InputDecoration(
                  labelText: 'Carbs',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(
                      fontSize: 15) // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                  ),
              controller: dbHelper.textEditingController5,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodCarbs = 0;
                } else {
                  var value = double.parse(input);
                  dbHelper.newFoodCarbs = value;
                }
              },
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(
                    4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
              ],
              decoration: const InputDecoration(
                  labelText: 'Fats',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(
                      fontSize: 15) // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                  ),
              controller: dbHelper.textEditingController6,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodFat = 0;
                } else {
                  var value = double.parse(input);
                  dbHelper.newFoodFat = value;
                }
              },
            ),
          ),
          SizedBox(
            width: 120,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'Fiber',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.blue, // Barva levé strany rámečku
                    width: 2.0, // Šířka levé strany rámečku
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                hintText: 'Enter value:',
                hintStyle: TextStyle(fontSize: 15),
              ),
              controller: dbHelper.textEditingController7,
              onChanged: (input) {
                if (input == "") {
                  dbHelper.newFoodFiber = 0;
                } else {
                  var value = double.parse(input);
                  dbHelper.newFoodFiber = value;
                }
              },
            ),
          )
        ],
      ),
    ]);
  }
}
