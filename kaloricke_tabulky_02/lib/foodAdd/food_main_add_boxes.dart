import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../globals_variables/nutri_data.dart';
import 'change_weight.dart';

class foodMainAddBoxes extends StatefulWidget {
  const foodMainAddBoxes({super.key});

  @override
  State<foodMainAddBoxes> createState() => _foodMainAddBoxesState();
}

class _foodMainAddBoxesState extends State<foodMainAddBoxes> {
  @override
  Widget build(BuildContext context) {
    String textFood;
    double numberProtein;
    double numberCarbs;
    double numberFats;
    double numberFiber;
    double numberKcal;

    final nutritionChange = Provider.of<NutritionIncremment>(context);

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
            LengthLimitingTextInputFormatter(25)
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
          onChanged: (input) {
            textFood = input;
            nutritionChange.updateKcal(input as double);
            print('Text changed to: $textFood');
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
              onChanged: (input) {
                numberKcal = double.parse(input);
                nutritionChange.updateKcal(numberKcal);

                print('Text changed to: $numberKcal');
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
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]'),
                ), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
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
              onChanged: (input) {
                numberProtein = double.parse(input);
                print('Text changed to: $numberProtein');
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
                    r'[0-9]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
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
              onChanged: (input) {
                numberCarbs = double.parse(input);
                print('Text changed to: $numberCarbs');
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
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
              onChanged: (input) {
                numberFats = double.parse(input);
                print('Text changed to: $numberFats');
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
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
              onChanged: (input) {
                numberFiber = double.parse(input);
                print('Text changed to: $numberFiber');
              },
            ),
          )
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
                  labelText: 'Weight',
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
              onChanged: (input) {},
            ),
          ),
          changeWeight(),
        ],
      ),
    ]);
  }
}
