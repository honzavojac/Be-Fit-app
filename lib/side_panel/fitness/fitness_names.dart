import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

class FitnessNames extends StatefulWidget {
  const FitnessNames({super.key});

  @override
  State<FitnessNames> createState() => FitnessNamesState();
}

List<TextEditingController> splitTextEditingControllers = [];
List<TextEditingController> musclesTextEditingControllers = [];

List<TextEditingController> exercisesTextEditingControllers = [];

class FitnessNamesState extends State<FitnessNames> with WidgetsBindingObserver {
  int selectedIndex = 0;
  List<String> items = ["", "Splits", "Muscles", "Exercises"];
  List<dynamic> data = [];
  List<dynamic> splitData = [];
  List<bool> updateSplits = [];
  List<bool> updateMuscles = [];
  Map<int, List<bool>> updateExercises = {};

  loadData() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    data = [];

    print(selectedIndex);

    switch (selectedIndex) {
      case 1:
        await dbSupabase.getFitness();

        data = await dbSupabase.splits;
        splitData = data;
        if (updateSplits.isEmpty) {
          updateSplits = List.generate(data.length, (index) => false);
        }

        break;
      case 2:
        await dbSupabase.getAllMuscles();

        data = dbSupabase.muscles;

        if (updateMuscles.isEmpty) {
          updateMuscles = List.generate(data.length, (index) => false);
        }

        break;
      case 3:
        await dbSupabase.getAllMuscles();
        data = await dbSupabase.muscles;

        for (int i = 0; i < data.length; i++) {
          if (!updateExercises.containsKey(i)) {
            updateExercises[i] = List.generate(data[i].exercises.length, (index) => false);
          } else {
            for (var j = updateExercises[i]!.length; j < data[i].exercises.length; j++) {
              updateExercises[i]!.add(false);
            }
          }
        }

        break;
      default:
    }
    setState(() {});
  }

  notifyParent() {
    setState(() {});
  }

  updateText() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    print(splitTextEditingControllers.length);
    print(updateSplits.length);
    print(splitData.length);
    for (var i = 0; i < updateSplits.length; i++) {
      if (updateSplits[i] == true) {
        print("raw update");
        await dbSupabase.updateSplit(splitData[i].idSplit, splitTextEditingControllers[i].text.trim());
      }
    }
  }

  AppLifecycleState? _lastLifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Pokud je aktuální stav stejný jako poslední stav, neprovádějte nic
    if (_lastLifecycleState == state) return;

    if (state == AppLifecycleState.paused) {
      if (mounted) {
        try {
          print("update");
          await updateText();
        } catch (e) {
          print("chyba v fitness_names při vkládání dat změněním stavu aplikace (zavřená app): $e");
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      print("resumed");
    }
    _lastLifecycleState = state;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    splitTextEditingControllers = [];
    musclesTextEditingControllers = [];
    exercisesTextEditingControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    // loadData();
    return PopScope(
      onPopInvoked: (didPop) async {
        if (mounted) {
          // widget.notifyParent;
          // widget.loadData;
          print("popscope---------------------------");
          try {} on Exception catch (e) {
            print(e);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage fitness names"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDropdown(
                    items: items,
                    hint: "choose what you want to change",
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = items.indexOf(value!);
                        loadData();
                      });
                    },
                    selectedIndex: selectedIndex,
                    notifyParent: notifyParent,
                  ),
                ],
              ),
            ),
            _myListViewBuilder(
              data,
              selectedIndex,
              context,
              updateSplits,
              updateMuscles,
              updateExercises,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final Function(String?) onChanged;
  final int selectedIndex;
  final Function() notifyParent;

  CustomDropdown({
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.selectedIndex,
    required this.notifyParent,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);
    return Container(
      width: 260,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          hint: Text(
            widget.hint,
            style: TextStyle(fontSize: 14),
          ),
          isExpanded: true,
          value: widget.selectedIndex == 0 ? null : widget.items[widget.selectedIndex],
          items: widget.items.skip(1).map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Center(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsProvider.color_1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
          buttonStyleData: ButtonStyleData(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: variablesProvider.zaobleni,
              border: Border.all(
                color: ColorsProvider.color_2,
                width: 0.5,
              ),
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_outlined),
            iconSize: 17,
            iconEnabledColor: ColorsProvider.color_1,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: variablesProvider.zaobleni,
              border: Border.all(width: 2, color: ColorsProvider.color_2),
            ),
            offset: const Offset(0, -0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 0, right: 18),
          ),
        ),
      ),
    );
  }
}

Widget _myListViewBuilder(List<dynamic> data, int index, BuildContext context, List<bool>? updateSplits, List<bool>? updateMuscles, Map<int, List<bool>>? updateExercises) {
  for (var i = 0; i < data.length; i++) {
    switch (index) {
      case 1:
        splitTextEditingControllers.add(TextEditingController(text: data[i].nameSplit));
        break;
      case 2:
        musclesTextEditingControllers.add(TextEditingController(text: data[i].nameOfMuscle));

        break;
      case 3:
        for (var j = 0; j < data[i].exercises.length; j++) {
          exercisesTextEditingControllers.add(TextEditingController(text: data[i].exercises[j].nameOfExercise));
        }
        break;
      default:
    }
  }
  var variablesProvider = Provider.of<VariablesProvider>(context);
  print("aaaaaaaaaaaaaaaaa$index");
  return index == 1 || index == 2
      ? Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, listViewIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                // color: ColorsProvider.color_2,
                                borderRadius: variablesProvider.zaobleni,
                              ),
                              child: Center(
                                child: Text(
                                  index == 1 ? "Splits".toUpperCase() : "Muscles".toUpperCase(),
                                  style: TextStyle(
                                    color: ColorsProvider.color_8,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 15),
                            child: Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, itemIndex) {
                                  String item = index == 1
                                      ? data[itemIndex].nameSplit
                                      : index == 2
                                          ? data[itemIndex].nameOfMuscle
                                          : "";
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                      child: TextField(
                                        onChanged: (value) {
                                          if (index == 1) {
                                            updateSplits![itemIndex] = true;
                                          } else if (index == 2) {
                                            updateMuscles![itemIndex] = true;
                                          }
                                        },
                                        controller: index == 1
                                            ? splitTextEditingControllers[itemIndex]
                                            : index == 2
                                                ? musclesTextEditingControllers[itemIndex]
                                                : TextEditingController(),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: ColorsProvider.color_2,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 3.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                        ),
                                        cursorColor: ColorsProvider.color_8,
                                        style: TextStyle(
                                          color: ColorsProvider.color_8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      : index == 3
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, muscleIndex) {
                      String muscle = data[muscleIndex].nameOfMuscle;
                      List<Exercise> exercises = data[muscleIndex].exercises;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(color: ColorsProvider.color_2, borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    // color: ColorsProvider.color_2,
                                    borderRadius: variablesProvider.zaobleni,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$muscle".toUpperCase(),
                                      style: TextStyle(
                                        color: ColorsProvider.color_8,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 15),
                                child: Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: exercises.length,
                                    itemBuilder: (context, itemIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                          child: TextField(
                                            onChanged: (value) {
                                              updateExercises![muscleIndex]![itemIndex] = true;
                                            },
                                            controller: exercisesTextEditingControllers[itemIndex],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: ColorsProvider.color_2,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.black, width: 2),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.black, width: 3.5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                            ),
                                            cursorColor: ColorsProvider.color_8,
                                            style: TextStyle(
                                              color: ColorsProvider.color_8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          //
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          // ListView.builder(
          //     itemCount: data.length,
          //     itemBuilder: (context, muscleIndex) {
          //       Muscle muscle = data[muscleIndex];
          //       List<Exercise>? exercises = muscle.exercises;

          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: ColorsProvider.color_2,
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: Center(
          //               child: Text(
          //                 muscle.nameOfMuscle.toUpperCase(),
          //                 style: TextStyle(
          //                   fontSize: 22,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             height: exercises!.length * 55,
          //             child: ListView.builder(
          //               primary: false,
          //               shrinkWrap: false,
          //               itemCount: exercises.length,
          //               itemBuilder: (context, exerciseIndex) {
          //                 Exercise exercise = exercises[exerciseIndex];

          //                 return Padding(
          //                   padding: EdgeInsets.fromLTRB(20, 1, 20, 1),
          //                   child: Container(
          //                     width: double.infinity, // Šířka na celou dostupnou šířku
          //                     height: 50,
          //                     child: TextField(
          //                       controller: TextEditingController(text: exercise.nameOfExercise),
          //                       decoration: InputDecoration(
          //                         filled: true,
          //                         fillColor: ColorsProvider.color_2,
          //                         enabledBorder: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12),
          //                           borderSide: BorderSide(color: Colors.black, width: 3),
          //                         ),
          //                         focusedBorder: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12),
          //                           borderSide: BorderSide(color: Colors.black, width: 0),
          //                         ),
          //                         border: OutlineInputBorder(
          //                           borderRadius: BorderRadius.circular(12),
          //                         ),
          //                         contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          //                       ),
          //                       cursorColor: ColorsProvider.color_8,
          //                       style: TextStyle(
          //                         color: ColorsProvider.color_8,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //   )
          : Container();
}
