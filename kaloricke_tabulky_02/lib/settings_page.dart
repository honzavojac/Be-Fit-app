// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'globals_variables/nutri_data.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Nastavení'),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionIncremment>(
      builder: (context, nutrition, child) {
        return Column(
          children: [
            Text(
              'Kcal: ${nutrition.kcalData}',
              style: TextStyle(fontSize: 15),
            ),
          ],
        );
      },
    );
  }
}
