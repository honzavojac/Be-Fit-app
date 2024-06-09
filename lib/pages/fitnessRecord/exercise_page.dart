import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  final int splitIndex;
  final int muscleIndex;
  final int exerciseIndex;
  final Function() notifyParent;
  const ExercisePage({super.key, required this.splitIndex, required this.muscleIndex, required this.exerciseIndex, required this.notifyParent});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with WidgetsBindingObserver {
  bool showWidget = false;
  late List<ExerciseData> exerciseData;
  List<TextEditingController> weightController = [];
  List<TextEditingController> repsController = [];
  List<int> weight = [];
  List<int> reps = [];
  List<int> difficultyController = [];
  late String nameOfExercise;
  late int idExercise;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("initState called");
    load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Aplikace přechází do pozadí nebo je neaktivní, zde můžete uložit data

      if (mounted) {
        try {
          saveDataToDatabase();
        } catch (e) {
          print("chyba v exercisePage při vkládání dat změněním stavu aplikace (zavřená app): $e");
        }
      }
    }
  }

  saveDataToDatabase() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    await dbSupabase.actionExerciseData(exerciseData, idExercise);
    print("lifecyclestate");
    load();
    setState(() {});
  }

  load() {
    print("load called");
    if (mounted) {
      var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
      nameOfExercise = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises.nameOfExercise;
      idExercise = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises.idExercise;

      exerciseData = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises.exerciseData!;

      weightController.clear();
      repsController.clear();
      difficultyController.clear();

      for (var i = 0; i < exerciseData.length; i++) {
        //nastavení controlerů na hodnoty z exerciseData
        weightController.add(TextEditingController(text: exerciseData[i].weight.toString()));
        repsController.add(TextEditingController(text: exerciseData[i].reps.toString()));
        difficultyController.add(exerciseData[i].difficulty);
        // print(i);
        // print(weightController[i].text.trim());
        // print(repsController[i].text.trim());
        // print("aaaaaaaaaaaaaaaaaaa ${exerciseData[i].id}");
      }
      showWidget = true;
    }
  }

  actionExerciseRow(int idData, int value) {
    //0 nic se nestane
    //1 insert
    //2 update
    //3 delete
    //4 nebude se insertovat
    for (var i = 0; i < exerciseData.length; i++) {
      if (exerciseData[i].operation == null) {
        exerciseData[i].operation = 0;
      }
      if (idData == exerciseData[i].id) {
        if (value == 3 && exerciseData[i].operation == 1) {
          //nebude se insertrovat
          exerciseData[i].operation = 4;
        } else if (value == 2 && exerciseData[i].operation == 1) {
          //nothing, hodnota se jen insertuje
        } else {
          //
          exerciseData[i].operation = value;
        }
      }
      // print(exerciseData[i].id);
    }
  }

  saveValues(List<ExerciseData> data) {
    for (var i = 0; i < exerciseData.length; i++) {
      for (var j = 0; j < data.length; j++) {
        if (data[j].id == exerciseData[i].id) {
          try {
            exerciseData[i].weight = int.parse(weightController[j].text.trim());
            exerciseData[i].reps = int.parse(repsController[j].text.trim());
            exerciseData[i].difficulty = difficultyController[j];
          } catch (e) {}
        }
      }
    }
  }

  List<ExerciseData> finalData = [];
  updateExerciseData() {
    print("start");
    saveValues(finalData);

    finalData = [];
    weightController = [];
    repsController = [];
    difficultyController = [];

    for (var i = 0; i < exerciseData.length; i++) {
      //odstranění hodnot
      if (exerciseData[i].operation == 3 || exerciseData[i].operation == 4) {
        //nothing
      } else {
        finalData.add(exerciseData[i]);
        weightController.add(TextEditingController(text: exerciseData[i].weight.toString()));

        repsController.add(TextEditingController(text: exerciseData[i].reps.toString()));
        difficultyController.add(exerciseData[i].difficulty);
      }
      // print(exerciseData[i].operation);
    }
    for (var i = 0; i < finalData.length; i++) {
      // print(finalData[i].id);
    }
    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    final _sheet = GlobalKey();
    final _controller = DraggableScrollableController();
    List<ExerciseData> finalExerciseData = updateExerciseData();

    if (showWidget == false) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: ColorsProvider.color_3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${nameOfExercise}',
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
                onTap: () {},
              )
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            print("focus changed");
          },
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
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
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "Weight",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "Reps",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "difficulty",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      child: Center(
                                        child: Text(
                                          "Special",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                key: _sheet,
                initialChildSize: 0.1,
                maxChildSize: 0.7,
                minChildSize: 0.1,
                expand: true,
                snap: false,
                snapSizes: [
                  0.2,
                ],
                snapAnimationDuration: Duration(milliseconds: 200),
                controller: _controller,
                builder: (context, scrollController) {
                  return DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(123, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: 90,
                            // color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Swipe up',
                                        style: TextStyle(color: ColorsProvider.color_1, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 25,
                                        color: ColorsProvider.color_1,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 40,
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle_outline_outlined, color: ColorsProvider.color_2, size: 35),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList.list(
                          children: [
                            SizedBox(
                              height: 10,
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
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return PopScope(
        onPopInvoked: (didPop) async {
          if (mounted) {
            await saveDataToDatabase();
          }
          await widget.notifyParent;
          print("uloženo");
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: ColorsProvider.color_2,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${nameOfExercise}',
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
                  onTap: () {},
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 2, 0),
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
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      "Weight",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      "Reps",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      "difficulty",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: Center(
                                    child: Text(
                                      "Special",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: false,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: finalExerciseData.length,
                                itemBuilder: (context, itemIndex) {
                                  int setNumber = itemIndex + 1;
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
                                                    controller: weightController[itemIndex],
                                                    onTap: () {
                                                      weightController[itemIndex].selectAll();
                                                      actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                      print(weightController[itemIndex].text);
                                                    },
                                                    onChanged: (value) {
                                                      saveValues(finalExerciseData);
                                                    },
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
                                                    onTap: () {
                                                      repsController[itemIndex].selectAll();
                                                      actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                    },
                                                    onChanged: (value) {
                                                      saveValues(finalExerciseData);
                                                    },
                                                    controller: repsController[itemIndex],
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
                                                  value: difficultyController[itemIndex] == 0 ? null : difficultyController[itemIndex],
                                                  onChanged: (int? value) async {
                                                    print(value);
                                                    difficultyController[itemIndex] = value ?? 0;

                                                    saveValues(finalExerciseData);
                                                    actionExerciseRow(finalExerciseData[itemIndex].id, 2);
                                                    updateExerciseData();
                                                    setState(() {});
                                                  },
                                                  items: List.generate(
                                                    5,
                                                    (index) {
                                                      int difficulty = index + 1; // Začíná od 1 místo 0
                                                      return DropdownMenuItem<int>(
                                                        value: difficulty,
                                                        child: Text(
                                                          difficulty.toString(),
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
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
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
                                                print("delete");
                                                await saveValues(finalExerciseData);
                                                actionExerciseRow(finalData[itemIndex].id, 3);

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
                  ],
                ),
                DraggableScrollableSheet(
                  key: _sheet,
                  initialChildSize: 0.1,
                  maxChildSize: 0.7,
                  minChildSize: 0.1,
                  expand: true,
                  snap: false,
                  snapSizes: [
                    0.2,
                  ],
                  // snapAnimationDuration: Duration(milliseconds: 100),
                  controller: _controller,
                  builder: (context, scrollController) {
                    return DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(123, 0, 0, 0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              height: 90,
                              // color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Swipe up',
                                          style: TextStyle(color: ColorsProvider.color_1, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_upward_rounded,
                                          size: 25,
                                          color: ColorsProvider.color_1,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 40,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline_outlined,
                                          color: ColorsProvider.color_2,
                                          size: 35,
                                        ),
                                        onPressed: () {
                                          try {
                                            weightController.add(TextEditingController(text: "0"));
                                            repsController.add(TextEditingController(text: "0"));
                                            difficultyController.add(0);
                                            exerciseData.add(
                                              ExerciseData(
                                                weight: int.parse(weightController.last.text.trim()),
                                                reps: int.parse(repsController.last.text.trim()),
                                                difficulty: difficultyController.last,
                                                exercisesIdExercise: idExercise,
                                                operation: 1,
                                              ),
                                            );

                                            updateExerciseData();
                                            setState(() {});
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverList.list(
                            children: [
                              SizedBox(
                                height: 10,
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
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

extension TextEditingControllerExt on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
