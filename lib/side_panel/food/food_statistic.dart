import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:provider/provider.dart';

class foodStatistic extends StatefulWidget {
  const foodStatistic({super.key});

  @override
  State<foodStatistic> createState() => _foodStatisticState();
}

class _foodStatisticState extends State<foodStatistic> {
  List<NutriIntake> nutriIntake = [];
  List<Food> foodList = [];
  load() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntake = await dbFitness.SelectNutriIntakes();
    foodList = await dbFitness.SelectFood();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food statistic"),
      ),
      body: Container(
        child: Column(
          children: [
            Text(nutriIntake.length.toString()),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        key: Key('$index'),
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 50, color: Colors.blue, child: Text("${nutriIntake[index].supabaseIdNutriIntake} || ${nutriIntake[index].idNutriIntake}")),
                      );
                    },
                    itemCount: nutriIntake.length,
                    onReorder: (oldIndex, newIndex) {
                      print("object");
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
