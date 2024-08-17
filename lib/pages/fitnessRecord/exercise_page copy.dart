import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:provider/provider.dart';

class ExercisePageCopy extends StatefulWidget {
  final Function(List<ExerciseData>) onExerciseDataReturned;

  final Function() loadData;
  final String nameOfExercise;
  final int idExercise;
  final int idSplit;
  const ExercisePageCopy({
    required this.onExerciseDataReturned,
    super.key,
    required this.loadData,
    required this.nameOfExercise,
    required this.idExercise,
    required this.idSplit,
  });

  @override
  State<ExercisePageCopy> createState() => _ExercisePageCopyState();
}

// double initialDragableSize = 0.1;

class _ExercisePageCopyState extends State<ExercisePageCopy> with WidgetsBindingObserver {
  String? nameOfExercise;
  int? idExerxise;
  int? idSplit;
  int? idStartedCompleted;
  bool showWidget = false;
  List<ExerciseData> finalExerciseData = [];
  List<ExerciseData> tempExerciseData = [];
  List<SplitStartedCompleted> splitStartedCompleted = [];

  List<TextEditingController> weightController = [];
  List<TextEditingController> repsController = [];
  List<int> difficultyController = [];
  List<TextEditingController> tempWeightController = [];
  List<TextEditingController> tempRepsController = [];
  List<int> tempDifficultyController = [];
  // TextEditingController _descriptionController = TextEditingController();

  late int idExercise;

  AppLifecycleState? _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // ignore: unused_local_variable
    bool paused = false;
    // Pokud je aktuální stav stejný jako poslední stav, neprovádějte nic
    if (_lastLifecycleState == state) return;

    if (state == AppLifecycleState.paused) {
      if (mounted) {
        try {
          await saveToDatabase();
          print("saved 2 *************************************************");
          // widget.loadData();
          paused = true;
        } catch (e) {
          print("chyba v exercisePage při vkládání dat změněním stavu aplikace (zavřená app): $e");
        }
      } else if (state == AppLifecycleState.resumed) {
        paused = false;
      }
    }
    _lastLifecycleState = state;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    loadOldData();
    loadData(true);
  }

  Future<void> loadData(bool notify) async {
    print("loadData");
    try {
      var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

      nameOfExercise = widget.nameOfExercise;
      idExercise = widget.idExercise;
      idSplit = widget.idSplit;
      splitStartedCompleted = await dbFitness.SelectSplitStartedCompletedWhereEnded(false);
      if (splitStartedCompleted.isNotEmpty) {
        idStartedCompleted = splitStartedCompleted[0].supabaseIdStartedCompleted!;
      }

      if (idStartedCompleted != null) {
        List<ExerciseData> exerciseData = await dbFitness.SelectCurrentExerciseDataWhereExerciseIdExerciseAndIdStCo(idExercise, idStartedCompleted!);
        finalExerciseData.clear();
        weightController.clear();
        repsController.clear();
        difficultyController.clear();

        for (var exerciseDataItem in exerciseData) {
          int action = exerciseDataItem.action!;
          if (action != 3 && action != 4) {
            finalExerciseData.add(exerciseDataItem);
            String weight = exerciseDataItem.weight != null ? exerciseDataItem.weight.toString() : "";
            String reps = exerciseDataItem.reps != null ? exerciseDataItem.reps.toString() : "";
            int difficulty = exerciseDataItem.difficulty ?? 0;
            weightController.add(TextEditingController(text: weight));
            repsController.add(TextEditingController(text: reps));
            difficultyController.add(difficulty);
          }
        }

        tempExerciseData = List.from(finalExerciseData);
        tempWeightController = List.from(weightController);
        tempRepsController = List.from(repsController);
        tempDifficultyController = List.from(difficultyController);
      }

      showWidget = true;
      // notify == true ?
      setState(() {});
      //  : null;
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  saveToDatabase() async {
    print("saveToDatabase");
    try {
      var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

      for (var i = 0; i < tempExerciseData.length; i++) {
        ExerciseData exerciseDataItem = tempExerciseData[i];
        int? weightControllerItem = tempWeightController[i].text.isNotEmpty ? int.parse(tempWeightController[i].text) : null;
        int? repsControllerItem = tempRepsController[i].text.isNotEmpty ? int.parse(tempRepsController[i].text) : null;
        int difficultyControllerItem = tempDifficultyController[i];
        if (exerciseDataItem.action == 0 || exerciseDataItem.action == 1 || exerciseDataItem.action == 2) {
          if (exerciseDataItem.weight != weightControllerItem || exerciseDataItem.reps != repsControllerItem || exerciseDataItem.difficulty != difficultyControllerItem) {
            switch (exerciseDataItem.action) {
              case 0:
                await dbFitness.UpdateExerciseData(weightControllerItem, repsControllerItem, difficultyControllerItem, exerciseDataItem.supabaseIdExData!, 2);
                break;
              case 1:
                await dbFitness.UpdateExerciseData(weightControllerItem, repsControllerItem, difficultyControllerItem, exerciseDataItem.supabaseIdExData!, 1);
                break;
              case 2:
                await dbFitness.UpdateExerciseData(weightControllerItem, repsControllerItem, difficultyControllerItem, exerciseDataItem.supabaseIdExData!, 2);
                break;
              default:
            }
          }
        } else if (exerciseDataItem.action == 3) {
          // future delete from supabase
          await dbFitness.UpdateExerciseData(weightControllerItem, repsControllerItem, difficultyControllerItem, exerciseDataItem.supabaseIdExData!, 3);
        } else if (exerciseDataItem.action == 4) {
          await dbFitness.DeleteExerciseData(exerciseDataItem.supabaseIdExData!);
        }
      }
      print("Data saved successfully.");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  List<SplitStartedCompleted> oldDataFinal = [];

  loadOldData() async {
    print("******* old data *******");
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    oldDataFinal.clear();
    List<SplitStartedCompleted> temp = await dbFitness.SelectAllHistoricalData(widget.idExercise);

    for (var splitStartedCompletedItem in temp) {
      List<ExerciseData> exerciseDataTemp = [];
      for (var element in splitStartedCompletedItem.exerciseData!) {
        if (element.exercisesIdExercise == widget.idExercise) {
          exerciseDataTemp.add(element);
        }
        // print("idExercise ${element.exercisesIdExercise}");
      }
      if (exerciseDataTemp.isNotEmpty) {
        SplitStartedCompleted newSplitStartedCompletedItem = SplitStartedCompleted(
          idStartedCompleted: splitStartedCompletedItem.idStartedCompleted,
          splitId: splitStartedCompletedItem.splitId,
          createdAt: splitStartedCompletedItem.createdAt,
          endedAt: splitStartedCompletedItem.endedAt,
          ended: splitStartedCompletedItem.ended,
          exerciseData: exerciseDataTemp,
        );
        oldDataFinal.add(newSplitStartedCompletedItem);
      }
    }
    oldDataFinal.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );
    setState(() {});
  }

  addExerciseData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    try {
      await saveToDatabase();
      print("Data saved successfully.");
    } catch (e) {
      print("Error saving to database: $e");
    }

    try {
      DateTime dateTime = DateTime.now();
      String now = dateTime.toString();
      int newSupabaseIdSplitStartedCompleted;
      if (idStartedCompleted == null) {
        List<SplitStartedCompleted> splitStartedCompleted = await dbFitness.SelectSplitStartedCompleted();
        newSupabaseIdSplitStartedCompleted = 1 + (splitStartedCompleted.isNotEmpty ? splitStartedCompleted.last.supabaseIdStartedCompleted! : 0);
        await dbFitness.InsertSplitStartedCompleted(newSupabaseIdSplitStartedCompleted, now, null, idSplit!, false, 1);
        widget.loadData();
      } else {
        newSupabaseIdSplitStartedCompleted = idStartedCompleted!;
      }

      List<ExerciseData> exerciseDataMaxIdExercise = await dbFitness.selectMaxExerciseData();
      int newSupabaseIdExercise = 1 + (exerciseDataMaxIdExercise.isNotEmpty ? exerciseDataMaxIdExercise[0].supabaseIdExData ?? 0 : 0);
      print("New Supabase ID for Exercise: $newSupabaseIdExercise");

      await dbFitness.InsertExerciseData(newSupabaseIdExercise, null, null, 0, null, null, now, idExercise, newSupabaseIdSplitStartedCompleted, 1);

      loadData(true);
    } catch (e) {
      print("Error adding values: $e");
    }
  }

  void _showDropdown() {
    final List<int> _dropdownOptions = [1, 2, 3, 4, 5];
    // Vytvoří nové klíčové hodnoty pro nový DropdownButton2
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      items: _dropdownOptions.map((int value) {
        return PopupMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    ).then((int? newValue) {
      if (newValue != null) {
        setState(() {
          // _selectedValue = newValue;
        });
      }
    });
  }

  List<FocusNode> focusNodes = [FocusNode(), FocusNode()];

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    DraggableScrollableController _controller = DraggableScrollableController();

    final _sheet = GlobalKey();

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
                          categoryRow(),
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
                              onTap: () async {
                                addExerciseData();
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
      );
    } else {
      return PopScope(
        onPopInvoked: (didPop) async {
          print("onPopInvoked**********************");
          await saveToDatabase();
          await loadData(true);
          await widget.onExerciseDataReturned(finalExerciseData);
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
                // ElevatedButton(
                //   onPressed: () async {
                //     await dbFitness.DeleteAllExerciseDatas();
                //     loadData();
                //   },
                //   child: Text("delete all exData"),
                // ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Ikona zpětné šipky
              onPressed: () async {
                print("ZPĚT");
                widget.onExerciseDataReturned(finalExerciseData);
                await widget.loadData();
                await saveToDatabase();

                Navigator.pop(context, finalExerciseData);
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
                            categoryRow(),
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
                                  int? difficulty = finalExerciseData[itemIndex].difficulty;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
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
                                                try {
                                                  if (finalExerciseData[itemIndex].action == 1) {
                                                    for (var i = 0; i < tempExerciseData.length; i++) {
                                                      if (tempExerciseData[i].idExData == finalExerciseData[itemIndex].idExData) {
                                                        tempExerciseData[i].action = 4;
                                                      }
                                                    }
                                                  } else if (finalExerciseData[itemIndex].action == 0 || finalExerciseData[itemIndex].action == 2) {
                                                    for (var i = 0; i < tempExerciseData.length; i++) {
                                                      if (tempExerciseData[i].idExData == finalExerciseData[itemIndex].idExData) {
                                                        tempExerciseData[i].action = 3;
                                                      }
                                                    }
                                                  }

                                                  finalExerciseData.removeAt(itemIndex);
                                                  weightController.removeAt(itemIndex);
                                                  repsController.removeAt(itemIndex);
                                                  difficultyController.removeAt(itemIndex);
                                                  saveToDatabase();
                                                  setState(() {});
                                                  return true;
                                                } catch (e) {
                                                  print("Error during confirm dismiss: $e");
                                                  return false;
                                                }
                                              },
                                              child: Container(
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width: 22,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "${setNumber}",
                                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        child: Container(
                                                          height: 38,
                                                          child: Center(
                                                            child: TextFormField(
                                                              onTap: () {
                                                                // Select all text when tapped
                                                                weightController[itemIndex].selection = TextSelection(
                                                                  baseOffset: 0,
                                                                  extentOffset: weightController[itemIndex].text.length,
                                                                );
                                                              },
                                                              onTapOutside: (event) async {
                                                                print("tapoutside*******************");
                                                                await saveToDatabase();
                                                                await loadData(false);
                                                                widget.loadData;
                                                              },
                                                              onChanged: (value) {
                                                                // Handle text changes here
                                                              },
                                                              controller: weightController[itemIndex],
                                                              keyboardType: TextInputType.numberWithOptions(), // Ensure same keyboard type
                                                              // textInputAction: TextInputAction.next, // Ensure consistent action
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(3),
                                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                              ],
                                                              decoration: InputDecoration(
                                                                labelStyle: TextStyle(
                                                                  color: ColorsProvider.color_2, // Replace with your color
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(12),
                                                                  ),
                                                                  borderSide: BorderSide(
                                                                    color: ColorsProvider.color_2, // Replace with your color
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(12),
                                                                  ),
                                                                  borderSide: BorderSide(
                                                                    color: ColorsProvider.color_2, // Replace with your color
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
                                                                                    : difficulty == 5
                                                                                        ? Colors.red
                                                                                        : null,
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
                                                          height: 38,
                                                          child: Center(
                                                            child: TextFormField(
                                                              onTap: () {
                                                                // Select all text when tapped
                                                                repsController[itemIndex].selectAll();
                                                                // repsController[itemIndex].selection = TextSelection(
                                                                //   baseOffset: 0,
                                                                //   extentOffset: repsController[itemIndex].text.length,
                                                                // );
                                                              },
                                                              onTapOutside: (event) async {
                                                                print("tapoutside*******************");
                                                                await saveToDatabase();
                                                                // await loadData(false);
                                                                widget.loadData();
                                                              },
                                                              onChanged: (value) {
                                                                // Handle text changes here
                                                              },
                                                              controller: repsController[itemIndex],
                                                              keyboardType: TextInputType.numberWithOptions(), // Ensure same keyboard type
                                                              // textInputAction: TextInputAction.next, // Ensure consistent action
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(3),
                                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                              ],
                                                              decoration: InputDecoration(
                                                                labelStyle: TextStyle(
                                                                  color: ColorsProvider.color_2, // Replace with your color
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(12),
                                                                  ),
                                                                  borderSide: BorderSide(
                                                                    color: ColorsProvider.color_2, // Replace with your color
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(12),
                                                                  ),
                                                                  borderSide: BorderSide(
                                                                    color: ColorsProvider.color_2, // Replace with your color
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
                                                                                    : difficulty == 5
                                                                                        ? Colors.red
                                                                                        : null,
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
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // _focusNode.unfocus(); // Close the keyboard
                                                              // FocusScope.of(context).requestFocus(FocusNode());
                                                            },
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
                                                                height: 38,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  border: Border.all(width: 0.5, color: ColorsProvider.color_2),
                                                                ),
                                                                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                                              ),
                                                              value: difficultyController[itemIndex] == 0 ? null : difficultyController[itemIndex],
                                                              onChanged: (int? value) async {
                                                                difficultyController[itemIndex] = value ?? 0;
                                                                for (int i = 0; i < tempExerciseData.length; i++) {
                                                                  if (tempExerciseData[i].supabaseIdExData == finalExerciseData[itemIndex].supabaseIdExData) {
                                                                    tempDifficultyController[i] = value ?? 0;
                                                                  }
                                                                }
                                                                await saveToDatabase();
                                                                loadData(true);
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
                                          ),

                                          // Container(
                                          //   color: Colors.blue,
                                          //   height: 25,
                                          // )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            )
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
                              // SliverList.list(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Container(
                              //         // constraints: BoxConstraints(maxHeight: 150),
                              //         child: TextField(
                              //           maxLines: 8,
                              //           minLines: 2,
                              //           onTap: () {},
                              //           controller: _descriptionController,
                              //           decoration: const InputDecoration(
                              //             label: Text(
                              //               "Enter description of today split...",
                              //               style: TextStyle(color: Colors.white),
                              //             ),
                              //             labelStyle: TextStyle(
                              //               color: ColorsProvider.color_1,
                              //             ),
                              //             enabledBorder: OutlineInputBorder(
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(12),
                              //               ),
                              //               borderSide: BorderSide(
                              //                 color: ColorsProvider.color_2,
                              //                 width: 0.5,
                              //               ),
                              //             ),
                              //             focusedBorder: OutlineInputBorder(
                              //               borderRadius: BorderRadius.all(
                              //                 Radius.circular(12),
                              //               ),
                              //               borderSide: BorderSide(
                              //                 color: ColorsProvider.color_2,
                              //                 width: 2.0,
                              //               ),
                              //             ),
                              //             contentPadding: EdgeInsets.symmetric(
                              //               vertical: 10,
                              //               horizontal: 15,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Text(
                              //             "old values".toUpperCase(),
                              //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: oldDataFinal.length,
                                  (BuildContext context, int splitStartedindex) {
                                    String? rawDate = oldDataFinal[splitStartedindex].createdAt!.substring(0, 25 - 15);
                                    DateTime dateTime = DateTime.parse(rawDate);
                                    DateFormat formatter = DateFormat('dd.MM.yyyy');
                                    String date = formatter.format(dateTime);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 135,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: ColorsProvider.color_2,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "$date",
                                                    style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 20),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(color: Color.fromARGB(135, 0, 0, 0), borderRadius: BorderRadius.circular(12)),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                        child: Container(
                                                          width: 60,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Set",
                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                              ),
                                                              Text(
                                                                "Weight",
                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                              ),
                                                              Text(
                                                                "Reps",
                                                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        color: ColorsProvider.color_8,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                          child: Container(
                                                            child: ListView.builder(
                                                              itemCount: oldDataFinal[splitStartedindex].exerciseData!.length,
                                                              scrollDirection: Axis.horizontal,
                                                              itemBuilder: (context, index) {
                                                                var data = oldDataFinal[splitStartedindex].exerciseData![index];
                                                                int? reps;
                                                                int? weight;
                                                                int difficulty;
                                                                // if (DateTime.now().toString().replaceRange(10, null, '') == splits[selectedSplit].selectedMuscle![muscleIndex].muscles.exercises![exerciseIndex].exerciseData![index].time!.replaceRange(10, null, '')) {
                                                                reps = data.reps;
                                                                weight = data.weight;
                                                                difficulty = data.difficulty!;
                                                                // } else {}
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                                  child: Container(
                                                                    width: 30,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "${index + 1}",
                                                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          "$weight",
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 16,
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
                                                                        ),
                                                                        Text(
                                                                          "$reps",
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 16,
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
                                                                        ),
                                                                        SizedBox(
                                                                          height: 2,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
                                onTap: () async {
                                  addExerciseData();

                                  setState(() {});
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

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Povolený regex pro formát: buď prázdný řetězec, nebo "-" následované 1-3 číslicemi, nebo 1-3 číslice.
    final RegExp regExp = RegExp(r'^-?\d{0,3}$');

    if (regExp.hasMatch(newText)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

Widget categoryRow() {
  return Row(
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
  );
}

extension TextEditingControllerExt on TextEditingController {
  void selectAll() {
    if (text.isEmpty) return;
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }
}
