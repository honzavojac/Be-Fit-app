// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';

Widget mainPage() {
  EdgeInsets globalPadding = EdgeInsets.fromLTRB(15, 5, 15, 8);
  Color colorBox = Color.fromARGB(255, 255, 154, 1);
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      SizedBox(
        child: Text('Date',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorBox,
              borderRadius: BorderRadius.circular(7), // Zaoblení rohů
            ),
            padding: EdgeInsets.fromLTRB(15, 5, 15, 7),
            child: Column(
              children: [
                Text(
                  'Kalories',
                  style: TextStyle(fontSize: 10),
                ),
                Text('data')
              ],
            ),
          )
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorBox,
              borderRadius: BorderRadius.circular(7), // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Protein',
                  style: TextStyle(fontSize: 10),
                ),
                Text('data')
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorBox,
              borderRadius: BorderRadius.circular(7), // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Carbs',
                  style: TextStyle(fontSize: 10),
                ),
                Text('data')
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorBox,
              borderRadius: BorderRadius.circular(7), // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Fats',
                  style: TextStyle(fontSize: 10),
                ),
                Text('data')
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorBox,
              borderRadius: BorderRadius.circular(7), // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Fiber',
                  style: TextStyle(fontSize: 10),
                ),
                Text('data')
              ],
            ),
          ),
        ],
      )
    ],
  );
}
