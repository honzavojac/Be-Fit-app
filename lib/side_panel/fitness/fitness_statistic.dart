import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:provider/provider.dart';

class FitnessStatistic extends StatefulWidget {
  const FitnessStatistic({super.key});

  @override
  State<FitnessStatistic> createState() => _FitnessStatisticState();
}

class _FitnessStatisticState extends State<FitnessStatistic> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<SplitStartedCompleted> data = [];
  Future<void> loadData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    data = await dbFitness.SelectAllHistoricalData(9);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Statistics')),
      body: Column(
        children: [
          const SizedBox(height: 100),
          AspectRatio(
            aspectRatio: 2.2,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(mainData()),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 8,
      decoration: TextDecoration.none,
      color: ColorsProvider.color_2,
    );
    Widget text;
    data.sort((a, b) => a.supabaseIdStartedCompleted!.compareTo(b.supabaseIdStartedCompleted!));
    if (value.toInt() < data.length) {
      text = Text(data[value.toInt()].createdAt.toString().replaceRange(10, null, "").replaceAll(RegExp(r"-"), ".").replaceRange(0, 5, ""), style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      decoration: TextDecoration.none,
      color: Colors.black,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10 kg';
        break;
      case 20:
        text = '20 kg';
        break;
      case 30:
        text = '30 kg';
        break;
      case 40:
        text = '40 kg';
        break;
      case 5000:
        text = '5000 kg';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  int i = 0;
  List<FlSpot> spots = [];
  int maxHeight = 0;
  int minHeight = 9999999999999;
  sumOfWeightReps() {
    for (var element in data) {
      print(element.printSplitStartedCompleted());
      int sum = 0;
      for (var element in element.exerciseData!) {
        print("${element.weight}   ${element.reps}");
        sum = sum + (element.weight! * element.reps!);
      }
      if (sum > maxHeight) {
        maxHeight = sum;
      }
      if (sum < minHeight) {
        minHeight = sum;
      }
      spots.add(FlSpot(i.toDouble(), sum.toDouble()));
      i++;
    }
  }

  LineChartData mainData() {
    switch (1) {
      case 1:
        sumOfWeightReps();
        break;
      default:
        sumOfWeightReps();
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxHeight / 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Color.fromARGB(255, 77, 69, 55),
        ),
      ),
      minX: 0,
      maxX: i.toDouble() - 1,
      minY: minHeight.toDouble() - 1500,
      maxY: maxHeight.toDouble() + 1000,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: ColorsProvider.color_2,
          // gradient: const LinearGradient(
          //   colors: [
          //     Colors.green,
          //   ],
          // ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          // belowBarData: BarAreaData(
          //     // show: true,
          //     // gradient: LinearGradient(
          //     //   colors: [const Color.fromARGB(90, 76, 175, 79), const Color.fromARGB(92, 33, 149, 243), const Color.fromARGB(113, 244, 67, 54)],
          //     // ),
          //     ),
        ),
      ],
    );
  }
}
