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
  load() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    nutriIntake = await dbFitness.SelectNutriIntakes();
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
              child: ListView.builder(
                itemCount: nutriIntake.length,
                itemBuilder: (context, index) {
                  return Text("${nutriIntake[index].supabaseIdNutriIntake}  ${nutriIntake[index].idFood}  ${nutriIntake[index].idNutriIntake} ${(nutriIntake[index].supabaseIdNutriIntake == nutriIntake[index].idNutriIntake) ? "true" : "*****"}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
