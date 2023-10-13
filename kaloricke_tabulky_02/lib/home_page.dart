// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Domovská obrazovka'),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: Text('data'),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //color: Colors.amber,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: Text('data'),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //color: Colors.amber,
            ),
          ],
        )
      ],
    );
  }
}
