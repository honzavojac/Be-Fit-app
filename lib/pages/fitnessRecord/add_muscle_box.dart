import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_muscle_box.dart';



class AddMuscleBox extends StatefulWidget {
  const AddMuscleBox({Key? key}) : super(key: key);

  @override
  _AddMuscleBoxState createState() => _AddMuscleBoxState();
}

class _AddMuscleBoxState extends State<AddMuscleBox> {
  // Seznam pro ukládání stavu checkboxů
  var dbFirebase = FirestoreService();
  List<bool> isCheckedList = [];
  @override
  void initState() {
    isCheckedList = isCheckedList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: ColorsProvider.color_7),
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
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: dbFirebase.getMuscles(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Chyba: ${snapshot.error}'));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsProvider.color_2,
                                    ),
                                  ),
                                );
                              } else {
                                List records = snapshot.data!;
                                // Inicializace seznamu isCheckedList na základě počtu záznamů

                                if (isCheckedList.isEmpty) {
                                  isCheckedList = List.generate(
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
                                              child:
                                                  Text(records[index]["name"])),
                                          Checkbox(
                                            value: isCheckedList[index],
                                            onChanged: (value) {
                                              isCheckedList[index] =
                                                  value ?? false;
                                              print("\n\n${isCheckedList}");
                                              setState(() {});
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
                      String finalName = "";
                      // int? posledniIdSplitu = await dbFirebase.PosledniIdSplitu();
                      // print("posledni ID splitu: $posledniIdSplitu");
                      // if (posledniIdSplitu == null) {
                      //   posledniIdSplitu = 1;
                      // } else {
                      //   posledniIdSplitu = posledniIdSplitu + 1;
                      // }
                      for (var i = 0; i < isCheckedList.length; i++) {
                        if (isCheckedList[i] == true) {
                          // String? a = await dbFirebase.SearchSval(i + 1);
                          // finalName = finalName + a! + " ";
                          print(finalName);

                          // await dbFirebase.InsertSplitSval(
                          //     posledniIdSplitu, i + 1);
                        }
                      }
                      if (isCheckedList.contains(true)) {
                        // await dbFirebase.InsertSplit(finalName);
                        isCheckedList = [];
                      }
                      dbFirebase.addSplit("split_1");
                      Navigator.of(context).pop();
                      // dbFirebase.SplitSval();
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
                              child: NewMuscleBox(),
                            );
                          },
                        );
                      },
                      child: Text(
                        "New Muscle",
                        style: TextStyle(color: ColorsProvider.color_8),
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
