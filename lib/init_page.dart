// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page%20copy.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/settings.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 1);
  var pageProvider = 1;

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
      ]);

      List<Muscle> sqfliteMuscleList = result[0];
      List<Exercise> sqfliteExerciseList = result[1];
      List<ExerciseData> sqfliteExerciseDataList = result[2];
      List<MySplit> sqfliteSplitList = result[3];
      List<SelectedMuscle> sqfliteSelectedMuscleList = result[4];
      List<SelectedExercise> sqfliteSelectedExerciseList = result[5];
      List<SplitStartedCompleted> sqfliteSplitStartedCompletedList = result[6];
      List<Measurements> sqfliteBodyMeasurementsList = result[7];

      if (sqfliteMuscleList.isEmpty || sqfliteExerciseList.isEmpty || sqfliteExerciseDataList.isEmpty || sqfliteSplitList.isEmpty || sqfliteSelectedMuscleList.isEmpty || sqfliteSelectedExerciseList.isEmpty || sqfliteSplitStartedCompletedList.isEmpty || sqfliteBodyMeasurementsList.isEmpty) {
        if (iconPage) {
          iconPage = false;
        } else {
          // Načtení dat ze Supabase
          final MuscleLoading = dbSupabase.MuscleTable();
          final ExerciseLoading = dbSupabase.ExerciseTable();
          final ExerciseDataLoading = dbSupabase.ExerciseDataTable();
          final SplitLoading = dbSupabase.SplitTable();
          final SelectedMuscleLoading = dbSupabase.SelectedMuscleTable();
          final SelectedExerciseLoading = dbSupabase.SelectedExericseTable();
          final SplitStartedCompletedLoading = dbSupabase.SplitStartedCompletedTable();
          final DataMeasurementsLoading = dbSupabase.BodyMeasurementsTable();
          supabaseMuscleList = await MuscleLoading;
          supabaseExerciseList = await ExerciseLoading;
          supabaseExerciseDataList = await ExerciseDataLoading;
          supabaseSplitList = await SplitLoading;
          supabaseSelectedMuscleList = await SelectedMuscleLoading;
          supabaseSelectedExerciseList = await SelectedExerciseLoading;
          supabaseSplitStartedCompletedList = await SplitStartedCompletedLoading;
          supabaseBodyMeasurementsList = await DataMeasurementsLoading;

          // Vložení dat ze Supabase do Sqflite
          if (sqfliteMuscleList.isEmpty) {
            for (var muscle in supabaseMuscleList) {
              await dbFitness.InsertMuscle(muscle.idMuscle!, muscle.nameOfMuscle!, 0);
            }
          }

          if (sqfliteExerciseList.isEmpty) {
            for (var exercise in supabaseExerciseList) {
              await dbFitness.InsertExercise(exercise.idExercise!, exercise.nameOfExercise!, exercise.musclesIdMuscle!, 0);
            }
          }

          if (sqfliteExerciseDataList.isEmpty) {
            for (var exerciseData in supabaseExerciseDataList) {
              await dbFitness.InsertExerciseData(
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
              await dbFitness.InsertSplit(split.idSplit!, split.nameSplit, split.createdAt!, 0);
            }
          }

          if (sqfliteSelectedMuscleList.isEmpty) {
            for (var selectedMuscle in supabaseSelectedMuscleList) {
              await dbFitness.InsertSelectedMuscle(selectedMuscle.idSelectedMuscle!, selectedMuscle.splitIdSplit!, selectedMuscle.musclesIdMuscle!, 0);
            }
          }

          if (sqfliteSelectedExerciseList.isEmpty) {
            for (var selectedExercise in supabaseSelectedExerciseList) {
              await dbFitness.InsertSelectedExercise(selectedExercise.idSelectedExercise!, selectedExercise.idExercise!, selectedExercise.idSelectedMuscle!, 0);
            }
          }

          if (sqfliteSplitStartedCompletedList.isEmpty) {
            for (var splitStartedCompleted in supabaseSplitStartedCompletedList) {
              await dbFitness.InsertSplitStartedCompleted(
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
            for (var meacurement in supabaseBodyMeasurementsList) {
              await dbFitness.insertMeasurements(meacurement, 0);
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
    }
    // loading = false;
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    loadDataFromSupabase();
    // loading == false;
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    dbSupabase.getUser();
    if (loading == true) {
      return Scaffold(
        backgroundColor: ColorsProvider.color_2,
        body: iconPage == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gym.png',
                        height: 300,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        height: 70,
                        child: Text(
                          "Welcome",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.color_8),
                        ),
                      ),
                      // LoadingAnimationWidget.staggeredDotsWave(
                      //   color: ColorsProvider.color_8,
                      //   size: 100,
                      // ),
                      SizedBox(
                        height: 110,
                      ),
                      // Text(
                      //   "Loading data",
                      //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.color_8),
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
                        'assets/gym.png',
                        height: 300,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: ColorsProvider.color_8,
                        size: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        child: Text(
                          "Loading data",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: ColorsProvider.color_8),
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
          backgroundColor: ColorsProvider.color_2,
          width: MediaQuery.of(context).size.width / 1.50,
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: ColorsProvider.color_3,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${dbSupabase.name}",
                          style: TextStyle(
                            color: ColorsProvider.color_8,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 50),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _categoryWidget('Food'),
              ),
              _buttonWidget(dbSupabase, context, '/scanFood', 'Scan food', Icons.fit_screen_rounded, false),
              _buttonWidget(dbSupabase, context, '/newFood', 'New food', Icons.add_circle_outline_outlined, true),
              _buttonWidget(dbSupabase, context, '/foodStatistic', 'Statistic', Icons.bar_chart_rounded, false),
              _categoryWidget('Workout'),
              // _buttonWidget(dbSupabase, context, '/fitnessNames', 'Manage fitness names', Icons.text_fields_rounded),
              // _buttonWidget(dbSupabase, context, '/editDeleteExerciseData', 'Edit/Delete exercise data', Icons.edit_rounded),
              _buttonWidget(dbSupabase, context, '/fitnessStatistic', 'Statistic', Icons.insights_rounded, true),
              _categoryWidget('Body'),
              _buttonWidget(dbSupabase, context, '/measurements', 'Measurements', Icons.straighten_outlined, true),
              Spacer(),
              _buttonWidget(dbSupabase, context, '/settings', 'Settings', Icons.settings_outlined, true, paddingLeft: 0),
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
                });
              },
              children: [
                switchButton == true ? FitnessRecordScreen() : FitnessRecordScreenCopy(),
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
          indicatorColor: ColorsProvider.color_2,
          selectedIndex: pageProvider,
          animationDuration: const Duration(milliseconds: 1000),
          destinations: [
            _navigation(null, null, "Fitness"),
            _navigation(Icons.home, Icons.home_outlined, "Home"),
            _navigation(Icons.fastfood_rounded, Icons.fastfood, "Food"),
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
                color: ColorsProvider.color_8,
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
              color: ColorsProvider.color_8,
            )
          : Image.asset(
              'assets/icons/icon_half_bodybuilder.png', // Cesta k vašemu obrázku
              // width: 24,
              height: 32,
              color: ColorsProvider.color_8, // Volitelně můžete nastavit barvu obrázku
            ),
      icon: secondaryIconDaty != null
          ? Icon(
              secondaryIconDaty,
              color: Colors.white.withAlpha(170),
            )
          : Image.asset(
              'assets/icons/icon_half_bodybuilder.png', // Cesta k vašemu obrázku
              // width: 25,
              height: 32,
              color: Colors.white.withAlpha(170),
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
        color: ColorsProvider.color_2,
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft),
          child: Row(
            mainAxisAlignment: page == '/settings' ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: show == true ? ColorsProvider.color_8 : ColorsProvider.color_8.withAlpha(100),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '$name',
                style: TextStyle(
                  fontSize: 18,
                  color: show == true ? ColorsProvider.color_8 : ColorsProvider.color_8.withAlpha(100),
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
