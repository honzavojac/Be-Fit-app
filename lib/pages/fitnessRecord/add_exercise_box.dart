import 'package:flutter/material.dart';

import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:provider/provider.dart';

import 'new_exercise_box.dart';

class AddExerciseBox extends StatefulWidget {
  const AddExerciseBox({Key? key}) : super(key: key);

  @override
  _AddExerciseBoxState createState() => _AddExerciseBoxState();
}

class _AddExerciseBoxState extends State<AddExerciseBox> {
  List<Map<String, dynamic>> listExercises = [];
  List<String> listTrueExercises = [];
  List<bool> isCheckedList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
    // You can keep this method empty if you don't have any specific initialization.
  }

  Future<void> loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context);
    listExercises = await dbFirebase.getExercises();
    listTrueExercises = await dbFirebase.getTrueSplitExercise();
    print(listExercises);
    print(listTrueExercises);

    isCheckedList = List.generate(listExercises.length, (index) => false);

    for (var i = 0; i < listExercises.length; i++) {
      print(isCheckedList);
      for (var j = 0; j < listTrueExercises.length; j++) {
        if (listExercises[i]["name"] == listTrueExercises[j]) {
          isCheckedList[i] = true;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

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
                          child: ListView.builder(
                            itemCount: listExercises.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(listExercises[index]["name"]),
                                    ),
                                    Checkbox(
                                      value: isCheckedList[index],
                                      onChanged: (value) {
                                        isCheckedList[index] = value ?? false;
                                        print(isCheckedList);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
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
                      for (var i = 0; i < listExercises.length; i++) {
                        if (isCheckedList[i] == true) {
                          print("add");
                          dbFirebase
                              .addTrueSplitExercise(listExercises[i]["name"]);
                        } else if (isCheckedList[i] == false) {
                          print("delete");
                          dbFirebase.DeleteTrueSplitExercise(
                              listExercises[i]["name"]);
                        }
                      }
                      Navigator.of(context).pop();
                      // loadData();
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
