// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/globals_variables/nutri_data.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/date_row.dart';
import 'package:provider/provider.dart';

import 'data_boxes.dart';
import 'data_listview.dart';
import 'settings.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Home page'),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = Provider.of<NutritionIncremment>(context);
    return Stack(
      children: [
        Container(
          //color: Colors.black26,
          child: Column(
            children: [
              dateRow(),
              const SizedBox(
                height: 40,
              ),
              dataBoxes(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      nutrition.incrementKcal();
                      nutrition.incrementProtein();
                      nutrition.incrementCarbs();
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                      'Add',
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(150, 40)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Expanded(
                child: dataListview(),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
