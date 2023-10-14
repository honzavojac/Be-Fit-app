import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Domovská obrazovka'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets globalPadding = const EdgeInsets.fromLTRB(20, 3, 20, 3);

    Border borderBorder = Border.all(width: 1, color: Colors.white);
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 50,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: const Text('Date',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: borderBorder,
                borderRadius: BorderRadius.circular(7), // Zaoblení rohů
              ),
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: const Column(
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
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: borderBorder,
                borderRadius: BorderRadius.circular(7), // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
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
                border: borderBorder,
                borderRadius: BorderRadius.circular(7), // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
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
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: borderBorder,
                borderRadius: BorderRadius.circular(7), // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
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
                border: borderBorder,
                borderRadius: BorderRadius.circular(7), // Zaoblení rohů
              ),
              padding: globalPadding,
              child: const Column(
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
        ),
      ],
    );
  }
}
