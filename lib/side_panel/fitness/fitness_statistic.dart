import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:provider/provider.dart';

class FitnessStatistic extends StatefulWidget {
  FitnessStatistic({super.key});

  @override
  State<FitnessStatistic> createState() => _FitnessStatisticState();
}

class _FitnessStatisticState extends State<FitnessStatistic> with TickerProviderStateMixin {
  int touchedIndex = -1;
  Map<int, int> prePieData = {};
  List<PieChartDataModel> pieData = [];
  List<String> zeroPieData = [];

  int allPrePieData = 0;

  bool show = false;

  late TabController _tabController = TabController(length: 0, vsync: this);

  List<SplitStartedCompleted> dataAllSplits = [];

  List<Muscle> muscleList = [];
  List<Exercise> exerciseslist = [];
  List<ExerciseData> exerciseDataList = [];

  // Map to store selected exercise index for each muscle
  Map<int, int> selectedExerciseIndexMap = {};

  bool showAvgWorkVolume = false;
  bool showAvg1RM = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    dataAllSplits = await dbFitness.SelectAllExData();
    dataAllSplits.sort((a, b) => a.supabaseIdStartedCompleted!.compareTo(b.supabaseIdStartedCompleted!));
    muscleList = await dbFitness.SelectMuscles();
    exerciseslist = await dbFitness.SelectExercises();
    exerciseDataList = await dbFitness.SelectExerciseData();
    _tabController = TabController(length: muscleList.length, vsync: this, initialIndex: 0);

    // Inicializace prePieData s klíči pro všechny svaly
    for (var muscle in muscleList) {
      prePieData[muscle.supabaseIdMuscle!] = 0;
    }

    // Zpracování dat pro naplnění prePieData
    for (var splitStartedCompleted in dataAllSplits) {
      Set<int> musclesInSplit = {};

      for (var exData in splitStartedCompleted.exerciseData!) {
        var exercise = exerciseslist.firstWhere((e) => e.supabaseIdExercise == exData.exercisesIdExercise);

        musclesInSplit.add(exercise.musclesIdMuscle!);
      }

      for (var muscleId in musclesInSplit) {
        prePieData[muscleId] = (prePieData[muscleId] ?? 0) + 1;
      }
    }

    // Generování dat pro PieChart
    pieData = generatePieChartData(prePieData, muscleList);
    print(pieData.length);
    for (var pieData in pieData) {
      print(pieData.title);
      if (pieData.value == 0) {
        zeroPieData.add(pieData.title.split('\n').first);

        // print(pieData.title);
      }
    }

    show = true;
    setState(() {});
  }

  List<PieChartDataModel> generatePieChartData(Map<int, int> prePieData, List<Muscle> muscles) {
    List<Color> predefinedColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];

    List<PieChartDataModel> pieData = [];
    int colorIndex = 0;
    Color? lastColor;

    // Calculate the total count
    int total = prePieData.values.fold(0, (sum, count) => sum + count);

    prePieData.forEach((muscleId, count) {
      String muscleName = muscles.firstWhere((muscle) => muscle.supabaseIdMuscle == muscleId).nameOfMuscle!;

      // Ensure the current color is not the same as the last used color
      while (predefinedColors[colorIndex % predefinedColors.length] == lastColor) {
        colorIndex++;
      }

      // Get the color and increment the index
      Color color = predefinedColors[colorIndex % predefinedColors.length];
      colorIndex++;
      lastColor = color;

      // Calculate the percentage and round it
      int percentage = ((count / total) * 100).round();

      pieData.add(PieChartDataModel(
        value: count.toDouble(),
        color: color,
        title: "$muscleName\n$percentage%",
      ));
    });

    return pieData;
  }

  @override
  Widget build(BuildContext context) {
    // var variablesProvider = Provider.of<VariablesProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Statistics')),
      body: show == true
          ? Column(
              children: [
                DefaultTabController(
                  length: muscleList.length,
                  initialIndex: 0,
                  child: Container(
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      indicatorColor: ColorsProvider.color_2,
                      dividerColor: ColorsProvider.color_4,
                      labelColor: ColorsProvider.color_2,
                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      tabs: muscleList.map((record) {
                        return Container(
                          height: 35,
                          constraints: BoxConstraints(minWidth: 80),
                          child: IntrinsicWidth(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0), // 5px padding on each side
                              child: Center(
                                  child: Text(
                                record.nameOfMuscle!,
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              )),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: muscleList.map((record) {
                      List<Exercise> filteredExercises = exerciseslist.where((exercise) => exercise.musclesIdMuscle == record.supabaseIdMuscle).toList();
                      int item = selectedExerciseIndexMap[record.supabaseIdMuscle] ?? 0;
                      int tempIdExercise = -1; // Změněno na int
                      int numberOfEndedSplitStartedCompleted = 0;
                      int numberOfEndedSplitStartedCompletedThisMonth = 0;
                      int numberOfEndedExercise = 0;
                      int numberOfSeries = 0;
                      int numberOfSeriesThisMonth = 0;
                      List<int> exDataEnded = [];
                      List<int> ended = [];
                      DateTime now = DateTime.now();
                      String thisMonth = now.toString().replaceRange(0, 5, "").replaceRange(2, null, "");

                      for (var splitStartedCompleted in dataAllSplits) {
                        String lookedThisMonth = splitStartedCompleted.createdAt!.replaceRange(0, 5, "").replaceRange(2, null, "");

                        for (var exData in splitStartedCompleted.exerciseData!) {
                          for (var i = 0; i < filteredExercises.length; i++) {
                            var exercise = filteredExercises[i];

                            if (exData.exercisesIdExercise == exercise.supabaseIdExercise && record.supabaseIdMuscle == exercise.musclesIdMuscle && !ended.contains(splitStartedCompleted.supabaseIdStartedCompleted)) {
                              numberOfEndedSplitStartedCompleted++;
                              ended.add(splitStartedCompleted.supabaseIdStartedCompleted!);

                              if (thisMonth == lookedThisMonth) {
                                numberOfEndedSplitStartedCompletedThisMonth++;
                              }
                            }
                          }
                        }
                      }
                      int maxWeight = 0;
                      int maxWeightReps = 0;
                      bool setIdExercise = false;
                      Map<int, int> exerciseOccurrences = {};

                      for (var element in exerciseslist) {
                        if (element.musclesIdMuscle == record.supabaseIdMuscle) {
                          exerciseOccurrences[element.supabaseIdExercise!] = 0;
                        }
                      }
                      for (var exData in exerciseDataList) {
                        String lookedThisMonth = exData.time!.replaceRange(0, 5, "").replaceRange(2, null, "");

                        for (var i = 0; i < filteredExercises.length; i++) {
                          var exercise = filteredExercises[i];

                          // Kontrola shody idExercise
                          if (exData.exercisesIdExercise == exercise.supabaseIdExercise && record.supabaseIdMuscle == exercise.musclesIdMuscle) {
                            // Zvýšení počtu výskytů pro dané idExercise
                            if (exerciseOccurrences.containsKey(exData.exercisesIdExercise!)) {
                              exerciseOccurrences[exData.exercisesIdExercise!] = exerciseOccurrences[exData.exercisesIdExercise!]! + 1;
                            } else {
                              exerciseOccurrences[exData.exercisesIdExercise!] = 1;
                            }

                            // Další výpočty, jako v původním kódu
                            if (item == i && !exDataEnded.contains(exData.idStartedCompleted)) {
                              exDataEnded.add(exData.idStartedCompleted!);
                              numberOfEndedExercise++;
                            }
                            if (item == i) {
                              numberOfSeries++;
                              if (thisMonth == lookedThisMonth) {
                                numberOfSeriesThisMonth++;
                              }
                              if (maxWeight <= exData.weight!) {
                                maxWeight = exData.weight!;
                                if (maxWeightReps <= exData.reps!) {
                                  maxWeightReps = exData.reps!;
                                }
                                // maxWeightReps = exData.reps!;
                                print(maxWeightReps);
                              }
                              if (!setIdExercise) {
                                tempIdExercise = exercise.supabaseIdExercise!; // Přiřazení hodnoty přímo jako int
                                setIdExercise = true;
                              }
                            }
                          }
                        }
                      }
                      int totalOccurrences = 0;
                      if (exerciseOccurrences.isNotEmpty) {
                        totalOccurrences = exerciseOccurrences.values.reduce((a, b) => a + b);
                      }

                      Map<int, double> exercisePercentages = exerciseOccurrences.map((id, count) {
                        double percentage = (totalOccurrences > 0) ? (count / totalOccurrences) * 100 : 0.0;
                        return MapEntry(id, percentage);
                      });

// Výpis procent pro kontrolu
                      // print(exercisePercentages.length);
                      // exercisePercentages.forEach((id, percentage) {
                      //   print("Exercise ID: $id, Percentage: ${percentage.toStringAsFixed(2)}%");
                      // });

                      List<FlSpot> spots = [];
                      List<String> date = [];
                      List<FlSpot> spots2 = [];
                      List<String> date2 = [];
                      List<FlSpot> spots3 = [];
                      List<String> date3 = [];
                      List<FlSpot> spots4 = [];
                      List<String> date4 = [];
                      List<FlSpot> spots5 = [];
                      List<String> date5 = [];
                      exerciseStatistic(tempIdExercise, spots, date);
                      avgExerciseStatistic(tempIdExercise, spots3, date3);

                      sumOfWeightReps(spots2, date2, tempIdExercise);
                      statistic1RM(tempIdExercise, spots4, date4);
                      avgStatistic1RM(tempIdExercise, spots5, date5);
                      // int idExercise = int.parse(tempIdExercise.trim());
                      return ListView(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("total workouts"),
                                    SumaryText(numberOfEndedSplitStartedCompleted.toString(), true),
                                  ],
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("workouts this month"),
                                    SumaryText(numberOfEndedSplitStartedCompletedThisMonth.toString(), true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          filteredExercises.isEmpty
                              ? Center(
                                  child: Container(
                                    child: Text(
                                      "no exercises",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    CustomDropdown(filteredExercises, record.supabaseIdMuscle!, item),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("total workouts"),
                                    SumaryText(numberOfEndedExercise.toString(), true),
                                  ],
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("series this month"),
                                    SumaryText(numberOfSeriesThisMonth.toString(), true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("total series"),
                                    SumaryText(numberOfSeries.toString(), true),
                                  ],
                                ),
                              ),
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("avg. series"),
                                    SumaryText("${(numberOfSeries / numberOfEndedExercise).isNaN ? 0 : numberOfSeries / numberOfEndedExercise}", true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 150,
                                child: Column(
                                  children: [
                                    Text("max weight"),
                                    SumaryText("${maxWeight}Kg × ${maxWeightReps.toString()}", false),
                                  ],
                                ),
                              ),
                              // Container(
                              //   width: 150,
                              //   child: Column(
                              //     children: [
                              //       Text("avg. series"),
                              //       SumaryText("${(numberOfSeries / numberOfEndedExercise).isNaN ? 0 : numberOfSeries / numberOfEndedExercise}"),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: Text(
                              "Work volume",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorsProvider.color_2,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          spots.isNotEmpty
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 35.0,
                                            bottom: 10,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showAvgWorkVolume = !showAvgWorkVolume;
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 50,
                                              // height: 27,
                                              decoration: BoxDecoration(
                                                color: !showAvgWorkVolume ? Colors.transparent : ColorsProvider.color_2,
                                                border: Border.all(
                                                  color: ColorsProvider.color_2,
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                                                child: Center(
                                                  child: Text(
                                                    "avg",
                                                    style: TextStyle(
                                                      color: showAvgWorkVolume ? ColorsProvider.color_8 : ColorsProvider.color_2,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AspectRatio(
                                      aspectRatio: 2.2,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: 30,
                                          left: 30,
                                          top: 0,
                                          bottom: 0,
                                        ),
                                        child: spots.isNotEmpty
                                            ? !showAvgWorkVolume
                                                ? graph1(spots, date)
                                                : graph3(spots3, date3)
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("no data"),
                                                ],
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("no data"),
                                    ],
                                  ),
                                ),
                          // const SizedBox(height: 40),

                          Center(
                            child: Text(
                              "1 Rep max (1RM)",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorsProvider.color_2,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          spots.isNotEmpty
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 35.0,
                                            bottom: 10,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showAvg1RM = !showAvg1RM;
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 50,
                                              // height: 27,
                                              decoration: BoxDecoration(
                                                color: !showAvg1RM ? Colors.transparent : ColorsProvider.color_2,
                                                border: Border.all(
                                                  color: ColorsProvider.color_2,
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                                                child: Center(
                                                  child: Text(
                                                    "avg",
                                                    style: TextStyle(
                                                      color: showAvg1RM ? ColorsProvider.color_8 : ColorsProvider.color_2,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AspectRatio(
                                      aspectRatio: 2.2,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: 30,
                                          left: 20,
                                          top: 0,
                                          bottom: 0,
                                        ),
                                        child: spots2.isNotEmpty
                                            ? !showAvg1RM
                                                ? graph4(spots4, date4)
                                                : graph5(spots5, date5)
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("no data"),
                                                ],
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              : Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("no data"),
                                    ],
                                  ),
                                ),

                          Center(
                            child: Text(
                              "Exercises usage percentage",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorsProvider.color_2,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          filteredExercises.isNotEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: BarChartWidget(
                                          exerciseData: exercisePercentages,
                                          exercises: filteredExercises,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              : Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("no data"),
                                    ],
                                  ),
                                ),
                          Center(
                            child: Text(
                              "Muscles usage percentage",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorsProvider.color_2,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              Container(
                                height: 250,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PieChart(
                                        PieChartData(
                                          pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                              setState(() {
                                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                                  touchedIndex = -1;
                                                  return;
                                                }
                                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                              });
                                            },
                                          ),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),

                                          sectionsSpace: 2,
                                          centerSpaceRadius: 40,
                                          sections: showingSections(pieData), // Vaše metoda pro první graf
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "unused muscles:",
                                        style: TextStyle(
                                          color: ColorsProvider.color_2,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: ListView.builder(
                                          itemCount: zeroPieData.length,
                                          itemBuilder: (context, index) {
                                            print(zeroPieData[index]);
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${zeroPieData[index]} 0%",
                                                  style: TextStyle(
                                                      // color: ColorsProvider.color_2,
                                                      ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                // mainChosedData == 0 ? Text("Each split has multiplied their weight and reps") : Text("This graph shows every record (weight * reps) in exercise "),
              ],
            )
          : Container(),
    );
  }

  Widget graph1(List<FlSpot> spots, List<String> date) {
    return LineChart(
      LineChartData(
        maxX: i.toDouble() - 1,
        maxY: maxHeight >= 1000 ? (maxHeight / 100).ceilToDouble() * 100 : (maxHeight / 100).ceilToDouble() * 100 + 100,
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 35,
              showTitles: true,
              interval: maxHeight >= 100 ? 200 : 100,
              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: i >= 10 ? i / 5 : 1,
              getTitlesWidget: (value, meta) => Text("${date[value.toInt()]}"),
            ),
          ),
        ),
        clipData: FlClipData(top: false, bottom: false, left: true, right: true),
        lineBarsData: [
          LineChartBarData(
            color: ColorsProvider.color_2,
            isCurved: true,
            spots: spots,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  color: ColorsProvider.color_8,
                  radius: 3,
                  strokeWidth: 1,
                  strokeColor: ColorsProvider.color_2,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(
          border: Border.all(
            width: 2,
            color: ColorsProvider.color_2,
          ),
        ),
        // gridData: FlGridData(
        //   horizontalInterval: 100,
        //   verticalInterval: 100,
        // ),
      ),
    );
  }

  Widget graph2(List<FlSpot> spots, List<String> date) {
    return LineChart(
      LineChartData(
        maxX: i2.toDouble() - 1,
        maxY: maxHeight2,
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 45,
              showTitles: true,
              interval: 5000,
              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) => Text("${date[value.toInt()]}"),
            ),
          ),
        ),
        clipData: FlClipData(top: false, bottom: true, left: true, right: true),
        lineBarsData: [
          LineChartBarData(
            color: ColorsProvider.color_2,
            isCurved: true,
            spots: spots,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  color: ColorsProvider.color_8,
                  radius: 3,
                  strokeWidth: 1,
                  strokeColor: ColorsProvider.color_2,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(
          border: Border.all(
            width: 2,
            color: ColorsProvider.color_2,
          ),
        ),
        // gridData: FlGridData(
        //   horizontalInterval: 100,
        //   verticalInterval: 100,
        // ),
      ),
    );
  }

  Widget graph3(List<FlSpot> spots, List<String> date) {
    return LineChart(
      LineChartData(
        maxX: i3.toDouble() - 1,
        maxY: maxHeight3 >= 1000 ? (maxHeight3 / 100).ceilToDouble() * 100 : (maxHeight3 / 100).ceilToDouble() * 100 + 100,
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 35,
              showTitles: true,
              interval: maxHeight3 >= 100 ? 200 : 100,
              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: i3 >= 10 ? i3 / 5 : 1,
              getTitlesWidget: (value, meta) => Text("${date[value.toInt()]}"),
            ),
          ),
        ),
        clipData: FlClipData(top: false, bottom: false, left: true, right: true),
        lineBarsData: [
          LineChartBarData(
            color: ColorsProvider.color_2,
            isCurved: true,
            spots: spots,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  color: ColorsProvider.color_8,
                  radius: 3,
                  strokeWidth: 1,
                  strokeColor: ColorsProvider.color_2,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(
          border: Border.all(
            width: 2,
            color: ColorsProvider.color_2,
          ),
        ),
        // gridData: FlGridData(
        //   horizontalInterval: 100,
        //   verticalInterval: 100,
        // ),
      ),
    );
  }

  Widget graph4(List<FlSpot> spots, List<String> date) {
    return LineChart(
      LineChartData(
        maxX: i.toDouble() - 1,
        maxY: (maxHeight4 * 1.2 / 10).ceil() * 10,
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 35,
              showTitles: true,
              interval: maxHeight4 >= 100 ? 200 : 10,
              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: i >= 10 ? i / 5 : 1,
              getTitlesWidget: (value, meta) => Text("${date[value.toInt()]}"),
            ),
          ),
        ),
        clipData: FlClipData(top: false, bottom: false, left: true, right: true),
        lineBarsData: [
          LineChartBarData(
            color: ColorsProvider.color_2,
            isCurved: true,
            spots: spots,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  color: ColorsProvider.color_8,
                  radius: 3,
                  strokeWidth: 1,
                  strokeColor: ColorsProvider.color_2,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(
          border: Border.all(
            width: 2,
            color: ColorsProvider.color_2,
          ),
        ),
        // gridData: FlGridData(
        //   horizontalInterval: 100,
        //   verticalInterval: 100,
        // ),
      ),
    );
  }

  Widget graph5(List<FlSpot> spots, List<String> date) {
    return LineChart(
      LineChartData(
        maxX: i5.toDouble() - 1,
        maxY: (maxHeight5 * 1.2 / 10).ceil() * 10,
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 35,
              showTitles: true,
              interval: maxHeight5 >= 100 ? 50 : 10,
              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: i5 >= 10 ? i5 / 5 : 1,
              getTitlesWidget: (value, meta) => Text("${date[value.toInt()]}"),
            ),
          ),
        ),
        clipData: FlClipData(top: false, bottom: false, left: true, right: true),
        lineBarsData: [
          LineChartBarData(
            color: ColorsProvider.color_2,
            isCurved: true,
            spots: spots,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  color: ColorsProvider.color_8,
                  radius: 3,
                  strokeWidth: 1,
                  strokeColor: ColorsProvider.color_2,
                );
              },
            ),
          ),
        ],
        borderData: FlBorderData(
          border: Border.all(
            width: 2,
            color: ColorsProvider.color_2,
          ),
        ),
        // gridData: FlGridData(
        //   horizontalInterval: 100,
        //   verticalInterval: 100,
        // ),
      ),
    );
  }

  int i = 0;
  double maxHeight = 0;
  double minHeight = double.infinity;

  void exerciseStatistic(int idExercise, List<FlSpot> spots, List<String> date) {
    i = 0;
    maxHeight = 0;
    minHeight = double.infinity;
    spots.clear();
    date.clear();
    List<int> addedIdStartedComplete = [];

    for (var split in dataAllSplits) {
      int sum = 0;
      if (addedIdStartedComplete.contains(split.supabaseIdStartedCompleted)) {
        continue; // Pokud ano, přeskočíme tento split
      }
      addedIdStartedComplete.add(split.supabaseIdStartedCompleted!);

      for (var exData in split.exerciseData!) {
        if (exData.exercisesIdExercise == idExercise && addedIdStartedComplete.contains(exData.idStartedCompleted)) {
          sum = (exData.weight! * exData.reps!);
          spots.add(FlSpot(i.toDouble(), sum.toDouble()));
          String dateDay = "${exData.time!.replaceRange(0, 8, "").replaceRange(2, null, "")}.${exData.time!.replaceRange(0, 5, "").replaceRange(2, null, "")}";
          date.add(dateDay);
          i++;
        }

        if (sum > maxHeight) {
          maxHeight = sum.toDouble();
        }
        if (sum < minHeight) {
          minHeight = sum.toDouble();
        }
      }
    }
    // print("spots: ${spots}");
    // return spots;
    // Debug output to check values
    // print('maxHeight: $maxHeight, minHeight: $minHeight, spots: $spots');
  }

  int i2 = 0;
  double maxHeight2 = 0;
  double minHeight2 = double.infinity;

  sumOfWeightReps(List<FlSpot> spots, List<String> date, int idExercise) {
    i2 = 0;
    maxHeight2 = 0;
    minHeight2 = double.infinity;
    spots.clear();
    List<int> addedItems = [];
    List<SplitStartedCompleted> splitStartedCompletedList = [];
    for (var split in dataAllSplits) {
      List<ExerciseData> exDataList = [];
      for (var exData in split.exerciseData!) {
        if (idExercise == exData.exercisesIdExercise) {
          exDataList.add(exData);
        }
      }
      if (exDataList.isNotEmpty && !addedItems.contains(split.supabaseIdStartedCompleted)) {
        addedItems.add(split.supabaseIdStartedCompleted!);
        splitStartedCompletedList.add(SplitStartedCompleted(
          idStartedCompleted: split.idStartedCompleted,
          createdAt: split.createdAt,
          splitId: split.splitId,
          endedAt: split.endedAt,
          ended: split.ended,
          supabaseIdStartedCompleted: split.supabaseIdStartedCompleted,
          action: split.action,
          exerciseData: exDataList,
        ));
      }
      // Aktualizace maximální a minimální výšky

      // Přidání bodu do seznamu
      // spots.add(FlSpot(i2.toDouble(), sum.toDouble()));
      // i2++;
    }
    for (var splitStartedCompleted in splitStartedCompletedList) {
      // print(splitStartedCompleted.supabaseIdStartedCompleted);
      double sum = 0;
      for (var exData in splitStartedCompleted.exerciseData!) {
        sum += (exData.weight! * exData.reps!);
      }
      spots.add(FlSpot(i2.toDouble(), sum.toDouble()));
      String dateDay = "${splitStartedCompleted.createdAt!.replaceRange(0, 8, "").replaceRange(2, null, "")}.${splitStartedCompleted.createdAt!.replaceRange(0, 5, "").replaceRange(2, null, "")}";
      date.add(dateDay);
      i2++;
      if (sum > maxHeight2) {
        maxHeight2 = sum;
      }
      if (sum < minHeight2) {
        minHeight2 = sum;
      }
    }
    // Úprava maximální a minimální výšky
    maxHeight2 += 500;
    // minHeight2 -= 1500;
  }

  int i3 = 0;
  double maxHeight3 = 0;
  double minHeight3 = double.infinity;

  void avgExerciseStatistic(int idExercise, List<FlSpot> spots, List<String> date) {
    i3 = 0;
    maxHeight3 = 0;
    minHeight3 = double.infinity;
    spots.clear();
    date.clear();
    List<int> addedIdStartedComplete = [];

    // Mapa pro ukládání sumy a počtu hodnot pro každý den
    Map<String, List<double>> dailyValues = {};

    for (var split in dataAllSplits) {
      if (addedIdStartedComplete.contains(split.supabaseIdStartedCompleted)) {
        continue; // Pokud ano, přeskočíme tento split
      }
      addedIdStartedComplete.add(split.supabaseIdStartedCompleted!);

      for (var exData in split.exerciseData!) {
        if (exData.exercisesIdExercise == idExercise) {
          int sum = exData.weight! * exData.reps!;
          String dateDay = "${exData.time!.substring(8, 10)}.${exData.time!.substring(5, 7)}";

          if (!dailyValues.containsKey(dateDay)) {
            dailyValues[dateDay] = [];
          }
          dailyValues[dateDay]!.add(sum.toDouble());
        }
      }
    }

    for (var entry in dailyValues.entries) {
      double dailySum = entry.value.reduce((a, b) => a + b);
      double dailyAvg = (dailySum / entry.value.length).round().toDouble();

      spots.add(FlSpot(i3.toDouble(), dailyAvg));
      date.add(entry.key);

      if (dailyAvg > maxHeight3) {
        maxHeight3 = dailyAvg;
      }
      if (dailyAvg < minHeight3) {
        minHeight3 = dailyAvg;
      }

      i3++;
    }

    // Debug output to check values
    // print('maxHeight3: $maxHeight3, minHeight3: $minHeight3, spots: $spots');
  }

  int i4 = 0;
  double maxHeight4 = 0;
  double minHeight4 = double.infinity;

  void statistic1RM(int idExercise, List<FlSpot> spots, List<String> date) {
    i4 = 0;
    maxHeight4 = 0;
    minHeight4 = double.infinity;
    spots.clear();
    date.clear();
    List<int> addedIdStartedComplete = [];

    for (var split in dataAllSplits) {
      if (addedIdStartedComplete.contains(split.supabaseIdStartedCompleted)) {
        continue; // Pokud ano, přeskočíme tento split
      }
      addedIdStartedComplete.add(split.supabaseIdStartedCompleted!);

      for (var exData in split.exerciseData!) {
        if (exData.exercisesIdExercise == idExercise && addedIdStartedComplete.contains(exData.idStartedCompleted)) {
          // Vypočítáme 1RM pomocí Epleyova vzorce
          double oneRepMax = exData.weight! * (1 + 0.0333 * exData.reps!);

          // Přidáme hodnotu do seznamu spotů
          spots.add(FlSpot(i4.toDouble(), oneRepMax.round().toDouble()));

          // Vypočítáme datum
          String dateDay = "${exData.time!.substring(8, 10)}.${exData.time!.substring(5, 7)}";
          date.add(dateDay);

          // Aktualizujeme index
          i4++;

          // Aktualizujeme maximální a minimální výšku
          if (oneRepMax > maxHeight4) {
            maxHeight4 = oneRepMax;
          }
          if (oneRepMax < minHeight4) {
            minHeight4 = oneRepMax;
          }
        }
      }
    }

    // Debug output to check values
    // print('maxHeight4: $maxHeight4, minHeight4: $minHeight4, spots: $spots');
  }

  int i5 = 0;
  double maxHeight5 = 0;
  double minHeight5 = double.infinity;

  void avgStatistic1RM(int idExercise, List<FlSpot> spots, List<String> date) {
    i5 = 0;
    maxHeight5 = 0;
    minHeight5 = double.infinity;
    spots.clear();
    date.clear();
    List<int> addedIdStartedComplete = [];

    // Mapa pro ukládání hodnot a počtu pro každý den
    Map<String, List<double>> dailyValues = {};

    for (var split in dataAllSplits) {
      if (addedIdStartedComplete.contains(split.supabaseIdStartedCompleted)) {
        continue; // Pokud ano, přeskočíme tento split
      }
      addedIdStartedComplete.add(split.supabaseIdStartedCompleted!);

      for (var exData in split.exerciseData!) {
        if (exData.exercisesIdExercise == idExercise && addedIdStartedComplete.contains(exData.idStartedCompleted)) {
          // Vypočítáme 1RM pomocí Epleyova vzorce
          double oneRepMax = exData.weight! * (1 + 0.0333 * exData.reps!);

          // Vypočítáme datum
          String dateDay = "${exData.time!.substring(8, 10)}.${exData.time!.substring(5, 7)}";

          // Uložíme hodnotu do mapy
          if (!dailyValues.containsKey(dateDay)) {
            dailyValues[dateDay] = [];
          }
          dailyValues[dateDay]!.add(oneRepMax);
        }
      }
    }

    // Přepočítáme průměrné hodnoty a přidáme do `spots` a `date`
    for (var entry in dailyValues.entries) {
      double dailySum = entry.value.reduce((a, b) => a + b);
      double dailyAvg = dailySum / entry.value.length;

      spots.add(FlSpot(i5.toDouble(), dailyAvg.round().toDouble()));
      date.add(entry.key);

      if (dailyAvg > maxHeight5) {
        maxHeight5 = dailyAvg;
      }
      if (dailyAvg < minHeight5) {
        minHeight5 = dailyAvg;
      }

      i5++;
    }

    // print("spots: ${spots}");
    // Debug output to check values
    // print('maxHeight5: $maxHeight5, minHeight5: $minHeight5, spots: $spots');
  }

  Widget SumaryText(String data, bool? trimText) {
    return Text(
      trimText == true ? "${data.length >= 4 ? data.replaceRange(4, null, "") : data}" : data,
      style: TextStyle(
        color: ColorsProvider.color_2,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget CustomDropdown(List<Exercise> filteredExercises, int muscleId, int selectedExerciseIndex) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        isExpanded: true,
        value: selectedExerciseIndex,
        items: List.generate(
          filteredExercises.length,
          (index) => DropdownMenuItem(
            value: index,
            alignment: Alignment.center,
            child: Text("${filteredExercises[index].nameOfExercise!}"),
          ),
        ).toList(),
        onChanged: (value) {
          setState(() {
            selectedExerciseIndexMap[muscleId] = value!;
          });
        },
        buttonStyleData: ButtonStyleData(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorsProvider.color_2, // Example color
              width: 0.5,
            ),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 17,
          iconEnabledColor: ColorsProvider.color_2, // Example color
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2, color: ColorsProvider.color_2), // Example color
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 0, right: 18),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<PieChartDataModel> data) {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? 100.0 : 75.0;
      const shadows = [
        Shadow(color: Colors.black, blurRadius: 2),
      ];
      final sectionData = data[i];

      return PieChartSectionData(
        color: sectionData.color,
        value: sectionData.value,
        title: sectionData.title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: shadows,
        ),
      );
    });
  }
}

class PieChartDataModel {
  final double value;
  final Color color;
  final String title;

  PieChartDataModel({required this.value, required this.color, required this.title});
}

class BarChartWidget extends StatefulWidget {
  final Map<int, double> exerciseData;
  final List<Exercise> exercises;

  BarChartWidget({required this.exerciseData, required this.exercises});

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  int height = 0;
  @override
  Widget build(BuildContext context) {
    double maxValue = widget.exerciseData.values.isNotEmpty ? widget.exerciseData.values.reduce((a, b) => a > b ? a : b) : 0;

    if (maxValue <= 25) {
      height = 25;
    } else if (maxValue <= 50) {
      height = 50;
    } else if (maxValue <= 70) {
      height = 70;
    } else if (maxValue <= 100) {
      height = 100;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          barGroups: _buildBarGroups(
            height.toDouble(),
            touchedIndex,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 100,
                getTitlesWidget: _getBottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                interval: 10,
                getTitlesWidget: _getLeftTitles,
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceBetween,
          maxY: height.toDouble(),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              // rotateAngle: -5,
              maxContentWidth: 30, getTooltipColor: (group) => Colors.transparent,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String customText = "$groupIndex";

                customText = "${widget.exerciseData.values.elementAt(groupIndex).round()}%";

                return BarTooltipItem(
                  customText,
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;

                touchedIndex = widget.exerciseData.keys.elementAt(touchedIndex);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // Převeďte hodnotu na celé číslo a zjistěte, zda je v datech
    late int index;
    // print(value);

    for (var i = 0; i < widget.exerciseData.length; i++) {
      if (widget.exerciseData.keys.elementAt(i) == value) {
        // print(true);
        index = i;
      } else {}
    }
    final String? title = widget.exercises.elementAt(index).nameOfExercise;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      angle: 0,
      child: RotatedBox(quarterTurns: 1, child: Text("$title", style: style)),
    );
  }

  List<BarChartGroupData> _buildBarGroups(double maxY, int touchedIndex) {
    return widget.exerciseData.entries.map((entry) {
      final isTouched = entry.key == touchedIndex;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: isTouched ? entry.value.toDouble() + 2 : entry.value.toDouble(),
            color: isTouched ? ColorsProvider.color_1 : ColorsProvider.color_2,
            width: 15,
            borderSide: isTouched ? BorderSide(color: Colors.green.withOpacity(0.7)) : BorderSide(color: Colors.white, width: 0),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value.toInt()}%', style: style),
    );
  }
}
