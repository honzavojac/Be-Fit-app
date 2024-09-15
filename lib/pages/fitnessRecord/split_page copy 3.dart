// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/variables_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../init_page.dart';
import '../../providers/colors_provider.dart';
import 'add_split_box copy.dart';
import 'new_exercise_box copy.dart';

class SplitPageCopy extends StatefulWidget {
  final Function() notifyParent;
  final Function() loadParent;
  final int clickedSplitTab;
  final bool foundActiveSplit;

  const SplitPageCopy({
    Key? key,
    required this.notifyParent,
    required this.loadParent,
    required this.clickedSplitTab,
    required this.foundActiveSplit,
  }) : super(key: key);

  @override
  State<SplitPageCopy> createState() => _SplitPageCopyState();
}

class _SplitPageCopyState extends State<SplitPageCopy> with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 0, vsync: this);
  // List<TextEditingController> splitTextEditingControllers = [];
  List<TextEditingController> muscleTextEditingControllers = [];
  List<TextEditingController> exerciseTextEditingControllers = [];
  late Map<int, TextEditingController> splitIndexMap; // Mapa pro indexy

  @override
  void initState() {
    super.initState();
    //
    // dbFirebase = Provider.of<FirestoreService>(context);
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    a = 0;
    setState(() {});
  }

  bool loaded = false;
  List<MySplit> splits = [];
  List<MySplit> allSplits = [];

  int a = 0;
  Future<void> loadData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    // Vyčistěte staré kontrolery a mapu
    // splitTextEditingControllers = [];
    splitIndexMap = {}; // Nová mapa pro uložení indexů

    // Načtěte data
    splits = await dbFitness.SelectAllData();
    allSplits = List.from(splits);

    // Filtrujte neaktivní položky
    splits.removeWhere((split) => !split.isActive);

    // Naplňte mapu a seznam kontrolerů
    for (int i = 0; i < splits.length; i++) {
      var split = splits[i];

      // Přidejte kontroler pouze pokud ještě neexistuje
      if (splitIndexMap[split.supabaseIdSplit!] == null) {
        // splitTextEditingControllers.add(TextEditingController(text: split.nameSplit));
        splitIndexMap[split.supabaseIdSplit!] = TextEditingController(text: split.nameSplit); // Uložení indexu do mapy
      }

      for (var selectedMuscle in split.selectedMuscle!) {
        selectedMuscle.selectedExercises!.removeWhere((selectedExercise) => selectedExercise.action == 3);
      }
    }

    if (a == 0) {
      clickedSplitTab = widget.clickedSplitTab;
      a++;
    }

    _tabController = TabController(length: splits.length, vsync: this, initialIndex: clickedSplitTab);
    widget.loadParent();
    setState(() {});
  }

  // TextEditingController getControllerForSplit(String splitId) {
  //   final index = splitIndexMap[splitId];
  //   if (index != null && index < splitTextEditingControllers.length) {
  //     return splitTextEditingControllers[index];
  //   } else {
  //     return TextEditingController(); // Pokud neexistuje, vrátí nový
  //   }
  // }

  late int clickedSplitTab;
  @override
  Widget build(BuildContext context) {
    var variablesProvider = Provider.of<VariablesProvider>(context);

    // loadData();
    // print(splits);
    print(widget.clickedSplitTab);
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);

    if (splits.isEmpty) {
      return Stack(
        children: [
          Positioned(
            top: -100, // Mimo zobrazení
            right: -100, // Mimo zobrazení
            child: Container(
              key: keySplitDummy, // Používáme prázdný prvek jako cíl
              width: 0,
              height: 0,
            ),
          ),
          PopScope(
            onPopInvoked: (didPop) {
              widget.notifyParent;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  key: keySplitPageBack,
                  onPressed: () {
                    widget.notifyParent;
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
                      style: TextStyle(),
                    ),
                    Container(
                      child: IconButton(
                        key: keyNewSplit,
                        icon: Icon(
                          Icons.add_circle_outline_outlined,
                          color: ColorsProvider.getColor2(context),
                          size: 35,
                        ),
                        onPressed: () {
                          dbSupabase.generateFalseMuscleCheckbox();
                          dbSupabase.getAllMuscles();
                          dbSupabase.clearTextController();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: AddSplitBoxCopy(
                                  loadParent: loadData,
                                  splits: allSplits,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                  // color: const Color.fromARGB(103, 33, 149, 243),
                  ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Positioned(
            top: -100, // Mimo zobrazení
            right: -100, // Mimo zobrazení
            child: Container(
              key: keySplitDummy, // Používáme prázdný prvek jako cíl
              width: 0,
              height: 0,
            ),
          ),
          PopScope(
            onPopInvoked: (didPop) {
              widget.loadParent;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  key: keySplitPageBack,
                  onPressed: () {
                    widget.notifyParent;
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
                        key: keyNewSplit,
                        icon: Icon(
                          Icons.add_circle_outline_outlined,
                          color: ColorsProvider.getColor2(context),
                          size: 35,
                        ),
                        onPressed: () async {
                          dbSupabase.generateFalseMuscleCheckbox();
                          dbSupabase.getAllMuscles();
                          dbSupabase.clearTextController();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: AddSplitBoxCopy(
                                  loadParent: loadData,
                                  splits: allSplits,
                                ),
                              );
                            },
                          );
                          await widget.loadParent();
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
                                        )
                                            // TextField(
                                            //   controller: splitTextEditingControllers[splits.indexOf(record)],
                                            //   readOnly: true,
                                            //   enabled: false,
                                            //   textAlign: TextAlign.center,
                                            //   decoration: InputDecoration(
                                            //     border: InputBorder.none,
                                            //   ),
                                            //   style: TextStyle(
                                            //     color: splitTextEditingControllers[splits.indexOf(record)].text != record.nameSplit ? ColorsProvider.getColor2(context) : Colors.white, // Optional: Set the text color
                                            //     fontSize: 19, // Optional: Set the text size
                                            //   ),
                                            // ),
                                            ),
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
                                splits.indexOf(record);

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
                                                          clickedSplitTab = await _tabController.index;
                                                          await dbFitness.UpdateSplit(value, record.supabaseIdSplit!);
                                                          // print(clickedSplitTab);
                                                          widget.loadParent();
                                                          record.nameSplit = value;
                                                        },
                                                        controller: splitIndexMap[record.supabaseIdSplit!],
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
                                                    itemCount: record.selectedMuscle!.length,
                                                    itemBuilder: (context, muscleIndex) {
                                                      int idSelectedMuscle = record.selectedMuscle![muscleIndex].supabaseIdSelectedMuscle!;
                                                      int idMuscle = record.selectedMuscle![muscleIndex].musclesIdMuscle!;
                                                      List<Exercise> exercises = record.selectedMuscle![muscleIndex].muscles!.exercises!;
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
                                                                    borderRadius: variablesProvider.zaobleni,
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
                                                                                clickedSplitTab = await _tabController.index;
                                                                                await dbFitness.UpdateMuscle(value, record.selectedMuscle![muscleIndex].muscles!.supabaseIdMuscle!);
                                                                                print(clickedSplitTab);
                                                                                widget.loadParent();
                                                                              },
                                                                              onTapOutside: (event) async {
                                                                                // await dbFitness.UpdateMuscle(, record.selectedMuscle![muscleIndex].muscles!.supabaseIdMuscle!);

                                                                                widget.loadParent();
                                                                              },
                                                                              controller: TextEditingController(text: record.selectedMuscle![muscleIndex].muscles!.nameOfMuscle),
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
                                                                          clickedSplitTab = _tabController.index;
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return Center(
                                                                                  child: NewExerciseBoxCopy(
                                                                                idMuscle: idMuscle,
                                                                                loadParent: loadData,
                                                                                notifyParent: refresh,
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
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 15),
                                                                child: Container(
                                                                  child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemCount: exercises.length,
                                                                    itemBuilder: (context, itemIndex) {
                                                                      // var exercises = record.selectedMuscle![muscleIndex].muscles!.exercises;
                                                                      var selectedExercises = record.selectedMuscle![muscleIndex].selectedExercises!;
                                                                      String nameOfExercise = exercises[itemIndex].nameOfExercise!;
                                                                      int supabaseIdExercise = exercises[itemIndex].supabaseIdExercise!;
                                                                      int order = 0;

                                                                      bool isChecked = false;

                                                                      function:
                                                                      for (var j = 0; j < selectedExercises.length; j++) {
                                                                        // print(selectedExercises[j].action);
                                                                        if (exercises[itemIndex].supabaseIdExercise == selectedExercises[j].exercises!.supabaseIdExercise) {
                                                                          isChecked = true;
                                                                          order = j + 1;
                                                                          break function;
                                                                        } else {
                                                                          // order = 1;
                                                                          isChecked = false;
                                                                        }
                                                                      }
                                                                      return Padding(
                                                                        padding: const EdgeInsets.only(bottom: 5),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                                                          child: Row(
                                                                            // mainAxisAlignment: MainAxisAlignment.,
                                                                            children: [
                                                                              Expanded(
                                                                                child: TextField(
                                                                                  controller: TextEditingController(text: nameOfExercise),
                                                                                  onChanged: (value) async {
                                                                                    clickedSplitTab = await _tabController.index;
                                                                                    await dbFitness.UpdateExercise(value, supabaseIdExercise);
                                                                                    print(clickedSplitTab);
                                                                                    widget.loadParent();
                                                                                  },
                                                                                  // controller: exercisesTextEditingControllers[itemIndex],
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
                                                                                      clickedSplitTab = _tabController.index;

                                                                                      if (isChecked == true) {
                                                                                        for (var i = 0; i < selectedExercises.length; i++) {
                                                                                          if (selectedExercises[i].idExercise == exercises[itemIndex].supabaseIdExercise) {
                                                                                            print("update item");
                                                                                            switch (selectedExercises[i].action) {
                                                                                              case 0:
                                                                                                print("delete ze supabase");
                                                                                                // action 3 protože to potřebuju smazat ze supabase
                                                                                                print(selectedExercises[i].exercises!.nameOfExercise!);
                                                                                                print(selectedExercises[i].supabaseIdSelectedExercise);
                                                                                                await dbFitness.UpdateSelectedExercise(3, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                                break;
                                                                                              case 1:
                                                                                                print("delete ze sqflite");
                                                                                                //delete
                                                                                                await dbFitness.DeleteSelectedExercise(selectedExercises[i].idSelectedExercise!);
                                                                                                break;
                                                                                              case 2:
                                                                                                break;
                                                                                              case 3:
                                                                                                break;
                                                                                              default:
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else if (isChecked == false) {
                                                                                        funkce:
                                                                                        {
                                                                                          for (var i = 0; i < selectedExercises.length; i++) {
                                                                                            if (selectedExercises[i].idExercise == exercises[itemIndex].supabaseIdExercise) {
                                                                                              switch (selectedExercises[i].action) {
                                                                                                case 0:
                                                                                                  await dbFitness.UpdateSelectedExercise(2, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                                  break funkce;

                                                                                                case 1:
                                                                                                  // tento stav nenastane protože když je ischecked false tak nikdy se nebude isertovat ischecked false
                                                                                                  print("CHYBA !!! POZOR, NĚCO JE ŠPATNĚ");
                                                                                                  break;
                                                                                                case 2:
                                                                                                  await dbFitness.UpdateSelectedExercise(0, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                                  break funkce;
                                                                                                case 3:
                                                                                                  await dbFitness.UpdateSelectedExercise(0, selectedExercises[i].supabaseIdSelectedExercise!);
                                                                                                  break funkce;
                                                                                                default:
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                          int newSupabaseIdSelectedIdExercise = 1 + (selectedExercises.isNotEmpty ? selectedExercises.last.supabaseIdSelectedExercise! : 0);
                                                                                          await dbFitness.InsertSelectedExercise(newSupabaseIdSelectedIdExercise, exercises[itemIndex].supabaseIdExercise!, idSelectedMuscle, 1);

                                                                                          print("newSupabaseIdSelectedExercise: $newSupabaseIdSelectedIdExercise");
                                                                                        }
                                                                                      }

                                                                                      // await dbFitness.InsertSelectedExercise(2, 1, 1, 1);
                                                                                      widget.loadParent();
                                                                                      print("load data");
                                                                                      loadData();
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 29,
                                                                                      height: 29,
                                                                                      // child: Icon(Icons.check_box),
                                                                                      child: isChecked == false
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
                                                                                                  "${order}",
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
                                          ],
                                        ),
                                      ),
                                    ),
                                    _deleteSplit(
                                      context: context,
                                      record: record,
                                      a: a,
                                      notifyParent: loadData,
                                      foundActiveSplit: widget.foundActiveSplit,
                                      onPressed: () async {
                                        print("update is_active in split");
                                        switch (record.action) {
                                          case 0:
                                            await dbFitness.DeleteSplit(record.supabaseIdSplit!, 2);
                                            break;
                                          case 1:
                                            await dbFitness.DeleteSplit(record.supabaseIdSplit!, 1);

                                            break;
                                          case 2:
                                            await dbFitness.DeleteSplit(record.supabaseIdSplit!, 2);

                                            break;
                                          case 3:
                                            break;
                                          case 4:
                                            break;
                                          default:
                                        }

                                        // widget.loadParent;
                                        clickedSplitTab = 0;
                                        // splitTextEditingControllers.removeAt(splits.indexOf(record));
                                        // loadData();
                                        // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                        await loadData();
                                      },
                                    )
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