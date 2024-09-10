import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data_classes.dart';
import '../../init_page.dart';
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
    Provider.of<SupabaseProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: const Color.fromARGB(103, 33, 149, 243),
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
                      "new_muscle".tr(),
                      style: TextStyle(color: ColorsProvider.getColor2(context), fontSize: 20),
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
              key: keyNewMuscleEditingController,
              children: [
                Expanded(child: Container()),
                Container(
                  height: 80,
                  width: 220,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: '${"name_of_muscle".tr()}:',
                        labelStyle: TextStyle(
                          color: ColorsProvider.getColor2(context),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.getColor2(context),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.getColor2(context),
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        hintText: '${"enter_name_of_muscle".tr()}:',
                        hintStyle: TextStyle(
                          color: ColorsProvider.getColor2(context),
                          fontSize: 15,
                        ),
                      ),
                      controller: textController,
                      style: TextStyle(color: ColorsProvider.getColor2(context)),
                    ),
                  ),
                ),
                // Spacer(),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (textController.text.isNotEmpty) {
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
                                message: "error_the_name_of_new_muscle_cannot_be_empty".tr(),
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
                      backgroundColor: ColorsProvider.getColor2(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'save'.tr(),
                      style: TextStyle(
                        color: ColorsProvider.getColor8(context),
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
