// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Nastavení'),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Nastavení'),
    );
  }
}
