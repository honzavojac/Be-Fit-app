// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page%20copy.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

UserSupabase? user;
var controller = PageController(initialPage: 1);
var pageProvider = 1;

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
          // if (sqfliteFoodList.isEmpty) {
          //   List<Food>? foodList = [];
          //   for (var nutriIntake in sqfliteNutriIntakeList) {
          //     Food? food = await dbSupabase.SelectSpecificFood(nutriIntake.idFood!);
          //     print(food!.name);
          //     foodList.add(food!);
          //   }
          //   for (var food in foodList) {

          //     await dbFitness.InsertOrUpdateFood(food, 0);
          //   }
          // }
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    loadDataFromSupabase();
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
      // print("hhhhhhhhhhhhhhhhhhhhhhhh${switchButton}hhhhhhhhhhhhhhhhhhhhhhhhhhh");
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
                      print("object");
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
            _navigation(null, null, "Fitness".tr()),
            _navigation(Icons.home, Icons.home_outlined, "Home".tr()),
            _navigation(Icons.fastfood_rounded, Icons.fastfood, "Food".tr()),
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

  Widget _navigation(IconData? primaryIconData, IconData? secondaryIconDaty, String name) {
    return NavigationDestination(
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
