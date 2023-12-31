import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database_structure/database.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen();
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Dog>> dogsFuture;
  // final DbController dbController = DbController();

  @override
  void initState() {
    dogsFuture = _loadData();
    super.initState();
  }

  Future<List<Dog>> _loadData() async {
    debugPrint('načítání dat...');
    // await dbController.initDatabase();
    debugPrint(
        'fetching data------------------------------------------------------------');
    return Provider.of<DbController>(context, listen: false).getDogs();

    // return dbController.getDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 25),
              child: TextField(),
            ),
            Container(
              height: 400,
              color: const Color.fromARGB(255, 12, 41, 85),
              child: FutureBuilder<List<Dog>>(
                future: dogsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ); // Display a loading indicator while waiting for data.
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Data loaded successfully, update the UI with the fetched data.
                    List<Dog> dogs = snapshot.data!;
                    return ListView.builder(
                      itemCount: dogs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final Dog dog = dogs[index];
                        return ListTile(
                          title: Text(dog.czfoodname),
                          subtitle:
                              Text('id:${dog.id} ${dog.energykcal} kcal '),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
