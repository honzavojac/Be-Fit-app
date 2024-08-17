import 'package:flutter/material.dart';

import '../../providers/colors_provider.dart';

Widget dataBoxes(
  double calories,
  double protein,
  double carbs,
  double fat,
  double fiber,
) {
  EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);
  BorderRadius globalRadius = BorderRadius.circular(20);
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              //   border: borderBorder,
              color: ColorsProvider.color_10,
              borderRadius: globalRadius, // Zaoblení rohů
            ),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
            child: Column(
              children: [
                Text(
                  'Calories',
                  style: TextStyle(fontSize: 15, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${(calories * 10.round()) / 10}",
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              //   border: borderBorder,
              color: ColorsProvider.color_10,
              borderRadius: globalRadius, // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Protein',
                  style: TextStyle(fontSize: 15, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(protein * 10).round() / 10}',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 120,
            decoration: BoxDecoration(
              //   border: borderBorder,
              color: ColorsProvider.color_10,
              borderRadius: globalRadius, // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Carbs',
                  style: TextStyle(fontSize: 15, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(carbs * 10).round() / 10}',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              //   border: borderBorder,
              color: ColorsProvider.color_10,
              borderRadius: globalRadius, // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Fat',
                  style: TextStyle(fontSize: 15, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(fat * 10).round() / 10}',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 120,
            decoration: BoxDecoration(
              //   border: borderBorder,
              color: ColorsProvider.color_10,
              borderRadius: globalRadius, // Zaoblení rohů
            ),
            padding: globalPadding,
            child: Column(
              children: [
                Text(
                  'Fiber',
                  style: TextStyle(fontSize: 15, color: ColorsProvider.color_1, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(fiber * 10).round() / 10}',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
