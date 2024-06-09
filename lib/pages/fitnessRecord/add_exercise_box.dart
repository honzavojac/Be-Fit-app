import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';

import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import 'new_exercise_box.dart';

class AddExerciseBox extends StatefulWidget {
  final int splitIndex;
  final int muscleIndex;
  final Function() notifyParent;
  const AddExerciseBox({
    Key? key,
    required this.splitIndex,
    required this.muscleIndex,
    required this.notifyParent,
  }) : super(key: key);

  @override
  _AddExerciseBoxState createState() => _AddExerciseBoxState();
}

class _AddExerciseBoxState extends State<AddExerciseBox> {
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  void refresh() {
    a = 0;
    setState(() {});
  }

  int a = 0;
  Future<void> loadData(BuildContext context) async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false); // listen: false to avoid rebuilds

    if (dbSupabase.initChecklist == 0) {
      if (a == 0) {
        dbSupabase.clickedSplitTab = widget.splitIndex;
        dbSupabase.muscleIndex = widget.muscleIndex;
        await dbSupabase.generateFalseExerciseCheckbox(widget.splitIndex, widget.muscleIndex);
        for (var i = 0; i < dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises!.length; i++) {
          String selectedExerciseName = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].selectedExercises![i].exercises.nameOfExercise;

          // print(i);
          // print(dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].muscles!.exercises![i].nameOfExercise);
          for (var j = 0; j < dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].muscles!.exercises!.length; j++) {
            String exerciseName = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].muscles!.exercises![j].nameOfExercise;
            if (exerciseName == selectedExerciseName) {
              // print("true $i");
              dbSupabase.exercisesCheckedList[j] = true;
            } else {
              // print("false $i");
            }
          }
        }

        isCheckedList = dbSupabase.exercisesCheckedList;
        setState(() {});
        a = 1;
        dbSupabase.initChecklist = 1;
      } else {
        a = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var exercises = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].muscles!.exercises;
    // print("object");
    // for (var element in exercises!) {
    //   print(element.idExercise);
    // }
    var data = dbSupabase.splits[widget.splitIndex].selectedMuscle![widget.muscleIndex];
    // splits[widget.splitIndex].selectedMuscle![widget.muscleIndex].muscles!.exercises;
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
                            itemCount: exercises!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("${exercises[index].nameOfExercise}"),
                                    ),
                                    Checkbox(
                                      value: isCheckedList[index],
                                      onChanged: (value) async {
                                        isCheckedList[index] = value ?? false;
                                        var finalExercise = exercises[index];
                                        print(index);
                                        await dbSupabase.updateSelectedExercise(
                                          finalExercise.idExercise,
                                          finalExercise.nameOfExercise,
                                          value!,
                                          data.idSelectedMuscle,
                                          widget.splitIndex,
                                          widget.muscleIndex,
                                          index,
                                        );

                                        await dbSupabase.getFitness();
                                        widget.notifyParent();
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
                      // for (var i = 0; i < dbFirebase.allExercises.length; i++) {
                      //   if (isCheckedList[i] == true) {
                      //     print("add");
                      //     dbFirebase.addTrueSplitExercise(dbFirebase.allExercises[i]);
                      //   } else if (isCheckedList[i] == false) {
                      //     print("delete");
                      //     dbFirebase.DeleteTrueSplitExercise(dbFirebase.allExercises[i]);
                      //   }
                      // }
                      Navigator.of(context).pop();
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
                              child: NewExerciseBox(
                                splitIndex: widget.splitIndex,
                                muscleIndex: widget.muscleIndex,
                                notifyParent: refresh,
                              ),
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
