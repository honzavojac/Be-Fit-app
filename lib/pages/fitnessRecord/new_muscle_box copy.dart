import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../data_classes.dart';
import '../../providers/colors_provider.dart';

class NewMuscleBoxCopy extends StatefulWidget {
  final Function() notifyParent;
  final Function() loadParent;
  final List<Muscle> muscles;
  const NewMuscleBoxCopy({
    Key? key,
    required this.notifyParent,
    required this.loadParent,
    required this.muscles,
  }) : super(key: key);

  @override
  _NewMuscleBoxCopyState createState() => _NewMuscleBoxCopyState();
}

class _NewMuscleBoxCopyState extends State<NewMuscleBoxCopy> {
  var textController = TextEditingController();
  @override
  void initState() {
    textController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context);
    var dbSupabase = Provider.of<SupabaseProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(103, 33, 149, 243),
        ),
        height: 170,
        width: 280,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: Text(
                      "New Muscle",
                      style: TextStyle(color: ColorsProvider.color_1, fontSize: 20),
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
                Expanded(child: Container()),
                Container(
                  height: 80,
                  width: 220,
                  child: Center(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Name of Muscle:',
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
                        hintText: 'Enter name of muscle:',
                        hintStyle: TextStyle(
                          color: ColorsProvider.color_1,
                          fontSize: 15,
                        ),
                      ),
                      controller: textController,
                      style: TextStyle(color: ColorsProvider.color_1),
                    ),
                  ),
                ),
                // Spacer(),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      List<Muscle> sortedMuscles = widget.muscles;
                      sortedMuscles.sort(
                        (a, b) => a.supabaseIdMuscle!.compareTo(b.supabaseIdMuscle!),
                      );

                      int newIdMuscle = 1 + (sortedMuscles.isNotEmpty ? sortedMuscles.last.idMuscle! : 0);
                      dbFitness.InsertMuscle(newIdMuscle, textController.text.trim(), 1);
                      // for (var element in sortedMuscles) {
                      //   if (element.supabaseIdMuscle == 224) {
                      //     dbFitness.DeleteMuscle(element.idMuscle!);
                      //   }
                      // }

                      widget.loadParent();

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
          ],
        ),
      ),
    );
  }
}
