// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class mySearchBar extends StatefulWidget {
  const mySearchBar({super.key});

  @override
  State<mySearchBar> createState() => _mySearchBarState();
}



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

class _mySearchBarState extends State<mySearchBar> {
  @override
  Widget build(BuildContext context) {
  
    return Container(
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
            return food.toLowerCase().contains(controller.text.toLowerCase());
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
    );
  }
}
