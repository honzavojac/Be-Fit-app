import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

import '../../colors_provider.dart';

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
    var dbHelper = Provider.of<DBHelper>(context);
    EdgeInsets globalPadding = const EdgeInsets.fromLTRB(25, 3, 25, 3);
    BorderRadius globalRadius = BorderRadius.circular(20);
    return FutureBuilder(
      future: dbHelper.countNotes(),
      builder: (context, snapshot) {
        late int kcal = 0;
        late double protein = 0;
        late double carbs = 0;
        late double fat = 0;
        late double fiber = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData == false) {
            kcal = 0;
            protein = 0;
            carbs = 0;
            fat = 0;
            fiber = 0;
          } else {
            List<Note> notes = snapshot.data!;
            kcal = notes[0].kcal;
            protein = notes[0].protein;
            carbs = notes[0].carbs;
            fat = notes[0].fat;
            fiber = notes[0].fiber;
          }
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
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorsProvider.color_1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${kcal}',
                          style: TextStyle(
                              fontSize: 20, color: ColorsProvider.color_3),
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
                      color: ColorsProvider.color_10,
                      borderRadius: globalRadius, // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: Column(
                      children: [
                        Text(
                          'Protein',
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorsProvider.color_1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${protein}',
                          style: TextStyle(
                              fontSize: 18, color: ColorsProvider.color_3),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorsProvider.color_1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${carbs}',
                          style: TextStyle(
                              fontSize: 18, color: ColorsProvider.color_3),
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
                      color: ColorsProvider.color_10,
                      borderRadius: globalRadius, // Zaoblení rohů
                    ),
                    padding: globalPadding,
                    child: Column(
                      children: [
                        Text(
                          'Fat',
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorsProvider.color_1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${fat}',
                          style: TextStyle(
                              fontSize: 18, color: ColorsProvider.color_3),
                          strutStyle: StrutStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 15,
                              color: ColorsProvider.color_1,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${fiber}',
                          style: TextStyle(
                              fontSize: 18, color: ColorsProvider.color_3),
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
      },
    );
  }
}
