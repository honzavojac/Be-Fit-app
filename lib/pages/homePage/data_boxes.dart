import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/main.dart';

import '../../providers/colors_provider.dart';

Widget dataBoxes(
  double calories,
  double protein,
  double carbs,
  double fat,
  double fiber,
  BuildContext context,
) {
  EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);
  BorderRadius globalRadius = BorderRadius.circular(18);
  return Column(
    children: [
      _categoryWidget(globalRadius, "Kcal", calories.toStringAsFixed(0), 150, context),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _categoryWidget(globalRadius, "protein".tr(), ((protein * 10).round() / 10) % 1 == 0 ? protein.toStringAsFixed(0) : protein.toStringAsFixed(1), 130, context),
          _categoryWidget(globalRadius, "carbs".tr(), ((carbs * 10).round() / 10) % 1 == 0 ? carbs.toStringAsFixed(0) : carbs.toStringAsFixed(1), 130, context),
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _categoryWidget(globalRadius, "fat".tr(), ((fat * 10).round() / 10) % 1 == 0 ? fat.toStringAsFixed(0) : fat.toStringAsFixed(1), 130, context),
          _categoryWidget(globalRadius, "fiber".tr(), ((fiber * 10).round() / 10) % 1 == 0 ? fiber.toStringAsFixed(0) : fiber.toStringAsFixed(1), 130, context),
        ],
      ),
    ],
  );
}

Widget _categoryWidget(
  BorderRadiusGeometry globalRadius,
  String categoryText,
  String categoryValue,
  double width,
  BuildContext context,
) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      //   border: borderBorder,
      color: ColorsProvider.color_10,
      borderRadius: globalRadius, // Zaoblení rohů
    ),
    padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
    child: Column(
      children: [
        Text(
          '$categoryText',
          style: TextStyle(fontSize: 15, color: ColorsProvider.getColor2(context), fontWeight: FontWeight.bold),
        ),
        Text(
          "${categoryValue}",
          style: TextStyle(
            fontSize: 20,
            color: ColorsProvider.color_3.withAlpha(200),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}
