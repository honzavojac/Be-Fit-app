// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page%20copy.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/split_page%20copy%203.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'pages/fitnessRecord/add_split_box copy.dart';
import 'pages/fitnessRecord/new_muscle_box copy.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

UserSupabase? user;
var controller = PageController(initialPage: 1);
var pageProvider = 1;

//Fitness

GlobalKey keyButton1 = GlobalKey();
GlobalKey keyFitnesRecordPage = GlobalKey();
GlobalKey keyEditWorkouts = GlobalKey();
GlobalKey keyNewSplit = GlobalKey();
GlobalKey keyNewMuscle = GlobalKey();
GlobalKey keyNewMuscleEditingController = GlobalKey();
GlobalKey keyNameOfWorkout = GlobalKey();
GlobalKey keyIsCheckedMuscles = GlobalKey();
GlobalKey keySaveSplit = GlobalKey();
GlobalKey keyNewExercise = GlobalKey();
GlobalKey keyDummy = GlobalKey();
GlobalKey keySplitPageBack = GlobalKey();
GlobalKey keyDummy1 = GlobalKey();

//jídlo
GlobalKey keySearchBar = GlobalKey();
GlobalKey keySearchAddButton = GlobalKey();
GlobalKey keyDummy2 = GlobalKey();
GlobalKey keyNewFood = GlobalKey();
GlobalKey keyNewFoodPage = GlobalKey();

//měření těla
GlobalKey keyMeasurementButton = GlobalKey();

GlobalKey keyBottomNavigation1 = GlobalKey();
GlobalKey keyBottomNavigation2 = GlobalKey();
GlobalKey keyBottomNavigation3 = GlobalKey();

class _InitPageState extends State<InitPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // final List<Widget> _appBars = [
  //   FitnessRecordAppBarCopy(),
  //   HomeAppBar(),
  //   FoodRecordAppBar(),
  // ];
  late bool switchButton;
  // List<Widget> _pages = [
  // switchButton == false ? FitnessRecordScreenCopy() : FitnessRecordScreen(),
  //   HomeScreen(),
  //   FoodRecordScreen(),
  // ];
  // @override
  // void initState() {
  //   var dbSupabase = Provider.of<SupabaseProvider>(context);
  //   dbSupabase.initialize();
  //   super.initState();
  // }
  bool iconPage = true;
  @override
  void initState() {
    super.initState();
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    dbFitness.setSyncingToFalse();
    createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
    // showTutorial();
  }

  bool loading = true;
  Future<void> loadDataFromSupabase() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    switchButton = dbFitness.switchButton;

    // Definování proměnných pro ukládání dat
    List<Muscle> supabaseMuscleList = [];
    List<Exercise> supabaseExerciseList = [];
    List<ExerciseData> supabaseExerciseDataList = [];
    List<MySplit> supabaseSplitList = [];
    List<SelectedMuscle> supabaseSelectedMuscleList = [];
    List<SelectedExercise> supabaseSelectedExerciseList = [];
    List<SplitStartedCompleted> supabaseSplitStartedCompletedList = [];
    List<Measurements> supabaseBodyMeasurementsList = [];
    List<IntakeCategories> supabaseIntakeCategoriesList = [];
    List<NutriIntake> supabaseNutriIntakeList = [];
    late UserSupabase supabaseUser;

    if (loading) {
      // Načtení dat ze Sqflite
      List result = await Future.wait([
        dbFitness.SelectMuscles(),
        dbFitness.SelectExercises(),
        dbFitness.SelectExerciseData(),
        dbFitness.SelectSplit(),
        dbFitness.SelectSelectedMuscles(),
        dbFitness.SelectSelectedExercises(),
        dbFitness.SelectSplitStartedCompleted(),
        dbFitness.SelectMeasurements(),
        dbFitness.SelectIntakeCategories(),
        dbFitness.SelectNutriIntakes(),
        dbFitness.SelectFood(),
        dbFitness.SelectUser(),
      ]);

      List<Muscle> sqfliteMuscleList = result[0];
      List<Exercise> sqfliteExerciseList = result[1];
      List<ExerciseData> sqfliteExerciseDataList = result[2];
      List<MySplit> sqfliteSplitList = result[3];
      List<SelectedMuscle> sqfliteSelectedMuscleList = result[4];
      List<SelectedExercise> sqfliteSelectedExerciseList = result[5];
      List<SplitStartedCompleted> sqfliteSplitStartedCompletedList = result[6];
      List<Measurements> sqfliteBodyMeasurementsList = result[7];
      List<IntakeCategories> sqfliteIntakeCategoriesList = result[8];
      List<NutriIntake> sqfliteNutriIntakeList = result[9];
      List<Food> sqfliteFoodList = result[10];
      UserSupabase? sqfliteUser = result[11];

      if (sqfliteMuscleList.isEmpty || sqfliteExerciseList.isEmpty || sqfliteExerciseDataList.isEmpty || sqfliteSplitList.isEmpty || sqfliteSelectedMuscleList.isEmpty || sqfliteSelectedExerciseList.isEmpty || sqfliteSplitStartedCompletedList.isEmpty || sqfliteBodyMeasurementsList.isEmpty || sqfliteIntakeCategoriesList.isEmpty || sqfliteNutriIntakeList.isEmpty || sqfliteFoodList.isEmpty || sqfliteUser == null) {
        if (iconPage) {
          iconPage = false;
        } else {
          List result = await Future.wait([
            dbSupabase.MuscleTable(),
            dbSupabase.ExerciseTable(),
            dbSupabase.ExerciseDataTable(),
            dbSupabase.SplitTable(),
            dbSupabase.SelectedMuscleTable(),
            dbSupabase.SelectedExericseTable(),
            dbSupabase.SplitStartedCompletedTable(),
            dbSupabase.BodyMeasurementsTable(),
            dbSupabase.IntakeCategoriesTable(),
            dbSupabase.NutriIntakeTable(),
            dbSupabase.getUser(),
          ]);
          // Načtení dat ze Supabase
          supabaseMuscleList = result[0];
          supabaseExerciseList = result[1];
          supabaseExerciseDataList = result[2];
          supabaseSplitList = result[3];
          supabaseSelectedMuscleList = result[4];
          supabaseSelectedExerciseList = result[5];
          supabaseSplitStartedCompletedList = result[6];
          supabaseBodyMeasurementsList = result[7];
          supabaseIntakeCategoriesList = result[8];
          supabaseNutriIntakeList = result[9];
          supabaseUser = result[10];
          // final MuscleLoading = dbSupabase.MuscleTable();
          // final ExerciseLoading = dbSupabase.ExerciseTable();
          // final ExerciseDataLoading = dbSupabase.ExerciseDataTable();
          // final SplitLoading = dbSupabase.SplitTable();
          // final SelectedMuscleLoading = dbSupabase.SelectedMuscleTable();
          // final SelectedExerciseLoading = dbSupabase.SelectedExericseTable();
          // final SplitStartedCompletedLoading = dbSupabase.SplitStartedCompletedTable();
          // final DataMeasurementsLoading = dbSupabase.BodyMeasurementsTable();
          // final IntakeCategoriesLoading = dbSupabase.IntakeCategoriesTable();
          // final NutriIntakeLoading = dbSupabase.NutriIntakeTable();

          // supabaseMuscleList = await MuscleLoading;
          // supabaseExerciseList = await ExerciseLoading;
          // supabaseExerciseDataList = await ExerciseDataLoading;
          // supabaseSplitList = await SplitLoading;
          // supabaseSelectedMuscleList = await SelectedMuscleLoading;
          // supabaseSelectedExerciseList = await SelectedExerciseLoading;
          // supabaseSplitStartedCompletedList = await SplitStartedCompletedLoading;
          // supabaseBodyMeasurementsList = await DataMeasurementsLoading;
          // supabaseIntakeCategoriesList = await IntakeCategoriesLoading;
          // supabaseNutriIntakeList = await NutriIntakeLoading;

          // Vložení dat ze Supabase do Sqflite
          await dbFitness.database.transaction((txn) async {
            if (sqfliteMuscleList.isEmpty) {
              for (var muscle in supabaseMuscleList) {
                try {
                  await txn.rawInsert('''
          INSERT INTO muscles (
            supabase_id_muscle, 
            name_of_muscle, 
            action
          ) 
          VALUES (?, ?, ?)
        ''', [muscle.idMuscle, muscle.nameOfMuscle, 0]);
                } catch (e) {
                  print("Error inserting muscle: $e");
                }
              }
            }

            if (sqfliteExerciseList.isEmpty) {
              for (var exercise in supabaseExerciseList) {
                dbFitness.TxnInsertExercise(txn, exercise.idExercise!, exercise.nameOfExercise!, exercise.musclesIdMuscle!, 0);
              }
            }

            if (sqfliteExerciseDataList.isEmpty) {
              for (var exerciseData in supabaseExerciseDataList) {
                dbFitness.TxnInsertExerciseData(
                  txn,
                  exerciseData.idExData!,
                  exerciseData.weight,
                  exerciseData.reps,
                  exerciseData.difficulty,
                  exerciseData.technique,
                  exerciseData.comment,
                  exerciseData.time,
                  exerciseData.exercisesIdExercise!,
                  exerciseData.idStartedCompleted!,
                  0,
                );
              }
            }

            if (sqfliteSplitList.isEmpty) {
              for (var split in supabaseSplitList) {
                dbFitness.TxnInsertSplit(txn, split.idSplit!, split.nameSplit, split.createdAt!, split.isActive, 0);
              }
            }

            if (sqfliteSelectedMuscleList.isEmpty) {
              for (var selectedMuscle in supabaseSelectedMuscleList) {
                dbFitness.TxnInsertSelectedMuscle(txn, selectedMuscle.idSelectedMuscle!, selectedMuscle.splitIdSplit!, selectedMuscle.musclesIdMuscle!, 0);
              }
            }

            if (sqfliteSelectedExerciseList.isEmpty) {
              for (var selectedExercise in supabaseSelectedExerciseList) {
                dbFitness.TxnInsertSelectedExercise(txn, selectedExercise.idSelectedExercise!, selectedExercise.idExercise!, selectedExercise.idSelectedMuscle!, 0);
              }
            }

            if (sqfliteSplitStartedCompletedList.isEmpty) {
              for (var splitStartedCompleted in supabaseSplitStartedCompletedList) {
                dbFitness.TxnInsertSplitStartedCompleted(
                  txn,
                  splitStartedCompleted.idStartedCompleted!,
                  splitStartedCompleted.createdAt!,
                  splitStartedCompleted.endedAt,
                  splitStartedCompleted.splitId!,
                  splitStartedCompleted.ended!,
                  0,
                );
              }
            }

            if (sqfliteBodyMeasurementsList.isEmpty) {
              for (var measurement in supabaseBodyMeasurementsList) {
                dbFitness.TxninsertMeasurements(txn, measurement, 0);
              }
            }

            if (sqfliteIntakeCategoriesList.isEmpty) {
              for (var intakeCategory in supabaseIntakeCategoriesList) {
                dbFitness.TxninsertIntakeCategory(txn, intakeCategory.name!, 0, intakeCategory.idIntakeCategory!);
              }
            }

            if (sqfliteNutriIntakeList.isEmpty) {
              for (var nutriIntake in supabaseNutriIntakeList) {
                try {
                  sqfliteNutriIntakeList.add(nutriIntake);
                  dbFitness.TxnInsertNutriIntake(txn, nutriIntake, nutriIntake.idNutriIntake!, 0);
                } on Exception catch (e) {
                  print("nastala chyba při insert nutri intake: $e");
                }
              }
            }
            if (sqfliteUser == null) {
              dbFitness.TxnInsertUser(txn, supabaseUser, 0);
            }
          });

          if (sqfliteFoodList.isEmpty) {
            Set<int> foodIds = sqfliteNutriIntakeList.map((e) => e.idFood!).toSet();
            List<Food?> foodList = await dbSupabase.selectSpecificFoods(foodIds);
            for (var food in foodList) {
              dbFitness.InsertOrUpdateFood(food!, 0);
            }
          }
          loading = false;
        }
      } else {
        loading = false;

        await Future.delayed(Duration(seconds: 1));
      }

      // Nastavení stavu na false po dokončení načítání
    } else {
      loading = false;
      if (user == null) {
        user = (await dbFitness.SelectUser())!;
        selectedCountry = user!.country;
      }
    }
    // loading = false;
    setState(() {});
  }

  //! tutorial
  loadTutorial() async {
    // createTutorial();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tutorialShow = await prefs.getString("show_tutorial");
    if (tutorialShow == "true") {
      showTutorial();
      print("show tutorial");
      await prefs.setString("show_tutorial", "false");
    } else {
      return;
    }
  }

  late TutorialCoachMark tutorialCoachMark;
  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void bigSwitch(String target) {
    switch (target) {
      case "Target 0":
        // Akce pro Target 0
        print("This is Target 0");
        setState(() {
          pageProvider = 0;
          controller.jumpToPage(0);
        });
        break;
      case "Target 1":
        // Akce pro Target 1
        print("This is Target 1");
        break;
      case "Target 2":
        // Akce pro Target 2
        print("This is Target 2");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SplitPageCopy(
              notifyParent: () {},
              loadParent: () {},
              clickedSplitTab: 0,
              foundActiveSplit: false,
            ),
          ),
        );
        break;
      case "Target 3":
        // Akce pro Target 3
        print("This is Target 3");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: AddSplitBoxCopy(
                loadParent: () {},
                splits: [],
              ),
            );
          },
        );
        break;
      case "Target 4":
        // Akce pro Target 4
        print("This is Target 4");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: NewMuscleBoxCopy(
                loadParent: () {},
                notifyParent: () {},
                muscles: [],
              ),
            );
          },
        );
        break;
      case "Target 5":
        // Akce pro Target 5
        print("This is Target 5");
        Navigator.of(context).pop();
        break;
      case "Target 6":
        // Akce pro Target 6
        print("This is Target 6");
        break;
      case "Target 7":
        // Akce pro Target 7
        print("This is Target 7");
        break;
      case "Target 8":
        // Akce pro Target 8
        print("This is Target 8");
        Navigator.of(context).pop();
        break;
      case "Target 9":
        // Akce pro Target 9
        print("This is Target 9");
        break;
      case "Target 10":
        // Akce pro Target 10
        print("This is Target 10");
        Navigator.of(context).pop();
        break;
      case "Target 11":
        // Akce pro Target 11
        print("This is Target 11");
        break;
      case "Target 12":
        // Akce pro Target 12
        print("This is Target 12");
        break;
      case "Target 13":
        // Akce pro Target 13
        print("This is Target 13");
        setState(() {
          pageProvider = 2;
          controller.jumpToPage(2);
        });
        break;
      case "Target 14":
        // Akce pro Target 14
        print("This is Target 14");
        break;
      case "Target 15":
        // Akce pro Target 15
        print("This is Target 15");
        break;
      case "Target 16":
        // Akce pro Target 16
        print("This is Target 16");
        setState(() {
          pageProvider = 1;
          controller.jumpToPage(1);
        });
        break;
      case "Target 17":
        // Akce pro Target 17
        print("This is Target 17");
        break;
      default:
        print("Unknown Target");
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      pulseEnable: false,
      focusAnimationDuration: Duration(milliseconds: 200),
      onClickOverlay: (target) {
        bigSwitch(target.identify);
      },
      onClickTargetWithTapPosition: (p0, p1) {},
      onClickTarget: (target) {
        bigSwitch(target.identify);
      },
      unFocusAnimationDuration: Duration(milliseconds: 400),
      // useSafeArea: true,
      colorShadow: Color.fromRGBO(255, 145, 0, 0.575),
      hideSkip: true, paddingFocus: 0, useSafeArea: true,
      // textSkip: "Next",
      // paddingFocus: 10,
      // opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 0",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyBottomNavigation2,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.top,
            builder: (context, _controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Tady uvidíš své dnešní hodnoty z jídla, cvičení i měření těla",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyBottomNavigation1,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fitness".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Až si v následujících krocích vytvoříš svůj první trénink, tak zde do něj budeš vkládat hodnoty",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyEditWorkouts,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Fitness".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Tady si vytvoříš své tréninky (splity)",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyNewSplit,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Fitness".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Tady si vytvoříš svůj první trénink",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 4",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyNewMuscle,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "new_muscle".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Tady si vytvoříš svoje svaly, které chceš cvičit",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 5",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyNewMuscleEditingController,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "new_muscle".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Zadej název svalu",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 6",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyNameOfWorkout,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "workout_name".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Zadej název tréninku (splitu)",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 7",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyIsCheckedMuscles,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Vyber cviky pro trénink",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Vyber které svaly chceš v svém tréniku (splitu) cvičit",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 8",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keySaveSplit,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Následně tvůj trénink (split) ulož",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 9",
        radius: 0, // Radius zůstane nulový
        paddingFocus: 0, // Žádné odsazení
        enableTargetTab: true, enableOverlayTab: true, keyTarget: keyDummy, // Nezadáváme enableTargetTab: false,enableOverlayTab: false,keyTarget, protože nechceme zaměřit žádný konkrétní prvek
        contents: [
          TargetContent(
            // align: ContentAlign.bottom, // Pozice obsahu, můžeš změnit podle potřeby
            builder: (context, controller) {
              return Center(
                child: Container(
                  // Overlay je vytvořen pomocí knihovny, zde pouze obsah
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        "Přidání nových cviků", // Překlad textu
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Bílá barva, aby vynikl na tmavém pozadí
                          fontSize: 25.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Až si vytvoříš spllit tak si vytvoř cviky které chceš cvičit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_split.png',
                        height: 150,
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Zadej název cviku  \nPokud cvik nepatří do daného svalu tak změň kategorii \na klikni uložit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_new_exercise.png',
                        height: 150,
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Vyber si cviky které chceš cvičit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_check_exercises.png',
                        height: 150,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 10",
        radius: 0,
        paddingFocus: 0,
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keySplitPageBack,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Jdi zpátky na hlavní obrazovky",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 11",
        radius: 0, // Radius zůstane nulový
        paddingFocus: 0, // Žádné odsazení
        enableTargetTab: true, enableOverlayTab: true, keyTarget: keyDummy1, // Nezadáváme enableTargetTab: false,enableOverlayTab: false,keyTarget, protože nechceme zaměřit žádný konkrétní prvek
        contents: [
          TargetContent(
            // align: ContentAlign.bottom, // Pozice obsahu, můžeš změnit podle potřeby
            builder: (context, controller) {
              return Center(
                child: Container(
                  // Overlay je vytvořen pomocí knihovny, zde pouze obsah
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 180),
                      Text(
                        "Jak začít trénink?", // Překlad textu
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Bílá barva, aby vynikl na tmavém pozadí
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_tap_exercise.png',
                        height: 300,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Klikni na jeden box",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 12",
        radius: 0, // Radius zůstane nulový
        paddingFocus: 0, // Žádné odsazení
        enableTargetTab: true, enableOverlayTab: true, keyTarget: keyDummy1, // Nezadáváme enableTargetTab: false,enableOverlayTab: false,keyTarget, protože nechceme zaměřit žádný konkrétní prvek
        contents: [
          TargetContent(
            // align: ContentAlign.bottom, // Pozice obsahu, můžeš změnit podle potřeby
            builder: (context, controller) {
              return Center(
                child: Container(
                  // Overlay je vytvořen pomocí knihovny, zde pouze obsah
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 120),
                      Text(
                        "Jak začít trénink", // Překlad textu
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Bílá barva, aby vynikl na tmavém pozadí
                          fontSize: 25.0,
                        ),
                      ),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_add_new_value_exercise.png',
                        height: 150,
                      ),
                      Text(
                        softWrap: true,
                        "Trénink začneš tím, že přidáš jeden řádek pro zápis hodnot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Začal jsi trénink", // Překlad textu
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Bílá barva, aby vynikl na tmavém pozadí
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 15),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_new_value_exercise.png',
                        height: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          // softWrap: true,
                          "Zadej odcvičené hodnoty a zvol obtížnost série",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          softWrap: true,
                          "Hodnoty nemusíš manuálně ukládat, ukládají se automaticky",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          softWrap: true,
                          "(Dej pozor, když řádek následně posunutím doleva vymažeš, tak se trénink nezruší!!!)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 13",
        radius: 0, // Radius zůstane nulový
        paddingFocus: 0, // Žádné odsazení
        enableTargetTab: true, enableOverlayTab: true, keyTarget: keyDummy1, // Nezadáváme enableTargetTab: false,enableOverlayTab: false,keyTarget, protože nechceme zaměřit žádný konkrétní prvek
        contents: [
          TargetContent(
            // align: ContentAlign.bottom, // Pozice obsahu, můžeš změnit podle potřeby
            builder: (context, _controller) {
              return Center(
                child: Container(
                  // Overlay je vytvořen pomocí knihovny, zde pouze obsah
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 180),
                      Text(
                        softWrap: true,
                        "Chceš se podívat jak se ti vedlo minulé tréninky?", // Překlad textu
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Bílá barva, aby vynikl na tmavém pozadí
                          fontSize: 25.0,
                        ),
                      ),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_swipe_up_exercise.png',
                        height: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          softWrap: true,
                          "Pokud jsi v minulosti odcvičil tento sval a zadal hodnoty, po posunutí nahoru uvidíš své minulé hodnoty pro daný cvik",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/Tutorial pictures/tutorial_historical_exercise.png',
                        height: 250,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 14",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyBottomNavigation3,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Food".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Zde můžeš zadávat jídla, které jsi snědl",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 15",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyDummy2,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "Vyhledávání potravin",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Potraviny můžeš hledat těmito dvěma způsoby:",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Image.asset(
                      'assets/Tutorial pictures/tutorial_search_bar.png',
                      height: 70,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "nebo kliknutím na plus tlačítko",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Image.asset(
                      'assets/Tutorial pictures/tutorial_add_button_food.png',
                      height: 65,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Otevře se ti nabídka potravin",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Image.asset(
                      'assets/Tutorial pictures/tutorial_search_items.png',
                      height: 200,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Vybereš si potravinu a v dalším kroku zadáš gramáž a klikneš přidat",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 16",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyNewFood,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.bottom,
            builder: (context, _controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "Přidání nové potraviny",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Pokud nenajdeš potravinu, tak si ji můžeš vytvořit",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 17",
        enableTargetTab: true,
        enableOverlayTab: true,
        keyTarget: keyMeasurementButton,
        contents: [
          TargetContent(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // customPosition: CustomTargetContentPosition(top: 500, left: 0),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                // color: Colors.blue,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Text(
                      "Změř si své tělesné hodnoty",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    loadDataFromSupabase();
    loadTutorial();
    // loading == false;
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    // dbSupabase.getUser();
    if (loading == true) {
      return Scaffold(
        backgroundColor: ColorsProvider.getColor2(context),
        body: iconPage == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gym_google2.png',
                        height: 300,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        height: 70,
                        child: Text(
                          "Welcome",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.getColor8(context)),
                        ),
                      ),
                      // LoadingAnimationWidget.staggeredDotsWave(
                      //   color: ColorsProvider.getColor8(context),
                      //   size: 100,
                      // ),
                      SizedBox(
                        height: 110,
                      ),
                      // Text(
                      //   "Loading data",
                      //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.getColor8(context)),
                      // ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gym_google2.png',
                        height: 300,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: ColorsProvider.getColor8(context),
                        size: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        child: Text(
                          "Loading data",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.getColor8(context)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey, drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          backgroundColor: ColorsProvider.getColor2(context),
          width: MediaQuery.of(context).size.width / 1.50,
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15),
                    //   child: Container(
                    //     height: 45,
                    //     width: 45,
                    //     decoration: BoxDecoration(
                    //       color: ColorsProvider.color_3,
                    //       borderRadius: BorderRadius.circular(50),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user != null ? user!.name : "null"}",
                          style: TextStyle(
                            color: ColorsProvider.getColor8(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 50),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _categoryWidget('Food'.tr()),
              ),
              _buttonWidget(dbSupabase, context, '/scanFood', 'scan_food'.tr(), Icons.fit_screen_rounded, false),
              _buttonWidget(dbSupabase, context, '/newFood', 'new_food'.tr(), Icons.add_circle_outline_outlined, true),
              _buttonWidget(dbSupabase, context, '/foodStatistic', 'statistic'.tr(), Icons.bar_chart_rounded, true),
              _categoryWidget('workout'.tr()),
              // _buttonWidget(dbSupabase, context, '/fitnessNames', 'Manage fitness names', Icons.text_fields_rounded),
              // _buttonWidget(dbSupabase, context, '/editDeleteExerciseData', 'Edit/Delete exercise data', Icons.edit_rounded),
              _buttonWidget(dbSupabase, context, '/fitnessStatistic', 'statistic'.tr(), Icons.insights_rounded, true),
              _categoryWidget('body'.tr()),
              _buttonWidget(dbSupabase, context, '/measurements', 'measurement'.tr(), Icons.straighten_outlined, true),
              Spacer(),
              _buttonWidget(dbSupabase, context, '/settings', 'settings'.tr(), Icons.settings_outlined, true, paddingLeft: 0),
              SizedBox(height: 10),
            ],
          ),
        ),
        // appBar: AppBar(
        //   title: Text('Your App Title'),
        // ),
        body: Stack(
          children: [
            PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  pageProvider = index;
                  if (index != 0) {
                    // Adjust the index if needed
                  }
                });
              },
              children: [
                // switchButton == true ?
                //  FitnessRecordScreen() :
                FitnessRecordScreenCopy(),
                HomeScreen(),
                FoodRecordScreen(),
              ],
            ),
            Positioned(
              top: 40,
              left: 5,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu_rounded,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          elevation: 0,
          height: 65,
          onDestinationSelected: (index) {
            setState(() {
              pageProvider = index;
              controller.jumpToPage(pageProvider);
            });
          },
          indicatorColor: ColorsProvider.getColor2(context),
          selectedIndex: pageProvider,
          animationDuration: const Duration(milliseconds: 1000),
          destinations: [
            _navigation(null, null, "Fitness".tr(), keyBottomNavigation1),
            _navigation(Icons.home, Icons.home_outlined, "Home".tr(), keyBottomNavigation2),
            _navigation(Icons.fastfood_rounded, Icons.fastfood, "Food".tr(), keyBottomNavigation3),
          ],
        ),
      );
    }
  }

  Widget _categoryWidget(String category) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        height: 35,
        color: Color.fromARGB(50, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$category",
              style: TextStyle(
                color: ColorsProvider.getColor8(context),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigation(IconData? primaryIconData, IconData? secondaryIconDaty, String name, Key key) {
    return NavigationDestination(
      key: key,
      selectedIcon: primaryIconData != null
          ? Icon(
              primaryIconData,
              color: ColorsProvider.getColor8(context),
            )
          : Image.asset(
              'assets/icons/icon_half_bodybuilder.png', // Cesta k vašemu obrázku
              // width: 24,
              height: 32,
              color: ColorsProvider.getColor8(context), // Volitelně můžete nastavit barvu obrázku
            ),
      icon: secondaryIconDaty != null
          ? Icon(
              secondaryIconDaty,
              color: ColorsProvider.getColor2(context),
            )
          : Image.asset(
              'assets/icons/icon_half_bodybuilder.png', // Cesta k vašemu obrázku
              // width: 25,
              height: 32,
              color: ColorsProvider.getColor2(context),
            ),
      label: '$name',
    );
  }

  Widget _buttonWidget(SupabaseProvider dbSupabase, BuildContext context, String page, String name, IconData icon, bool show, {double paddingLeft = 20}) {
    return GestureDetector(
      onTap: () {
        if (show == false) {
        } else {
          dbSupabase.getUser();
          Navigator.pushNamed(context, page);
        }
      },
      child: Container(
        height: 65,
        color: ColorsProvider.getColor2(context),
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft),
          child: Row(
            mainAxisAlignment: page == '/settings' ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: show == true ? ColorsProvider.getColor8(context) : ColorsProvider.getColor8(context).withAlpha(100),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '$name',
                style: TextStyle(
                  fontSize: 18,
                  color: show == true ? ColorsProvider.getColor8(context) : ColorsProvider.getColor8(context).withAlpha(100),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
