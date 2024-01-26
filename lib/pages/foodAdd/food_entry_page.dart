// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/data_boxes.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/my_search_bar.dart';
import 'package:provider/provider.dart';

import '../../database/database_provider.dart';
import 'food_diary_boxes.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class FoodRecordAppBar extends StatelessWidget {
  const FoodRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Food Add'),
          Container(
            height: 35,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodNewScreen()),
                );
              },
              icon: Icon(Icons.add_circle_outline_sharp),
              label: Text(
                'New food',
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorsProvider.color_2),
                foregroundColor:
                    MaterialStateProperty.all(ColorsProvider.color_8),
              ),
            ),
          ),
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
    var dbHelper = Provider.of<DBHelper>(context);

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
            mySearchBar(),
            SizedBox(
              height: 10,
            ),
            myDataboxes(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Food diary',
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorsProvider.color_1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            //       GestureDetector(
            // onHorizontalDragUpdate: (details) {
            //   if (details.primaryDelta! > 0) {
            //     print("object");
            //     pageProvider.page = -1;
            //   }
            Expanded(
              child: foodDiaryBoxes(),
            ),
            SizedBox(
              height: 65,
            )
          ],
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 15,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //-------------------------------
                        dbHelper.insertAllDataToNotes();
                      },
                      icon: Icon(Icons.add, size: 30),
                      label: Text('Add',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorsProvider.color_2),
                        foregroundColor:
                            MaterialStateProperty.all(ColorsProvider.color_8),
                      ),
                    ),
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
