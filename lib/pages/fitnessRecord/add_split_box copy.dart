import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_muscle_box.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'new_muscle_box copy.dart';

class AddSplitBoxCopy extends StatefulWidget {
  final Function() loadParent;
  final List<MySplit> splits;

  const AddSplitBoxCopy({
    Key? key,
    required this.loadParent,
    required this.splits,
  }) : super(key: key);

  @override
  _AddSplitBoxCopyState createState() => _AddSplitBoxCopyState();
}

class _AddSplitBoxCopyState extends State<AddSplitBoxCopy> {
  var _textController = TextEditingController();

  List<Muscle> muscles = [];
  List<MySplit> splits = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> loadData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    muscles = await dbFitness.SelectMuscles();
    if (isCheckedList.isEmpty) {
      muscles.forEach((element) {
        isCheckedList.add(false);
      });
    } else if (muscles.length == isCheckedList.length + 1) {
      isCheckedList.add(false);
    }

    splits = widget.splits;
    splits.sort((a, b) => a.supabaseIdSplit!.compareTo(b.supabaseIdSplit!));
    setState(() {});
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: const Color.fromARGB(103, 33, 149, 243),
        ),
        height: 350,
        width: 300,
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
                      muscles.length == 0
                          ? Container()
                          : Container(
                              height: 50,
                              // color: ColorsProvider.color_8,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Name of MySplit:',
                                    labelStyle: TextStyle(
                                      color: ColorsProvider.color_1,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorsProvider.color_2,
                                        width: 0.5,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorsProvider.color_2,
                                        width: 3.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 15,
                                    ),
                                    hintText: 'Enter name of split:',
                                    hintStyle: TextStyle(
                                      color: ColorsProvider.color_1,
                                      fontSize: 15,
                                    ),
                                  ),
                                  controller: _textController,
                                  style: TextStyle(color: ColorsProvider.color_1),
                                ),
                              ),
                            ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: muscles.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        muscles[index].nameOfMuscle!,
                                      ),
                                    ),
                                    Checkbox(
                                      value: isCheckedList[index],
                                      onChanged: (value) {
                                        isCheckedList[index] = value ?? false;

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
                      if (_textController.text.trim().isNotEmpty) {
                        try {
                          DateTime now = DateTime.now();
                          int newSupabaseIdSplit = 1 + (splits.isNotEmpty ? splits.last.supabaseIdSplit! : 0);
                          List<SelectedMuscle> selectedMuscles = [];
                          for (var element in splits) {
                            for (var element in element.selectedMuscle!) {
                              selectedMuscles.add(element);
                            }
                          }
                          int newSupabaseIdSelectedIdMuscle = 1 + (selectedMuscles.isNotEmpty ? selectedMuscles.last.supabaseIdSelectedMuscle! : 0);

                          await dbFitness.InsertSplit(newSupabaseIdSplit, _textController.text.trim(), now.toString(), 1);

                          for (var i = 0; i < isCheckedList.length; i++) {
                            if (isCheckedList[i] == true) {
                              int supabaseIdMuscle = muscles[i].supabaseIdMuscle!;
                              // print(supabaseIdMuscle);
                              await dbFitness.InsertSelectedMuscle(newSupabaseIdSelectedIdMuscle, newSupabaseIdSplit, supabaseIdMuscle, 1);
                              newSupabaseIdSelectedIdMuscle++;
                            }
                          }
                        } on Exception catch (e) {
                          print("chyba: $e");
                          // TODO
                        }

                        List<SelectedMuscle> a = await dbFitness.SelectSelectedMuscles();
                        for (var element in a) {
                          print(element.musclesIdMuscle);
                        }
                        widget.loadParent();
                        Navigator.of(context).pop();
                      } else {
                        // ignore: unused_local_variable
                        AnimationController localAnimationController;

                        showTopSnackBar(
                          Overlay.of(context),

                          animationDuration: Duration(milliseconds: 1500),
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: CustomSnackBar.error(
                                message: "Name of split is empty",
                              ),
                            ),
                          ),
                          // persistent: true,
                          onAnimationControllerInit: (controller) => localAnimationController = controller,
                          displayDuration: Duration(microseconds: 750),
                          dismissType: DismissType.onSwipe,
                          dismissDirection: [DismissDirection.endToStart],
                          reverseAnimationDuration: Duration(milliseconds: 250),
                        );
                      }
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
                              child: NewMuscleBoxCopy(
                                loadParent: loadData,
                                notifyParent: refresh,
                                muscles: muscles,
                              ),
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
