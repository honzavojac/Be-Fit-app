import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_bloc.dart';
import 'package:provider/provider.dart';

import '../../bloc/fitness_event.dart';
import '../../data.dart';
import 'dart:async';

class foodStatistic extends StatefulWidget {
  const foodStatistic({super.key});

  @override
  State<foodStatistic> createState() => _foodStatisticState();
}

int selectedSplit = 0;

class _foodStatisticState extends State<foodStatistic> {
  void initState() {
    super.initState();
    // loadData();
  }

//proměnná pro vykreslení žádného widgetu
  // List<MySplit> exercisesData = [];
  // int? idStartedCompleted;
  // late bool foundActiveSplit;
  bool loaded = false;

  Future<void> refresh() async {
    print("*******************************refresh*******************************");
    // selectedSplit = 0;
    setState(() {});
  }

  int? supabaseIdSplit = 0;
  int? idSplitStartedCompleted;

  @override
  Widget build(BuildContext context) {
    // idkIndex = sqfliteSplitList[selectedSplit].supabaseIdSplit!;
    loaded = true;

    return Scaffold(
      body: Container(),
    );
  }
}
