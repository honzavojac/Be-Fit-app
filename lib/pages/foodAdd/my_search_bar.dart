import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database_provider.dart';

class mySearchBar extends StatefulWidget {
  const mySearchBar({Key? key}) : super(key: key);

  @override
  State<mySearchBar> createState() => _mySearchBarState();
}

class _mySearchBarState extends State<mySearchBar> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return Container(
      height: 90,
      padding: EdgeInsets.all(25),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            elevation: MaterialStateProperty.all(1),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            controller: controller,
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 10.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading:
                const Icon(Icons.search, color: Color.fromRGBO(255, 179, 0, 1)),
            hintText: 'Vyhledat jídlo...',
            hintStyle: MaterialStatePropertyAll(TextStyle(
              color: Colors.amber[600],
            )),
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) async {
          final List<String> czFoodNames = await dbHelper.getCzFoodNames();
          final normalizedQuery =
              _removeDiacritics(controller.text.toLowerCase());

          final filteredJidla = czFoodNames.where((food) {
            final normalizedFood = _removeDiacritics(food.toLowerCase());
            return normalizedFood.contains(normalizedQuery);
          }).toList();

          return filteredJidla.map((food) {
            return ListTile(
              title: Text(food),
              onTap: () async {
                // Získání hodnoty ENERGYKCAL ze stejného řádku jako food
                int kcalValue = await dbHelper.getKcalForFood(food);
                double proteinValue = await dbHelper.getProteinForFood(food);
                double carbsValue = await dbHelper.getCarbsForFood(food);
                double fatValue = await dbHelper.getFatForFood(food);
                double fiberValue = await dbHelper.getFiberForFood(food);
                // Vložit vybranou položku jídla do databáze s odpovídající hodnotou ENERGYKCAL
                print("protein111:$proteinValue");
                await dbHelper.NutritionsData(food, kcalValue, proteinValue,
                    carbsValue, fatValue, fiberValue);

                // Zavřít pohled na vyhledávání a nastavit vybraný text
                controller.text = food;
                controller.closeView(food);

                // Přidejte akce po výběru položky jídla
              },
            );
          }).toList();
        },
      ),
    );
  }
}

String _removeDiacritics(String input) {
  return input.replaceAllMapped(
    RegExp('[ÁáČčĎďÉéěÍíŇňÓóŘřŠšŤťÚúŮůÝýŽž]'),
    (match) => _diacriticMap[match.group(0)] ?? match.group(0)!,
  );
}

const Map<String, String> _diacriticMap = {
  'Á': 'A',
  'á': 'a',
  'Č': 'C',
  'č': 'c',
  'Ď': 'D',
  'ď': 'd',
  'É': 'E',
  'é': 'e',
  'ě': 'e',
  'Í': 'I',
  'í': 'i',
  'Ň': 'N',
  'ň': 'n',
  'Ó': 'O',
  'ó': 'o',
  'Ř': 'R',
  'ř': 'r',
  'Š': 'S',
  'š': 's',
  'Ť': 'T',
  'ť': 't',
  'Ú': 'U',
  'ú': 'u',
  'Ů': 'U',
  'ů': 'u',
  'Ý': 'Y',
  'ý': 'y',
  'Ž': 'Z',
  'ž': 'z',
};
