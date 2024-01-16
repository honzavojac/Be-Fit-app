// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/date_row.dart';
import 'package:provider/provider.dart';

import '../../database/database_provider.dart';
import 'data_boxes.dart';
import 'settings.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Home page'),
          IconButton(
              onPressed: () async {
              
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
    return Stack(
      children: [
        Container(
          //color: Colors.black26,
          child: Column(
            children: [
              dateRow(),
              const SizedBox(
                height: 20,
              ),
              dataBoxes(),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
