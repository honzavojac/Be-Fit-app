import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals_variables/nutri_data.dart';

class dataBoxes extends StatefulWidget {
  const dataBoxes({super.key});

  @override
  State<dataBoxes> createState() => _dataBoxesState();
}

class _dataBoxesState extends State<dataBoxes> {
//  EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);
  //BorderRadius globalRadius = BorderRadius.circular(15);
  @override
  Widget build(BuildContext context) {
    EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);

    BorderRadius globalRadius = BorderRadius.circular(20);
    final nutrition = Provider.of<NutritionIncremment>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 120,
              decoration: BoxDecoration(
                //   border: borderBorder,
                color: Colors.black26,
                borderRadius: globalRadius, // Zaoblení rohů
              ),
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
              child: Column(
                children: [
                  Text(
                    'Calories:',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${nutrition.kcalData}',
                    style: TextStyle(fontSize: 20, color: Colors.yellowAccent),
                    strutStyle: StrutStyle(fontWeight: FontWeight.bold),
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
                color: Colors.black26,
                borderRadius: globalRadius, // Zaoblení rohů
              ),
              padding: globalPadding,
              child: Column(
                children: [
                  Text(
                    'Protein',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${nutrition.proteinData}',
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                    strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              width: 120,
              decoration: BoxDecoration(
                //   border: borderBorder,
                color: Colors.black26,
                borderRadius: globalRadius, // Zaoblení rohů
              ),
              padding: globalPadding,
              child: Column(
                children: [
                  Text(
                    'Carbs',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${nutrition.carbsData}',
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                    strutStyle: StrutStyle(fontWeight: FontWeight.bold),
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
                color: Colors.black26,
                borderRadius: globalRadius, // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
                children: [
                  Text(
                    'Fats',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'data',
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                    strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              width: 120,
              decoration: BoxDecoration(
                //   border: borderBorder,
                color: Colors.black26,
                borderRadius: globalRadius, // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
                children: [
                  Text(
                    'Fiber',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'data',
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                    strutStyle: StrutStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
