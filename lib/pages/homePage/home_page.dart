// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, sort_child_properties_last, avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/date_row.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'data_boxes.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // void printNavigationStack(BuildContext context) {
  //   print('Navigation stack:');
  //   Navigator.popUntil(context, (route) {
  //     print(route.settings);
  //     return true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<SupabaseProvider>(context);

    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              dateRow(),
              const SizedBox(
                height: 20,
              ),
              dataBoxes(),
            ],
          ),
        ),
      ],
    );
  }
}
