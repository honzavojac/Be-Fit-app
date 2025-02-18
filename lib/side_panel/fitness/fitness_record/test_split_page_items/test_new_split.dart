import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_bloc.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_record/test_split_page_items/test_new_muscle.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../bloc/fitness_event.dart';
import '../../../../bloc/fitness_state.dart';

class TestNewSplit extends StatefulWidget {
  const TestNewSplit({
    Key? key,
  }) : super(key: key);

  @override
  _TestNewSplitState createState() => _TestNewSplitState();
}

class _TestNewSplitState extends State<TestNewSplit> {
  var _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Future<void> loadData() async {
  //   var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
  //   muscles = await dbFitness.SelectMuscles();
  //   if (isCheckedList.isEmpty) {
  //     muscles.forEach((element) {
  //       isCheckedList.add(false);
  //     });
  //   } else if (muscles.length == isCheckedList.length + 1) {
  //     isCheckedList.add(false);
  //   }

  //   splits = widget.splits;
  //   splits.sort((a, b) => a.supabaseIdSplit!.compareTo(b.supabaseIdSplit!));
  //   for (var element in splits) {
  //     print(element.printSplit());
  //   }
  //   setState(() {});
  // }

  void refresh() {
    setState(() {});
  }

  List<bool> isCheckedList = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessBloc, FitnessState>(
      builder: (context, state) {
        if (state is FitnessLoaded) {
          List<Muscle> muscles = state.muscles;
          muscles.sort(
            (a, b) => a.supabaseIdMuscle!.compareTo(b.supabaseIdMuscle!),
          );
          muscles.forEach(
            (element) => isCheckedList.add(false),
          );
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
                                    // color: ColorsProvider.getColor8(context),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: TextField(
                                        // key: keyNameOfWorkout,
                                        decoration: InputDecoration(
                                          labelText: '${"name_of_split".tr()}:',
                                          labelStyle: TextStyle(
                                            color: ColorsProvider.getColor2(context),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ColorsProvider.getColor2(context),
                                              width: 0.5,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ColorsProvider.getColor2(context),
                                              width: 3.0,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 15,
                                          ),
                                          hintText: '${"enter_name_of_split".tr()}:',
                                          hintStyle: TextStyle(
                                            color: ColorsProvider.getColor2(context),
                                            fontSize: 15,
                                          ),
                                        ),
                                        controller: _textController,
                                        style: TextStyle(color: ColorsProvider.getColor2(context)),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              child: Container(
                                // key: keyIsCheckedMuscles,
                                child: ListView.builder(
                                  itemCount: muscles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  muscles[index].supabaseIdMuscle!.toString() + " ",
                                                ),
                                                Text(
                                                  muscles[index].nameOfMuscle!,
                                                ),
                                              ],
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
                        // key: keySaveSplit,
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if (_textController.text.trim().isNotEmpty) {
                              if (isCheckedList.contains(true)) {
                                List<Muscle> selectedMuscles = [];
                                for (var i = 0; i < isCheckedList.length; i++) {
                                  if (isCheckedList[i] == true) {
                                    selectedMuscles.add(muscles[i]);
                                  }
                                }
                                context.read<FitnessBloc>().add(AddNewSplit(_textController.text, selectedMuscles));

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
                                        message: "error_you_have_not_selected_any_muscle".tr(),
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
                                      message: "error_name_of_split_is_empty".tr(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 150,
                          height: 35,
                          child: ElevatedButton(
                            // key: keyNewMuscle,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                ColorsProvider.getColor2(context),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(child: TestNewMuscle());
                                },
                              );
                            },
                            child: Text(
                              "new_muscle".tr(),
                              style: TextStyle(color: ColorsProvider.getColor8(context)),
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
        return Container();
      },
    );
  }
}
