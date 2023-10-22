// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/widgets_for_multiple_screens/change_servingSize.dart';

class FoodRecordAppBar extends StatelessWidget {
  const FoodRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Záznam jídel'),
    );
  }
}

String selected = 'g';

class FoodRecordScreen extends StatefulWidget {
  const FoodRecordScreen({super.key});

  @override
  State<FoodRecordScreen> createState() => _FoodRecordScreenState();
}

class _FoodRecordScreenState extends State<FoodRecordScreen> {
  @override
  Widget build(BuildContext context) {

    final List<String> jidla = [
      'Hovězí steak',
      'Kuřecí maso na smetanové omáčce',
      'Smažený rýže s kuřecím masem',
      'Pizza Margherita',
      'Těstoviny Carbonara',
      'Losos na grilu',
      'Sushi rolls',
      'Caesarský salát',
      'Hamburger',
      'Tacos s hovězím masem',
      'Rajčatová polévka',
      'Smažené kuřecí křidélka',
      'Masové kuličky se špagetami',
      'Guacamole s nachos',
      'Řízek s bramborovou kaší',
      'Smažené krevety',
      'Zeleninový curry',
      'Smažený losos s teriyaki omáčkou',
      'Club sendvič',
      'Vegetariánská pizza',
      'Rýžové noky s vepřovým masem',
      'Chilli con carne',
      'Quiche Lorraine',
      'Palačinky s javorovým sirupem',
      'Kuřecí plněné sýrem',
      'Miso polévka',
      'Pečená lilek',
      'Těstoviny Alfredo',
      'Smažený tvaroh s medem',
      'Krabí salát',
      'Tournedos Rossini',
      'Houbová polévka',
      'Kari s hovězím masem',
      'Jambalaya',
      'Coq au Vin',
      'Španělská paella',
      'Smažená rýže s vepřovým masem',
      'Zeleninová lasagne',
      'Smažený sýr',
      'Zelný salát',
      'Grilovaná kachna',
      'Thajský zeleninový curry',
      'Pečený losos s citronem',
      'Smažený lososový steak',
      'Zapečená brambora',
      'Tacos s krevetami',
      'Hovězí stroganoff',
      'Sushi s lososem',
      'Caprese salát',
      'Tiramisu'
    ];
    return Stack(
      children: [
        /*Positioned(
          top: 5,
          right: 30,
          child: ElevatedButton.icon(
            onPressed: () {},
            label: Text('Add new food', style: TextStyle(fontSize: 10)),
            icon: Icon(Icons.add, size: 20),
          ),
        ),*/
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 90,
              padding: EdgeInsets.all(25),
              child: SearchAnchor(
                //isFullScreen: false,

                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    elevation: MaterialStatePropertyAll(1),
                    shadowColor: MaterialStatePropertyAll(Colors.transparent),
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    hintText: 'Search food...',
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  // Filtrujte seznam jídel na základě hledaného výrazu v `controller.text`
                  final filteredJidla = jidla.where((food) {
                    return food
                        .toLowerCase()
                        .contains(controller.text.toLowerCase());
                  }).toList();

                  return filteredJidla.map((food) {
                    return ListTile(
                      title: Text(food),
                      onTap: () {
                        controller.text = food;
                        controller.closeView(food);
                        // Zde můžete provést akce po stisknutí položky jídla
                      },
                    );
                  }).toList();
                },
              ),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(
                          4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Serving size',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                            fontSize:
                                15) // zobrazí se pokud je textové pole prázdné
                        //  icon: Icon(Icons.text_fields), //
                        ),
                    onChanged: (input) {},
                  ),
                ),
                changeServingSize(),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    //color: Colors.blue,
                    height: 40,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add, size: 30),
                      label: Text('Add',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber[800]),
                          foregroundColor: MaterialStateProperty.all(
                              Colors.black) // Nastavení barvy zde
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
