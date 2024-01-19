import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

import 'new_exercise_box.dart';

class AddExerciseBox extends StatefulWidget {
  const AddExerciseBox({Key? key}) : super(key: key);

  @override
  _AddExerciseBoxState createState() => _AddExerciseBoxState();
}

class _AddExerciseBoxState extends State<AddExerciseBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: Colors.blue[800],
        ),
        height: 300,
        width: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.amber,
                          child: FutureBuilder<List<Record>>(
                            future: dbHelper.Cviky(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Chyba: ${snapshot.error}'));
                              } else {
                                List<Record> records = snapshot.data!;
                                // Inicializace seznamu isCheckedList_2 na základě počtu záznamů

                                if (dbHelper.isCheckedList_2.isEmpty) {
                                  dbHelper.isCheckedList_2 = List.generate(
                                      records.length, (index) => false);
                                }
                                return ListView.builder(
                                  itemCount: records.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  records[index].nazevCviku)),
                                          Checkbox(
                                            value:
                                                dbHelper.isCheckedList_2[index],
                                            onChanged: (value) {
                                              dbHelper.isCheckedList_2[index] =
                                                  value ?? false;
                                              print(dbHelper.isCheckedList_2);

                                              dbHelper.notList();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 150,
                    height: 35,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber[800])),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: NewExerciseBox(),
                            );
                          },
                        );
                      },
                      child: Text("New Exercise",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
