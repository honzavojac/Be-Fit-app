// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_state.dart';
import 'package:kaloricke_tabulky_02/data.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/side_panel/fitness/fitness_record/test_split_page_items/test_new_split.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../../bloc/fitness_event.dart';
import '../../../providers/colors_provider.dart';
import '../../../variables.dart';
import 'test_split_page_items/test_new_exercise.dart';

// import '../../init_page.dart';
// import '../../providers/colors_provider.dart';
// import '../../variables.dart';
// import 'add_split_box copy.dart';
// import 'new_exercise_box copy.dart';

class TestSplitPage extends StatefulWidget {
  // final Function() notifyParent;
  // final Function() loadParent;
  // final int clickedSplitTab;
  // final bool foundActiveSplit;

  const TestSplitPage({
    Key? key,
    // required this.notifyParent,
    // required this.loadParent,
    // required this.clickedSplitTab,
    // required this.foundActiveSplit,
  }) : super(key: key);

  @override
  State<TestSplitPage> createState() => _TestSplitPageState();
}

class _TestSplitPageState extends State<TestSplitPage> with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 0, vsync: this);
  // List<TextEditingController> splitTextEditingControllers = [];
  // List<TextEditingController> muscleTextEditingControllers = [];
  // List<TextEditingController> exerciseTextEditingControllers = [];
  // late Map<int, TextEditingController> splitIndexMap; // Mapa pro indexy

  @override
  void initState() {
    super.initState();
    //
    // dbFirebase = Provider.of<FirestoreService>(context);
    // loadData();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // loadData();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  // void refresh() {
  //   a = 0;
  //   setState(() {});
  // }

  // bool loaded = false;
  // List<MySplit> splits = [];
  // List<MySplit> allSplits = [];

  // int a = 0;
  // Future<void> loadData() async {
  //   var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

  //   // Vyčistěte staré kontrolery a mapu
  //   // splitTextEditingControllers = [];
  //   splitIndexMap = {}; // Nová mapa pro uložení indexů

  //   // Načtěte data
  //   splits = await dbFitness.SelectAllData();
  //   allSplits = List.from(splits);

  //   // Filtrujte neaktivní položky
  //   splits.removeWhere((split) => !split.isActive);

  //   // Naplňte mapu a seznam kontrolerů
  //   for (int i = 0; i < splits.length; i++) {
  //     var split = splits[i];

  //     // Přidejte kontroler pouze pokud ještě neexistuje
  //     if (splitIndexMap[split.supabaseIdSplit!] == null) {
  //       // splitTextEditingControllers.add(TextEditingController(text: split.nameSplit));
  //       splitIndexMap[split.supabaseIdSplit!] = TextEditingController(text: split.nameSplit); // Uložení indexu do mapy
  //     }

  //     for (var selectedMuscle in split.selectedMuscle!) {
  //       selectedMuscle.selectedExercises!.removeWhere((selectedExercise) => selectedExercise.action == 3);
  //     }
  //   }

  //   if (a == 0) {
  //     clickedSplitTab = widget.clickedSplitTab;
  //     a++;
  //   }

  //   _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
  //   widget.loadParent();
  //   setState(() {});
  // }

  // // TextEditingController getControllerForSplit(String splitId) {
  // //   final index = splitIndexMap[splitId];
  // //   if (index != null && index < splitTextEditingControllers.length) {
  // //     return splitTextEditingControllers[index];
  // //   } else {
  // //     return TextEditingController(); // Pokud neexistuje, vrátí nový
  // //   }
  // // }

  // late int clickedSplitTab;
  int? _splitIndex;
  @override
  Widget build(BuildContext context) {
    // loadData();
    // print(splits);
    // var dbSupabase = Provider.of<SupabaseProvider>(context);
    // var dbFitness = Provider.of<FitnessProvider>(context);

    return BlocBuilder<FitnessBloc, FitnessState>(
      builder: (context, state) {
        if (state is FitnessLoaded) {
          List<MySplit> splits = state.splits;
          Map<int, List<SelectedMuscle>> selectedMusclesMap = state.selectedMuscleMap;
          Map<int, List<SelectedExercise>> selectedExerciseMap = state.selectedExerciseMap;

          Map<int, Muscle> muscleMap = state.muscleMap;
          Map<int, List<Exercise>> muscleExerciseMap = state.muscleExerciseMap;
          int splitIndex = state.selectedSplitIndex;

          _tabController = TabController(length: splits.length, vsync: this, initialIndex: _splitIndex ?? splitIndex);

          return Stack(
            children: [
              Positioned(
                top: -100, // Mimo zobrazení
                right: -100, // Mimo zobrazení
                child: Container(
                  // key: keySplitDummy, // Používáme prázdný prvek jako cíl
                  width: 0,
                  height: 0,
                ),
              ),
              PopScope(
                onPopInvoked: (didPop) {
                  // widget.loadParent;
                },
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      // key: keySplitPageBack,
                      onPressed: () {
                        // widget.notifyParent;
                        _splitIndex = _tabController.index;

                        Navigator.of(context).pop(true);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorsProvider.getColor2(context),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'header_edit_your_split'.tr(),
                          style: TextStyle(
                            color: ColorsProvider.getColor2(context),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            // key: keyNewSplit,
                            icon: Icon(
                              Icons.add_circle_outline_outlined,
                              color: ColorsProvider.getColor2(context),
                              size: 35,
                            ),
                            onPressed: () async {
                              // dbSupabase.generateFalseMuscleCheckbox();
                              // dbSupabase.getAllMuscles();
                              // dbSupabase.clearTextController();
                              _splitIndex = _tabController.index;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: TestNewSplit(),
                                  );
                                },
                              );
                              // await widget.loadParent();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      Container(
                        // color: const Color.fromARGB(103, 33, 149, 243),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: DefaultTabController(
                                length: splits.length,
                                initialIndex: 0,
                                child: Container(
                                  child: TabBar(
                                    onTap: (value) {
                                      //_tabController.index = value;
                                    },
                                    splashFactory: NoSplash.splashFactory,
                                    tabAlignment: TabAlignment.start,
                                    controller: _tabController,
                                    indicatorColor: ColorsProvider.getColor2(context),
                                    dividerColor: ColorsProvider.color_4,
                                    labelColor: ColorsProvider.getColor2(context),
                                    // unselectedLabelColor: Colors.white,
                                    isScrollable: true,
                                    tabs: splits.map((record) {
                                      return Container(
                                        height: 35,
                                        constraints: BoxConstraints(minWidth: 80),
                                        child: IntrinsicWidth(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5.0), // 5px padding on each side
                                            child: Center(
                                                child: Text(
                                              record.nameSplit.toString(),
                                              style: TextStyle(
                                                fontSize: 19,
                                              ),
                                            )),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: splits.map(
                                  (record) {
                                    // dbSupabase.clickedSplitTab = splits.indexOf(record);
                                    // splitTextEditingControllers[_tabController.index] = TextEditingController(text: record.nameSplit);
                                    // splits.indexOf(record);

                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                            child: ListView(
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Container(
                                                        height: 50,
                                                        width: 200, // Zmenšete šířku podle potřeby
                                                        // color: Colors.blue,
                                                        child: Center(
                                                          child: TextField(
                                                            onChanged: (value) async {
                                                              // _splitIndex = _tabController.index;
                                                              record.nameSplit = value;
                                                            },
                                                            onTapOutside: (event) {
                                                              FocusManager.instance.primaryFocus?.unfocus();

                                                              print("outsideeeeeeeeeeeeee");
                                                              context.read<FitnessBloc>().add(UpdateSplit(record));
                                                            },
                                                            controller: TextEditingController(text: record.nameSplit),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: ColorsProvider.getColor2(context),
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
                                                              contentPadding: EdgeInsets.symmetric(
                                                                horizontal: 20.0,
                                                              ),
                                                            ),
                                                            cursorColor: ColorsProvider.getColor8(context),
                                                            style: TextStyle(
                                                              color: ColorsProvider.getColor8(context),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 23,
                                                            ),
                                                            textAlign: TextAlign.center, // Zarovnání textu na střed
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: 5,
                                                        decoration: BoxDecoration(color: ColorsProvider.getColor2(context), borderRadius: BorderRadius.circular(50)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: selectedMusclesMap[record.supabaseIdSplit]!.length,
                                                        itemBuilder: (context, muscleIndex) {
                                                          SelectedMuscle selectedMuscle = selectedMusclesMap[record.supabaseIdSplit]![muscleIndex];
                                                          int idSelectedMuscle = selectedMuscle.musclesIdMuscle!;
                                                          List<SelectedExercise>? exerciseList = selectedExerciseMap[selectedMuscle.supabaseIdSelectedMuscle];
                                                          Muscle muscle = muscleMap[idSelectedMuscle]!;
                                                          return Padding(
                                                            padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                                                            child: Container(
                                                              decoration: BoxDecoration(color: ColorsProvider.getColor2(context), borderRadius: BorderRadius.circular(20)),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                                                    child: Container(
                                                                      height: 40,
                                                                      decoration: BoxDecoration(
                                                                        // color: ColorsProvider.getColor2(context),
                                                                        borderRadius: zaobleni,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: 20,
                                                                          ),
                                                                          Expanded(
                                                                            child: Center(
                                                                              child: Container(
                                                                                width: 180,
                                                                                child: TextField(
                                                                                  onChanged: (value) async {
                                                                                    _splitIndex = _tabController.index;
                                                                                    muscle.nameOfMuscle = value;

                                                                                    ///
                                                                                    ///
                                                                                  },
                                                                                  onTapOutside: (event) {
                                                                                    FocusManager.instance.primaryFocus?.unfocus();

                                                                                    print("outsideeeeeeeeeeeeee");
                                                                                    // await dbFitness.UpdateMuscle(, record.selectedMuscle![muscleIndex].muscles!.supabaseIdMuscle!);
                                                                                    context.read<FitnessBloc>().add(UpdateMuscle(muscle));

                                                                                    // widget.loadParent();
                                                                                  },
                                                                                  controller: TextEditingController(text: muscle.nameOfMuscle),
                                                                                  decoration: InputDecoration(
                                                                                    filled: true,
                                                                                    fillColor: ColorsProvider.getColor2(context),
                                                                                    enabledBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.black, width: 2),
                                                                                    ),
                                                                                    focusedBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.black, width: 3.5),
                                                                                    ),
                                                                                    border: UnderlineInputBorder(),
                                                                                    contentPadding: EdgeInsets.symmetric(
                                                                                      horizontal: 20.0,
                                                                                    ),
                                                                                  ),
                                                                                  cursorColor: ColorsProvider.getColor8(context),
                                                                                  style: TextStyle(
                                                                                    color: ColorsProvider.getColor8(context),
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 23,
                                                                                  ),
                                                                                  textAlign: TextAlign.center, // Zarovnání textu na střed
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              _splitIndex = _tabController.index;

                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return Center(
                                                                                      child: TestNewExercise(
                                                                                    muscle: muscle,
                                                                                  ));
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Icon(
                                                                              Icons.add_circle_outline_outlined,
                                                                              color: Colors.black,
                                                                              size: 35,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 20,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  (muscleExerciseMap == null || muscleExerciseMap[selectedMuscle.musclesIdMuscle] == null)
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(bottom: 15),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: ColorsProvider.getColor2(context),
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 5,
                                                                                top: 10,
                                                                              ),
                                                                              child: Container(
                                                                                child: Text(
                                                                                  "no_exercises".tr(),
                                                                                  style: TextStyle(
                                                                                    color: ColorsProvider.getColor8(context),
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Padding(
                                                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 15),
                                                                          child: Container(
                                                                            child: ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              itemCount: muscleExerciseMap[selectedMuscle.musclesIdMuscle]!.length,
                                                                              itemBuilder: (context, itemIndex) {
                                                                                Exercise exercise = muscleExerciseMap[selectedMuscle.musclesIdMuscle]![itemIndex];
                                                                                int? isSelected;
                                                                                if (exerciseList != null) {
                                                                                  for (var element in exerciseList) {
                                                                                    if (element.idExercise == exercise.supabaseIdExercise) {
                                                                                      print("ano");
                                                                                      isSelected = exerciseList.indexOf(element);
                                                                                    }
                                                                                  }
                                                                                }
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 5),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: TextField(
                                                                                            onChanged: (value) async {
                                                                                              _splitIndex = _tabController.index;
                                                                                              exercise.nameOfExercise = value;
                                                                                            },
                                                                                            onTapOutside: (event) {
                                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                                              print("outsideeeeeeeeeeeeee");
                                                                                              context.read<FitnessBloc>().add(UpdateExercise(exercise));
                                                                                            },
                                                                                            controller: TextEditingController(text: exercise.nameOfExercise),
                                                                                            minLines: 1,
                                                                                            maxLines: null,
                                                                                            decoration: InputDecoration(
                                                                                              filled: true,
                                                                                              fillColor: ColorsProvider.getColor2(context),
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
                                                                                            cursorColor: ColorsProvider.getColor8(context),
                                                                                            style: TextStyle(
                                                                                              color: ColorsProvider.getColor8(context),
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 25, right: 5),
                                                                                          child: Center(
                                                                                            child: GestureDetector(
                                                                                              onTap: () async {
                                                                                                int selectedMuscleId = selectedMuscle.supabaseIdSelectedMuscle!;
                                                                                                _splitIndex = _tabController.index;
                                                                                                context.read<FitnessBloc>().add(UpdateSelectedExercise(selectedMuscleId, exercise));
                                                                                              },
                                                                                              child: Container(
                                                                                                width: 29,
                                                                                                height: 29,
                                                                                                // child: Icon(Icons.check_box),
                                                                                                child: isSelected == null
                                                                                                    ? Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          border: Border.all(
                                                                                                            width: 2,
                                                                                                            color: Colors.black,
                                                                                                          ),
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                        ),
                                                                                                      )
                                                                                                    : Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: Colors.black,
                                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                                          border: Border.all(
                                                                                                            width: 2,
                                                                                                            color: Colors.black,
                                                                                                          ),
                                                                                                        ),
                                                                                                        child: Center(
                                                                                                          child: Text(
                                                                                                            "${isSelected + 1}",
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 15,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              color: ColorsProvider.getColor2(context),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
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
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        //   _deleteSplit(
                                        //     context: context,
                                        //     record: record,
                                        //     a: a,
                                        //     notifyParent: loadData,
                                        //     foundActiveSplit: widget.foundActiveSplit,
                                        //     onPressed: () async {
                                        //       print("update is_active in split");
                                        //       switch (record.action) {
                                        //         case 0:
                                        //           await dbFitness.DeleteSplit(
                                        //               record.supabaseIdSplit!, 2);
                                        //           break;
                                        //         case 1:
                                        //           await dbFitness.DeleteSplit(
                                        //               record.supabaseIdSplit!, 1);
                                        //           break;
                                        //         case 2:
                                        //           await dbFitness.DeleteSplit(
                                        //               record.supabaseIdSplit!, 2);
                                        //           break;
                                        //         case 3:
                                        //           break;
                                        //         case 4:
                                        //           break;
                                        //         default:
                                        //       }
                                        //       // widget.loadParent;
                                        //       clickedSplitTab = 0;
                                        //       // splitTextEditingControllers.removeAt(splits.indexOf(record));
                                        //       // loadData();
                                        //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        //       await loadData();
                                        //     },
                                        //   )
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

// ignore: must_be_immutable
class _deleteSplit extends StatefulWidget {
  final BuildContext context;
  final MySplit record;
  int a;
  final Function? notifyParent;
  final bool foundActiveSplit;
  final Function() onPressed;

  _deleteSplit({
    // ignore: unused_element
    super.key,
    required this.context,
    required this.record,
    required this.a,
    required this.notifyParent,
    required this.foundActiveSplit,
    required this.onPressed,
  });

  @override
  State<_deleteSplit> createState() => __deleteSplitState();
}

class __deleteSplitState extends State<_deleteSplit> {
  @override
  Widget build(BuildContext context) {
    Provider.of<FitnessProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
      child: Container(
        // width: 50,
        height: 45,

        child: widget.foundActiveSplit == false
            ? TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  foregroundColor: ColorsProvider.color_6,
                  backgroundColor: ColorsProvider.color_5,
                ),
                onPressed: widget.onPressed,

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     duration: Duration(seconds: 5),
                //     backgroundColor: ColorsProvider.getColor2(context),
                //     content: Container(
                //       height: 50,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             children: [
                //               Text(
                //                 'Do you want delete this split?',
                //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                //               ),
                //               Text('Data of exercises will stay save in app')
                //             ],
                //           ),
                //           ElevatedButton(
                //             style: ButtonStyle(
                //               backgroundColor: WidgetStatePropertyAll(ColorsProvider.getColor8(context)),
                //               foregroundColor: WidgetStatePropertyAll(
                //                 ColorsProvider.getColor2(context),
                //               ),
                //             ),
                //             onPressed: () async {
                //               widget.onPressed();
                //               print("object");
                //             },
                //             child: Text("yes"),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${"delete".tr()} ${widget.record.nameSplit} ${"split_delete".tr()}"),
                    SizedBox(width: 20),
                    Icon(Icons.delete),
                  ],
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  foregroundColor: ColorsProvider.color_6,
                  backgroundColor: ColorsProvider.color_5,
                  disabledForegroundColor: ColorsProvider.color_6,
                  disabledBackgroundColor: ColorsProvider.color_5.withOpacity(0.35), // Barva pozadí, když je tlačítko deaktivováno
                ),
                onPressed: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You can't delete ${widget.record.nameSplit.toUpperCase()} right now"),
                    // SizedBox(width: 20),
                    // Icon(Icons.delete),
                  ],
                ),
              ),
      ),
    );
  }
}
/*
Widget _deleteSplit() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
    child: Container(
      // width: 50,
      height: 45,

      child: == true
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                foregroundColor: ColorsProvider.color_6,
                backgroundColor: ColorsProvider.color_5,
              ),
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 5),
                    backgroundColor: ColorsProvider.getColor2(context),
                    content: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Do you want delete this split?',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Text('Data of exercises will stay save in app')
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(ColorsProvider.getColor8(context)),
                              foregroundColor: WidgetStatePropertyAll(
                                ColorsProvider.getColor2(context),
                              ),
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              int idSplit = record.idSplit!;
                              await dbSupabase.deleteSplit(idSplit);
                              await dbSupabase.getFitness();
                              dbSupabase.clickedSplitTab = 0;
                              a = 0;
                              notifyParent;
                              setState(() {});
                            },
                            child: Text("yes"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Delete ${record.nameSplit} split"),
                  SizedBox(width: 20),
                  Icon(Icons.delete),
                ],
              ),
            )
          : Text("You can't delete this split right now"),
    ),
  );
}

*/
