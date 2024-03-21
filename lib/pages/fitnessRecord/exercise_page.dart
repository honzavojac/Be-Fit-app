import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/special_box.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Map<String, TextEditingController> weightControllers = {};
  Map<String, TextEditingController> repsControllers = {};
  TextEditingController commentExercise = TextEditingController();
  String? selectedMuscle;
  String? chosedExercise;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context);
    dbFirebase.commentExercise = "";

    selectedMuscle = await dbFirebase.selectedMuscle;
    chosedExercise = await dbFirebase.chosedExercise;
    print(selectedMuscle);
    if (dbFirebase.exerciseData[chosedExercise] == null) {
      print("vytváření prvního řádku ");
      dbFirebase.exerciseData.addAll({
        "$selectedMuscle": {
          "$chosedExercise": {
            "set 1": {
              "weight": null,
              "reps": null,
              "difficulty": 1,
              "special": "normal",
            }
          }
        }
      });

      print(dbFirebase.exerciseData[selectedMuscle][chosedExercise]);

      weightControllers["set 1"] = TextEditingController();
      repsControllers["set 1"] = TextEditingController();
      setState(() {});
    }
    for (var i = 0; i < dbFirebase.exerciseData[selectedMuscle][chosedExercise].length; i++) {
      print(i);
      weightControllers["set ${i + 1}"] = TextEditingController();
      repsControllers["set ${i + 1}"] = TextEditingController();
      if (dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${i + 1}"]["weight"] != null) {
        weightControllers["set ${i + 1}"]!.text = dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${i + 1}"]["weight"];
      }
      if (dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${i + 1}"]["reps"] != null) {
        repsControllers["set ${i + 1}"]!.text = dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${i + 1}"]["reps"];
      }
    }
  }

  recount() {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: false);

    // Získání seznamu klíčů
    List<String> exexrciseKeys = dbFirebase.exerciseData[selectedMuscle][chosedExercise].keys.toList();

    // Seřazení klíčů podle jejich číselné hodnoty
    exexrciseKeys.sort((a, b) => int.parse(a.substring(4)).compareTo(int.parse(b.substring(4))));

    // Přečíslování klíčů
    for (int i = 0; i < exexrciseKeys.length; i++) {
      String oldKey = exexrciseKeys[i];
      String newKey = "set ${i + 1}";

      // Přejmenování klíče v mapě
      dbFirebase.exerciseData[selectedMuscle][chosedExercise][newKey] = dbFirebase.exerciseData[selectedMuscle][chosedExercise].remove(oldKey);
    }
    //pro controlery

    List<String> weightKeys = weightControllers.keys.toList();

    // Seřadit klíče podle jejich číselného řádu
    weightKeys.sort((a, b) => int.parse(a.substring(4)).compareTo(int.parse(b.substring(4))));

    // Vytvořit nové klíče ve formátu "set {index + 1}" a odstranit staré klíče
    for (var i = 0; i < weightKeys.length; i++) {
      String oldKey = weightKeys[i];
      String newKey = "set ${i + 1}";

      // Získání hodnoty pro starý klíč
      TextEditingController controller = weightControllers[oldKey]!;

      // Odstranit starý klíč
      weightControllers.remove(oldKey);

      // Přidat nový klíč s odpovídající hodnotou
      weightControllers[newKey] = controller;
    }
    //
    //
    //
    List<String> repsKeys = repsControllers.keys.toList();

    // Seřadit klíče podle jejich číselného řádu
    repsKeys.sort((a, b) => int.parse(a.substring(4)).compareTo(int.parse(b.substring(4))));

    // Vytvořit nové klíče ve formátu "set {index + 1}" a odstranit staré klíče
    for (var i = 0; i < repsKeys.length; i++) {
      String oldKey = repsKeys[i];
      String newKey = "set ${i + 1}";

      // Získání hodnoty pro starý klíč
      TextEditingController controller = repsControllers[oldKey]!;

      // Odstranit starý klíč
      repsControllers.remove(oldKey);

      // Přidat nový klíč s odpovídající hodnotou
      repsControllers[newKey] = controller;
    }
  }

  saveData() {}

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorsProvider.color_2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${chosedExercise}',
              style: TextStyle(fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
            ),
            GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                    color: ColorsProvider.color_2,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                    child: Text(
                      "Specials",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )),
              onTap: () {
                print("new special");
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: SpecialBox(),
                    );
                  },
                );
              },
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
          onPressed: () {
            dbFirebase.enableSync();
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: Text(
            //         'Do you want save your values?',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 20,
            //         ),
            //       ),
            //       actions: <Widget>[
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             Expanded(
            //               child: GestureDetector(
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     border: Border.all(
            //                       color: Colors.black,
            //                       width: 2,
            //                     ),
            //                     borderRadius: BorderRadius.circular(17),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(5.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Text("Delete"),
            //                         Icon(
            //                           Icons.delete,
            //                           color: ColorsProvider.color_5,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 onTap: () {
            //                   Navigator.of(context).pop();
            //                 },
            //               ),
            //             ),
            //             SizedBox(
            //               width: 30,
            //             ),
            //             Expanded(
            //               child: GestureDetector(
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     border: Border.all(
            //                       color: Colors.black,
            //                       width: 2,
            //                     ),
            //                     borderRadius: BorderRadius.circular(17),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(5.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Text("Save"),
            //                         Icon(
            //                           Icons.save_rounded,
            //                           color: Colors.green,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 onTap: () {
            //                   Navigator.of(context).pop();
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     );
            //   },
            // );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 30,
                                        child: Center(
                                            child: Text(
                                          "Set",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ))),
                                    Container(
                                        width: 60,
                                        child: Center(
                                            child: Text(
                                          "Weight",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ))),
                                    Container(
                                        width: 60,
                                        child: Center(
                                            child: Text(
                                          "Reps",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ))),
                                    Container(
                                        width: 60,
                                        child: Center(
                                            child: Text(
                                          "difficulty",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ))),
                                    Container(
                                        width: 50,
                                        child: Center(
                                            child: Text(
                                          "Special",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ))),
                                    SizedBox(
                                      width: 25,
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    // shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: dbFirebase.exerciseData[selectedMuscle][chosedExercise].length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 30,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("${index + 1}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Container(
                                                    height: 35,
                                                    child: Center(
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${index + 1}"]["weight"] = value;

                                                          //uložení dat do offline firebase
                                                        },
                                                        controller: weightControllers["set ${index + 1}"],
                                                        keyboardType: TextInputType.numberWithOptions(),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(3),
                                                          FilteringTextInputFormatter.allow(
                                                            RegExp(r'[0-9]'),
                                                          )
                                                        ],
                                                        decoration: const InputDecoration(
                                                          labelStyle: TextStyle(
                                                            color: ColorsProvider.color_1,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 3.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Container(
                                                    height: 35,
                                                    child: Center(
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${index + 1}"]["reps"] = value;
                                                          //uložení dat do offline firebase
                                                        },
                                                        controller: repsControllers["set ${index + 1}"],
                                                        keyboardType: TextInputType.numberWithOptions(),
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(3),
                                                          FilteringTextInputFormatter.allow(
                                                            RegExp(r'[0-9]'),
                                                          )
                                                        ],
                                                        decoration: const InputDecoration(
                                                          labelStyle: TextStyle(
                                                            color: ColorsProvider.color_1,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(12),
                                                            ),
                                                            borderSide: BorderSide(
                                                              color: ColorsProvider.color_2,
                                                              width: 3.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton2<int>(
                                                      isExpanded: true,
                                                      value: dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${index + 1}"]["difficulty"],
                                                      onChanged: (int? value) {
                                                        dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${index + 1}"]["difficulty"] = value!;
                                                        setState(() {});
                                                      },
                                                      items: List.generate(
                                                        5,
                                                        (index) {
                                                          int difficulty = index + 1;
                                                          return DropdownMenuItem(
                                                            value: index + 1,
                                                            child: Text(
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: difficulty == 1
                                                                    ? Colors.green
                                                                    : difficulty == 2
                                                                        ? Colors.lightGreen
                                                                        : difficulty == 3
                                                                            ? Colors.yellow
                                                                            : difficulty == 4
                                                                                ? Colors.orange
                                                                                : Colors.red,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                              (index + 1).toString(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 50,
                                                  child: Text("Normal"),
                                                ),
                                                GestureDetector(
                                                  child: Container(
                                                    width: 25,
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: ColorsProvider.color_5,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    //vymazat hodnotu
                                                    print("odstranění hodnoty: ${index + 1}");
                                                    dbFirebase.exerciseData[selectedMuscle][chosedExercise].remove("set ${index + 1}");
                                                    weightControllers.remove("set ${index + 1}");
                                                    repsControllers.remove("set ${index + 1}");
                                                    await recount();
                                                    setState(() {});
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 150),
                            child: TextField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'Enter your description',
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(height: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Container(
                            child: Text("data"),
                          ),
                          onTap: () {},
                        ),
                        GestureDetector(
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              color: ColorsProvider.color_2,
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                "Add set",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                          onTap: () {
                            int length = dbFirebase.exerciseData[selectedMuscle][chosedExercise].length;
                            if (length == 0) {
                              print("vytvoření prvního řádku");
                              dbFirebase.exerciseData = {
                                "${chosedExercise}": {"set 1": {}}
                              };
                              print(dbFirebase.exerciseData[selectedMuscle][chosedExercise]);

                              weightControllers["set 1"] = TextEditingController();
                              repsControllers["set 1"] = TextEditingController();
                              setState(() {});
                            } else {
                              //přidání další položky v listview.builder

                              dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${length + 1}"] = {
                                "weight": null,
                                "reps": null,
                                "difficulty": 1,
                                "special": "normal",
                              };

                              weightControllers["set ${length + 1}"] = TextEditingController();
                              repsControllers["set ${length + 1}"] = TextEditingController();
                              setState(() {});
                            }
                            // else if (weightControllers["set $length"]!
                            //             .text
                            //             .isEmpty ==
                            //         true ||
                            //     repsControllers["set $length"]!.text.isEmpty ==
                            //         true) {
                            //   print("textfield je null");
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text('Warning !!!'),
                            //         content: Container(
                            //           height: 100,
                            //           child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Text(
                            //                 'Text field is empty',
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 20,
                            //                 ),
                            //               ),
                            //               Text(
                            //                 'Please enter a value or, if it is a value of your body, enter 0.',
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         actions: <Widget>[
                            //           Container(
                            //             height: 40,
                            //             child: TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //               },
                            //               child: Text("OK"),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                  ExpandChild(
                    indicatorIconColor: ColorsProvider.color_2,
                    indicatorBuilder: (context, onTap, isExpanded) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: ColorsProvider.color_2,
                                    borderRadius: BorderRadius.circular(17),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  child: InkWell(
                                    // highlightColor: Colors.amber,
                                    // hoverColor: Colors.amber,
                                    // focusColor: Colors.amber,
                                    // overlayColor: MaterialStatePropertyAll(Colors.amber),

                                    onTap: onTap,
                                    splashColor: Colors.black,

                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 2, 2, 2),
                                      child: Container(
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 2),
                                              child: Text(
                                                !isExpanded ? "Expand recent entries" : "Close recent entries",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              isExpanded ? Icons.expand_more : Icons.expand_less,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Container(
                            color: Colors.amber,
                            height: 60,
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      Text("set"),
                                      Text("weight"),
                                      Text("reps"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: Colors.green,
                                        width: 35,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${index + 1}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text("15"),
                                            Text("15"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Container(
                            color: Colors.amber,
                            height: 60,
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      Text("set"),
                                      Text("weight"),
                                      Text("reps"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: Colors.green,
                                        width: 35,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${index + 1}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text("15"),
                                            Text("15"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Container(
                            color: Colors.amber,
                            height: 60,
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      Text("set"),
                                      Text("weight"),
                                      Text("reps"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: Colors.green,
                                        width: 35,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${index + 1}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text("15"),
                                            Text("15"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 65,
                      color: Colors.orange,
                      child: Center(
                        child: Text(
                          "Save".toString().toUpperCase(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    onTap: () {
                      // // výpis exercise dat
                      // print("dbFirebase.exerciseData:");
                      // dbFirebase.exerciseData[selectedMuscle][chosedExercise].forEach((key, value) {
                      //   print("$key: ${"weight: ${value["weight"]} reps: ${value["reps"]} difficulty: ${value["difficulty"]}"}");
                      // });

                      // //výpis controlerů
                      // print("weightControllers: |${weightControllers.entries.map((entry) => "${entry.key}: ${entry.value.text}").join("| ")}|");
                      // print("repsControllers:   |${repsControllers.entries.map((entry) => "${entry.key}: ${entry.value.text}").join("| ")}|");

                      // print(dbFirebase.exerciseData);

                      dbFirebase.LoadExerciseData();
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
