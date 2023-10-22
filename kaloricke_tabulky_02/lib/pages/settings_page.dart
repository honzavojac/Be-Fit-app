// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';


class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Settings'),
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
    return Center(
        child: Text(
            'bude tady obrazovka kde se bude dát podívat na progres u cviků list containerů cviků, místo nastavení které bude v homePageAppbaru'));
  }
}
