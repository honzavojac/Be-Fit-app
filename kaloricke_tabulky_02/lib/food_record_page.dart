// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class FoodRecordAppBar extends StatelessWidget {
  const FoodRecordAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Záznam jídel'),
    );
  }
}
class FoodRecordScreen extends StatelessWidget {
  const FoodRecordScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Záznam jídel'),
    );
  }
}