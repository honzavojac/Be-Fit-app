import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../database/fitness_database.dart';

class NewExerciseBoxCopy extends StatefulWidget {
  final int idMuscle;
  final Function() notifyParent;
  final Function() loadParent;
  const NewExerciseBoxCopy({
    Key? key,
    required this.idMuscle,
    required this.notifyParent,
    required this.loadParent,
  }) : super(key: key);

  @override
  _NewExerciseBoxCopyState createState() => _NewExerciseBoxCopyState();
}

class _NewExerciseBoxCopyState extends State<NewExerciseBoxCopy> {
  String? selectedMuscle;
  var _textController = TextEditingController();
  List<Muscle> muscles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    var dbSupabase = Provider.of<FitnessProvider>(context, listen: false); // listen: false to avoid rebuilds
    muscles = await dbSupabase.SelectMuscles();
    // Nastavte výchozí hodnotu na první sval, pokud není seznam prázdný
    print(widget.idMuscle);
    if (muscles.isNotEmpty) {
      for (var muscle in muscles) {
        print("${muscle.nameOfMuscle} ${muscle.supabaseIdMuscle}");
        if (muscle.supabaseIdMuscle == widget.idMuscle) {
          selectedMuscle = muscle.nameOfMuscle;
        }
      }
    } else {
      print("nastavení defaultní hodnoty");
      selectedMuscle = " ";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          // color: const Color.fromARGB(103, 33, 149, 243),
          borderRadius: BorderRadius.circular(25),
        ),
        height: 250,
        width: 220,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: Text(
                      "New Exercise",
                      style: TextStyle(color: ColorsProvider.color_2, fontSize: 20),
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
            Column(
              children: [
                Expanded(child: SizedBox()),
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Name of Exercise:',
                        labelStyle: TextStyle(
                          color: ColorsProvider.color_2,
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
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                          color: ColorsProvider.color_2,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 20,
                  child: Text(
                    "Assign a Muscle",
                    style: TextStyle(color: ColorsProvider.color_2),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<Muscle>(
                    isExpanded: true,
                    items: muscles.map<DropdownMenuItem<Muscle>>((Muscle muscle) {
                      return DropdownMenuItem<Muscle>(
                        value: muscle,
                        child: Text(
                          muscle.nameOfMuscle!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorsProvider.color_2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMuscle = value!.nameOfMuscle.toString(); // Aktualizace vybraného svalu
                      });
                    },
                    value: selectedMuscle != null ? muscles.firstWhere((muscle) => muscle.nameOfMuscle == selectedMuscle) : null,
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 150,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: ColorsProvider.color_2,
                          width: 0.5,
                        ),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                      iconSize: 17,
                      iconEnabledColor: ColorsProvider.color_2,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      offset: const Offset(0, -10),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all(6),
                        thumbVisibility: WidgetStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (_textController.text.trim().isNotEmpty && selectedMuscle!.isNotEmpty) {
                        List<Exercise> exercises = await dbFitness.SelectExercises();
                        int newSupabaseIdExercise = 1 + (exercises.isNotEmpty ? exercises.last.supabaseIdExercise! : 0);
                        late int muscleId;
                        for (var muscle in muscles) {
                          if (selectedMuscle == muscle.nameOfMuscle) {
                            muscleId = muscle.supabaseIdMuscle!;
                          }
                        }
                        await dbFitness.InsertExercise(newSupabaseIdExercise, _textController.text.trim(), muscleId, 1);

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
                                message: "The name of new exercise cannot be empty",
                              ),
                            ),
                          ),
                          // persistent: true,
                          onAnimationControllerInit: (controller) => localAnimationController = controller,
                          displayDuration: Duration(microseconds: 750),
                          dismissType: DismissType.onSwipe,
                          dismissDirection: [DismissDirection.endToStart],
                          reverseAnimationDuration: Duration(milliseconds: 250),
                          onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
