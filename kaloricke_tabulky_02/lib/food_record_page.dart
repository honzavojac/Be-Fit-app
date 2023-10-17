// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodRecordAppBar extends StatelessWidget {
  const FoodRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text('Záznam jídel'),
          SizedBox(
            width: 60,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(Size(45, 45)), // Velikost tlačítka
              shape: MaterialStateProperty.all(
                  CircleBorder()), // Tvar tlačítka (kruhové)
            ),
            child: Icon(
              Icons.add,
              color: Colors.white, // Barva ikony
              size: 24, // Velikost ikony
            ),
          )
        ],
      ),
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
    List<String> selectedWeight = ['g', 'x 100g'];

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
    double numberWeight;
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
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
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
            Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white54,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10, top: 0),
                      width: 70,
                      //height: 40,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        //cursorHeight: 20.0,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Weight',
                          labelStyle: TextStyle(color: Colors.amber),
                          // hintText: 'Enter value:',
                          hintStyle: TextStyle(fontSize: 15),
                        ),
                        onChanged: (input) {
                          setState(() {
                            numberWeight = double.parse(input);
                            print('Text changed to: $numberWeight');
                          });
                        },
                      )),
                  Text(
                    ' $selected',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Container(
                    child: PopupMenuButton<int>(
                      itemBuilder: (context) {
                        return List<PopupMenuEntry<int>>.generate(
                            selectedWeight.length, (int index) {
                          return PopupMenuItem<int>(
                            value: index,
                            child: Text(selectedWeight[index]),
                          );
                        });
                      },
                      onSelected: (int value) {
                        setState(() {
                          selected =
                              selectedWeight[value]; // Aktualizace proměnné
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
            )
          ],
        ),
      ],
    );
  }
}
