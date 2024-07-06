import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
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

// double initialDragableSize = 0.1;

class _ExercisePageState extends State<ExercisePage> with WidgetsBindingObserver {
  bool showWidget = false;
  List<ExerciseData> exerciseData = [];
  late List<Split> splitData;
  int? splitDataIndex;
  bool insertSSC = false;
  List<TextEditingController> weightController = [];
  List<TextEditingController> repsController = [];
  TextEditingController _descriptionController = TextEditingController();
  List<int> weight = [];
  List<int> reps = [];
  List<int> difficultyController = [];
  late String nameOfExercise;
  late int idExercise;
  late bool saved;
  AppLifecycleState? _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Pokud je aktuální stav stejný jako poslední stav, neprovádějte nic
    if (_lastLifecycleState == state) return;

    if (state == AppLifecycleState.inactive) {
      // Aplikace přechází do pozadí, zde můžete uložit data
      print("didchangeapplifecyclestate - inactive");
      if (mounted) {
        try {
          // if (saved == false) {
          await saveDataToDatabase(); // Předpokládám, že saveDataToDatabase je asynchronní funkce

          //   saved = true;
          // }
        } catch (e) {
          print("chyba v exercisePage při vkládání dat změněním stavu aplikace (zavřená app): $e");
        }
      }
    }
    // Uložte aktuální stav jako poslední stav
    _lastLifecycleState = state;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("initState called");
    saved = false;
    load();
  }

  load() {
    print("load called");
    try {
      if (mounted) {
        var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
        if (dbSupabase.boolInsertSplitStartedCompleted == false) {
          //je split_started_completed zadáván
          nameOfExercise = dbSupabase.exerciseData[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises!.nameOfExercise;
          idExercise = dbSupabase.exerciseData[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises!.idExercise!;

          exerciseData = dbSupabase.exerciseData[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises!.exerciseData!;
        } else {
          exerciseData = [];
          idExercise = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises!.idExercise!;
          nameOfExercise = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![widget.exerciseIndex].exercises!.nameOfExercise;
        }

        splitData = dbSupabase.splitStartedCompleted;
        // splitData[widget.splitIndex].splitStartedCompleted?.removeAt(0);
        weightController.clear();
        repsController.clear();
        difficultyController.clear();

        for (var i = 0; i < exerciseData.length; i++) {
          //nastavení controlerů na hodnoty z exerciseData
          weightController.add(TextEditingController(text: exerciseData[i].weight.toString()));
          repsController.add(TextEditingController(text: exerciseData[i].reps.toString()));
          difficultyController.add(exerciseData[i].difficulty);
        }
        showWidget = true;
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

  saveDataToDatabase() async {
    // initialDragableSize = 0.1;
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    // ignore: unnecessary_null_comparison
    if (mounted) {
      print(" dbSupabase.insertSplitStartedCompleted(splitId!);-------------------------------------------");
      var muscles = dbSupabase.exerciseData[widget.splitIndex].selectedMuscle!;
      var splitId = dbSupabase.splits[widget.splitIndex].idSplit;

      //kontrola jestli není někde v datech idSplitStartedCompleted
      //nastává problém když cvičíme dvoufázově tak se určí další idSplitStartedCompleted a já budu znát první v cvicích daný den
      //nepozná to jen tak nějaký uživatel
      forin:
      for (var muscle in muscles) {
        for (var exercise in muscle.selectedExercises!) {
          for (var exeData in exercise.exercises!.exerciseData!) {
            if (exeData.idStartedCompleted != null) {
              dbSupabase.idSplitStartedCompleted = exeData.idStartedCompleted;
              dbSupabase.boolInsertSplitStartedCompleted = true;
              break forin;
            }
          }
        }
      }

      // ignore: unnecessary_null_comparison
      // if () {
      //   //insertování hodnoty do tabulky split_started_completed
      //   print("idStartedCompleted = await dbSupabase.insertSplitStartedCompleted(splitId!);");
      //   dbSupabase.idSplitStartedCompleted = await dbSupabase.insertSplitStartedCompleted(splitId!);
      //   dbSupabase.boolInsertSplitStartedCompleted = true;
      // }

      print("hodnota byla předána provideru");
      await dbSupabase.actionExerciseData(
        exerciseData,
        idExercise,
        dbSupabase.idSplitStartedCompleted!,
      );
      // dbSupabase.getOldFitness(idExercise);
      load();
      try {
        await widget.notifyParent;
      } on Exception catch (e) {
        print(e);
      }
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
    }
  }

  saveValues(List<ExerciseData> data) {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    //insert do tabulky split_started_completed o startu splitu
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
    }

    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    saved = false;
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
                      border: Border.all(color: ColorsProvider.color_8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                      child: Text(
                        "Specials",
                        style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 15),
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
                            ],
                          ),
                          SizedBox(
                            height: 15,
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

            widget.notifyParent;
            print("popscope---------------------------");
          }
          try {} on Exception catch (e) {
            print(e);
          }
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
                        border: Border.all(color: ColorsProvider.color_8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                        child: Text(
                          "Specials",
                          style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )),
                  onTap: () {},
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
              onPressed: () async {
                // saveDataToDatabase();
                try {
                  await widget.notifyParent;
                } on Exception catch (e) {
                  print(e);
                }

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
                                  width: 22,
                                  child: Center(
                                    child: Text(
                                      "Set",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Weight",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "Reps",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      "difficulty",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 50,
                                //   child: Center(
                                //     child: Text(
                                //       "Special",
                                //       style: TextStyle(fontWeight: FontWeight.bold),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: false,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: finalExerciseData.length,
                                itemBuilder: (context, itemIndex) {
                                  int setNumber = itemIndex + 1;
                                  int difficulty = finalExerciseData[itemIndex].difficulty;
                                  return Column(
                                    children: [
                                      Container(
                                        height: 45,
                                        // color: ColorsProvider.color_7,
                                        child: Dismissible(
                                          direction: DismissDirection.endToStart,
                                          key: ValueKey<int>(finalExerciseData[itemIndex].id),
                                          background: Container(
                                            color: ColorsProvider.color_9,
                                            child: Align(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Icon(Icons.delete),
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ),
                                          onDismissed: (direction) async {},
                                          confirmDismiss: (direction) async {
                                            await saveValues(finalExerciseData);
                                            actionExerciseRow(finalData[itemIndex].id, 3);
                                            setState(() {});
                                            return true;
                                          },
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 22,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("${setNumber}"),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: Container(
                                                    height: 35,
                                                    child: Center(
                                                      child: TextField(
                                                        controller: weightController[itemIndex],
                                                        onTap: () {
                                                          weightController[itemIndex].selectAll();
                                                          actionExerciseRow(finalExerciseData[itemIndex].id, 2);
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
                                                          filled: false,
                                                          fillColor: ColorsProvider.color_2,
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
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: difficulty == 0
                                                              ? Colors.white
                                                              : difficulty == 1
                                                                  ? Colors.green
                                                                  : difficulty == 2
                                                                      ? Colors.lightGreen
                                                                      : difficulty == 3
                                                                          ? Colors.yellow
                                                                          : difficulty == 4
                                                                              ? Colors.orange
                                                                              : Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
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
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 15,
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: difficulty == 0
                                                              ? Colors.white
                                                              : difficulty == 1
                                                                  ? Colors.green
                                                                  : difficulty == 2
                                                                      ? Colors.lightGreen
                                                                      : difficulty == 3
                                                                          ? Colors.yellow
                                                                          : difficulty == 4
                                                                              ? Colors.orange
                                                                              : Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton2<int>(
                                                      alignment: Alignment.center,
                                                      style: TextStyle(
                                                        // color: ColorsProvider.color_8,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 5,
                                                      ),
                                                      isDense: true,
                                                      menuItemStyleData: MenuItemStyleData(
                                                        height: 37,
                                                      ),
                                                      isExpanded: true,
                                                      dropdownStyleData: DropdownStyleData(
                                                        offset: Offset(-0, -3),
                                                        elevation: 2,
                                                        // width: 90,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Color.fromARGB(195, 0, 0, 0),
                                                        ),
                                                      ),
                                                      buttonStyleData: ButtonStyleData(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(width: 0.5, color: ColorsProvider.color_2),
                                                        ),
                                                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                                      ),
                                                      value: difficultyController[itemIndex] == 0 ? null : difficultyController[itemIndex],
                                                      onChanged: (int? value) async {
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
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              difficulty.toString(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: difficulty == 0
                                                                    ? Colors.white
                                                                    : difficulty == 1
                                                                        ? Colors.green
                                                                        : difficulty == 2
                                                                            ? Colors.lightGreen
                                                                            : difficulty == 3
                                                                                ? Colors.yellow
                                                                                : difficulty == 4
                                                                                    ? Colors.orange
                                                                                    : ColorsProvider.color_9,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   width: 50,
                                                //   child: Text("Normal"),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
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
                  // shouldCloseOnMinExtent: false,
                  initialChildSize: 0.1,
                  maxChildSize: 0.6,
                  minChildSize: 0.1, snapAnimationDuration: Duration(milliseconds: 100),
                  expand: true,
                  snap: false,
                  snapSizes: [
                    0.1,
                    0.6,
                  ],
                  // snapAnimationDuration: Duration(milliseconds: 100),
                  controller: _controller,
                  builder: (context, scrollController) {
                    return Stack(
                      children: [
                        DecoratedBox(
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Swipe up',
                                          style: TextStyle(
                                            color: ColorsProvider.color_1,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                  ),
                                ),
                              ),
                              SliverList.list(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(10.0),
                                  //   child: Container(
                                  //     // constraints: BoxConstraints(maxHeight: 150),
                                  //     child: TextField(
                                  //       maxLines: 8,
                                  //       minLines: 2,
                                  //       onTap: () {},
                                  //       controller: _descriptionController,
                                  //       decoration: const InputDecoration(
                                  //         label: Text(
                                  //           "Enter description of today split...",
                                  //           style: TextStyle(color: Colors.white),
                                  //         ),
                                  //         labelStyle: TextStyle(
                                  //           color: ColorsProvider.color_1,
                                  //         ),
                                  //         enabledBorder: OutlineInputBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(12),
                                  //           ),
                                  //           borderSide: BorderSide(
                                  //             color: ColorsProvider.color_2,
                                  //             width: 0.5,
                                  //           ),
                                  //         ),
                                  //         focusedBorder: OutlineInputBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(12),
                                  //           ),
                                  //           borderSide: BorderSide(
                                  //             color: ColorsProvider.color_2,
                                  //             width: 2.0,
                                  //           ),
                                  //         ),
                                  //         contentPadding: EdgeInsets.symmetric(
                                  //           vertical: 10,
                                  //           horizontal: 15,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "old values".toUpperCase(),
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // SliverList(
                              //   delegate: SliverChildBuilderDelegate(
                              //     childCount: splitData[widget.splitIndex].splitStartedCompleted!.length,
                              //     (BuildContext context, int splitStartedindex) {
                              //       String? rawDate = splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].createdAt!.substring(0, 25 - 15);
                              //       DateTime dateTime = DateTime.parse(rawDate);
                              //       DateFormat formatter = DateFormat('dd.MM.yyyy');
                              //       String date = formatter.format(dateTime);
                              //       return Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Container(
                              //           height: 135,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(10),
                              //             color: ColorsProvider.color_2,
                              //           ),
                              //           child: Column(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                   top: 5,
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisAlignment: MainAxisAlignment.center,
                              //                   children: [
                              //                     Text(
                              //                       "$date",
                              //                       style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 20),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //               Expanded(
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                              //                   child: Container(
                              //                     decoration: BoxDecoration(color: Color.fromARGB(135, 0, 0, 0), borderRadius: BorderRadius.circular(12)),
                              //                     child: Row(
                              //                       children: [
                              //                         Padding(
                              //                           padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                              //                           child: Container(
                              //                             width: 60,
                              //                             child: Column(
                              //                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //                               children: [
                              //                                 Text(
                              //                                   "Set",
                              //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                              //                                 ),
                              //                                 Text(
                              //                                   "Weight",
                              //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                              //                                 ),
                              //                                 Text(
                              //                                   "Reps",
                              //                                   style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 2,
                              //                                 )
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         Container(
                              //                           width: 1,
                              //                           color: ColorsProvider.color_8,
                              //                         ),
                              //                         Expanded(
                              //                           child: Padding(
                              //                             padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                              //                             child: Container(
                              //                               child: ListView.builder(
                              //                                 itemCount: splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].exerciseData!.length,
                              //                                 scrollDirection: Axis.horizontal,
                              //                                 itemBuilder: (context, index) {
                              //                                   var data = splitData[widget.splitIndex].splitStartedCompleted![splitStartedindex].exerciseData![index];
                              //                                   int reps;
                              //                                   int weight;
                              //                                   int difficulty;
                              //                                   // if (DateTime.now().toString().replaceRange(10, null, '') == splits[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                              //                                   reps = data.reps;
                              //                                   weight = data.weight;
                              //                                   difficulty = data.difficulty;
                              //                                   // } else {}
                              //                                   return Padding(
                              //                                     padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                              //                                     child: Container(
                              //                                       width: 30,
                              //                                       child: Column(
                              //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //                                         children: [
                              //                                           Text(
                              //                                             "${index + 1}",
                              //                                             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              //                                           ),
                              //                                           Text(
                              //                                             "$weight",
                              //                                             style: TextStyle(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontSize: 16,
                              //                                               color: difficulty == 0
                              //                                                   ? Colors.white
                              //                                                   : difficulty == 1
                              //                                                       ? Colors.green
                              //                                                       : difficulty == 2
                              //                                                           ? Colors.lightGreen
                              //                                                           : difficulty == 3
                              //                                                               ? Colors.yellow
                              //                                                               : difficulty == 4
                              //                                                                   ? Colors.orange
                              //                                                                   : ColorsProvider.color_9,
                              //                                             ),
                              //                                           ),
                              //                                           Text(
                              //                                             "$reps",
                              //                                             style: TextStyle(
                              //                                               fontWeight: FontWeight.bold,
                              //                                               fontSize: 16,
                              //                                               color: difficulty == 0
                              //                                                   ? Colors.white
                              //                                                   : difficulty == 1
                              //                                                       ? Colors.green
                              //                                                       : difficulty == 2
                              //                                                           ? Colors.lightGreen
                              //                                                           : difficulty == 3
                              //                                                               ? Colors.yellow
                              //                                                               : difficulty == 4
                              //                                                                   ? Colors.orange
                              //                                                                   : ColorsProvider.color_9,
                              //                                             ),
                              //                                           ),
                              //                                           SizedBox(
                              //                                             height: 2,
                              //                                           )
                              //                                         ],
                              //                                       ),
                              //                                     ),
                              //                                   );
                              //                                 },
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         )
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 0,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  try {
                                    print("přidána položka");
                                    // weightController.add(TextEditingController(text: "0"));
                                    // repsController.add(TextEditingController(text: "0"));
                                    // difficultyController.add(0);
                                    exerciseData.add(
                                      ExerciseData(
                                        weight: 0,
                                        reps: 0,
                                        difficulty: 0,
                                        exercisesIdExercise: idExercise,
                                        operation: 1,
                                        // idStartedCompleted:
                                      ),
                                    );
                                    widget.notifyParent;
                                    updateExerciseData();
                                    setState(() {});
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(50),
                                    shape: BoxShape.circle,
                                    color: ColorsProvider.color_8,
                                  ),
                                  child: Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: ColorsProvider.color_2,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
