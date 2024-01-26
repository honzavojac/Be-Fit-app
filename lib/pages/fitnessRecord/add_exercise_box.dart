import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

import 'new_exercise_box.dart';

class AddExerciseBox extends StatefulWidget {
  const AddExerciseBox({Key? key}) : super(key: key);

  @override
  _AddExerciseBoxState createState() => _AddExerciseBoxState();
}

class _AddExerciseBoxState extends State<AddExerciseBox> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ColorsProvider.color_7,
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
                          child: FutureBuilder<List<Record>>(
                            future: dbHelper.SvalCvikAddBox(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Chyba: ${snapshot.error}'));
                              } else {
                                List<Record> records = snapshot.data!;

                                return ListView.builder(
                                  itemCount: records.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:
                                                Text(records[index].nazevCviku),
                                          ),
                                          Checkbox(
                                            value: records[index].boolCviku,
                                            onChanged: (value) {
                                              dbHelper.UpdateSvalCvik(
                                                  value!,
                                                  records[index].idCviku,
                                                  records[index].idSplitu,
                                                  records[index].idSvalu);

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
                    onPressed: () async {
                      // await dbHelper.InsertOrUpdateSvalCvik();
                      // await dbHelper.SvalCvikAddBox();
                      // for (var i = 0; i < values.length; i++) {
                      //   if (values[i].idCviku != 0) {
                      //     print("object");
                      //   }
                      // }

                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsProvider.color_2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorsProvider.color_8,
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
                        backgroundColor: MaterialStatePropertyAll(
                          ColorsProvider.color_2,
                        ),
                      ),
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
                      child: Text(
                        "New Exercise",
                        style: TextStyle(
                          color: ColorsProvider.color_8,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorsProvider.color_9,
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
