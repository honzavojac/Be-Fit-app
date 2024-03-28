import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
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

  //jednodušší proměnné z provideru

  String today = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context);
    today = "${dbFirebase.now.day}.${dbFirebase.now.month}.${dbFirebase.now.year}";
    dbFirebase.commentExercise = "";

    selectedMuscle = await dbFirebase.selectedMuscle;
    chosedExercise = await dbFirebase.chosedExercise;

    // Načtení dat z Firebase do providerů pro zobrazení hodnot po zavření aplikace
    try {
      weightControllers = {};
      repsControllers = {};
      var exerciseDate = dbFirebase.fullMapExercises[dbFirebase.splitName][selectedMuscle][chosedExercise]?["date"]?[today];
      dbFirebase.exerciseData = {
        "${dbFirebase.selectedMuscle}": {dbFirebase.chosedExercise: {}}
      };
      for (var i = 0; i < exerciseDate["series"].length; i++) {
        var splitNumber = exerciseDate["series"].keys.toList()[i]; //set key (set 1)
        var splitvalues = exerciseDate["series"].values.toList()[i]; // values of set ({special: normal, difficulty: 1, reps: null, weight: null})

        dbFirebase.exerciseData[dbFirebase.selectedMuscle][dbFirebase.chosedExercise].addAll({splitNumber: splitvalues});
      }
      //přičtení
    } catch (e) {
      print("chyba: $e");

      print("Vytváření prvního řádku ");

      dbFirebase.exerciseData = {
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
      };
      weightControllers["set 1"] = TextEditingController();
      repsControllers["set 1"] = TextEditingController();
    }

    // Nastavení controllerů
    dbFirebase.exerciseData[selectedMuscle]?.forEach((key, value) {
      value?.forEach((splitNumber, data) {
        weightControllers["$splitNumber"] = TextEditingController(text: data["weight"]?.toString());
        repsControllers["$splitNumber"] = TextEditingController(text: data["reps"]?.toString());
      });
    });

    setState(() {});
  }

  recount() {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: false);

    // Získání seznamu klíčů
    List<dynamic> exexrciseKeys = dbFirebase.exerciseData[selectedMuscle][chosedExercise].keys.toList();

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

    // Vytvořit nové klíče ve formátu "set {setNumber}" a odstranit staré klíče
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

    // Vytvořit nové klíče ve formátu "set {setNumber}" a odstranit staré klíče
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
    // setState(() {});
  }

  saveData() {
    // uloží data do fullmapexercises odkud se bude brát vše pro zobrazování hodnot
    //
    //
    //
    //
    //
    //
    //
  }
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
              '${dbFirebase.chosedExercise}',
              style: TextStyle(fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
            ),
            // GestureDetector(
            //   child: Container(
            //       decoration: BoxDecoration(
            //         color: ColorsProvider.color_2,
            //         border: Border.all(color: Colors.black),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
            //         child: Text(
            //           "Specials",
            //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            //         ),
            //       )),
            //   onTap: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return Center(
            //           child: SpecialBox(),
            //         );
            //       },
            //     );
            //   },
            // )
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
          onPressed: () {
            dbFirebase.SaveExerciseData();

            Navigator.of(context).pop(true);
            setState(() {});
            dbFirebase.enableSync();
            setState(() {});
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
                                    shrinkWrap: false,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: dbFirebase.exerciseData[dbFirebase.selectedMuscle]?[dbFirebase.chosedExercise]?.length,
                                    itemBuilder: (context, index) {
                                      int setNumber = index + 1;
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
                                                      Text("${setNumber}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Container(
                                                    height: 35,
                                                    child: Center(
                                                      child: TextField(
                                                        onChanged: (value) async {
                                                          dbFirebase.exerciseData[dbFirebase.selectedMuscle]?[dbFirebase.chosedExercise]?["set ${setNumber}"]["weight"] = value;
                                                          print(value);
                                                          if (weightControllers["set ${setNumber}"]!.text.isNotEmpty) {
                                                            await dbFirebase.SaveExerciseData();
                                                            print("object");
                                                          }

                                                          //uložení dat do offline firebase
                                                        },
                                                        controller: weightControllers["set ${setNumber}"],
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
                                                        onChanged: (value) async {
                                                          dbFirebase.exerciseData[selectedMuscle]?[chosedExercise]?["set ${setNumber}"]["reps"] = value;
                                                          print(value);
                                                          if (repsControllers["set ${setNumber}"]!.text.isNotEmpty) {
                                                            await dbFirebase.SaveExerciseData();
                                                            print("object");
                                                          }
                                                        },
                                                        controller: repsControllers["set ${setNumber}"],
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
                                                      value: dbFirebase.exerciseData[selectedMuscle]?[chosedExercise]?["set ${setNumber}"]["difficulty"],
                                                      onChanged: (int? value) async {
                                                        dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${setNumber}"]["difficulty"] = value!;
                                                        setState(() {});
                                                        await dbFirebase.SaveExerciseData();
                                                      },
                                                      items: List.generate(
                                                        5,
                                                        (index) {
                                                          int hardness = index + 1;
                                                          return DropdownMenuItem(
                                                            value: index + 1,
                                                            child: Text(
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: hardness == 1
                                                                    ? Colors.green
                                                                    : hardness == 2
                                                                        ? Colors.lightGreen
                                                                        : hardness == 3
                                                                            ? Colors.yellow
                                                                            : hardness == 4
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
                                                    print("odstranění hodnoty: ${setNumber}");
                                                    dbFirebase.exerciseData[selectedMuscle]?[chosedExercise]?.remove("set ${setNumber}");
                                                    // await dbFirebase.DeleteExerciseData(dbFirebase.splitName, dbFirebase.chosedMuscle!, dbFirebase.chosedExercise!, "set ${setNumber}");
                                                    dbFirebase.fullMapExercises[dbFirebase.splitName][dbFirebase.selectedMuscle][dbFirebase.chosedExercise]["date"][dbFirebase.time]["series"].remove("set ${setNumber}");

                                                    print(dbFirebase.exerciseData);
                                                    weightControllers.remove("set ${setNumber}");
                                                    repsControllers.remove("set ${setNumber}");

                                                    await recount();
                                                    await dbFirebase.SaveExerciseData();
                                                    // setState(() {});
                                                    print(weightControllers);
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
                    onTap: () async {
                      int length = dbFirebase.exerciseData[selectedMuscle][chosedExercise].length;

                      if (length == 0) {
                        print("vytvoření prvního řádku");
                        dbFirebase.exerciseData = {
                          "${chosedExercise}": {"set 1": {}}
                        };

                        weightControllers["set 1"] = TextEditingController();
                        repsControllers["set 1"] = TextEditingController();
                        // setState(() {});
                      } else {
                        //přidání další položky v listview.builder
                        print("1:   ${dbFirebase.exerciseData}");
                        dbFirebase.exerciseData[selectedMuscle][chosedExercise]["set ${length + 1}"] = {
                          "weight": null,
                          "reps": null,
                          "difficulty": 1,
                          "special": "normal",
                        };

                        weightControllers["set ${length + 1}"] = TextEditingController();
                        repsControllers["set ${length + 1}"] = TextEditingController();
                      }
                      print("2:   ${dbFirebase.exerciseData}");
                      await dbFirebase.SaveExerciseData();
                      setState(() {});
                    },
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
                    onTap: () async {
                      // await dbFirebase.SaveExerciseData();
                      // print(dbFirebase.exerciseData);
                      // print(dbFirebase.fullMapExercises);
                      //fullmapexercises: split_name  muscle_name   exercise_name   date  1.1.2024  (comment, set_1 (special, difficulty, reps, weight))
                      // print("full map exercises:    ${dbFirebase.fullMapExercises}");
                      dbFirebase.LoadExerciseData("pull", "back", "vodorovné přítahy na kladce");
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
