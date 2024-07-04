import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_entry_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

final List<Widget> _appBars = [
  FitnessRecordAppBar(),
  HomeAppBar(),
  FoodRecordAppBar(),
];

final List<Widget> _pages = [
  FitnessRecordScreen(),
  HomeScreen(),
  FoodRecordScreen(),
];

class _InitPageState extends State<InitPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 1);
  var pageProvider = 1;

  // @override
  // void initState() {
  //   var dbSupabase = Provider.of<SupabaseProvider>(context);
  //   dbSupabase.initialize();
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
  }

  LoadSqflite() {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    // dbFitness.
  }

  bool loading = true;
  Future<void> loadDataFromSupabase() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    // Nastavíme proměnnou pro ukládání dat
    List<Muscle> muscleList = [];
    List<Exercise> exerciseList = [];
    List<ExerciseData> exerciseDataList = [];
    List<Split> splitList = [];
    List<SelectedMuscle> selectedMuscleList = [];
    List<SelectedExercise> selectedExeciseList = [];
    List<SplitStartedCompleted> splitStartedCompletedList = [];

    if (loading == true) {
      // Spustíme načítání dat
      final MuscleLoading = dbSupabase.MuscleTable();
      final ExerciseLoading = dbSupabase.ExerciseTable();
      final ExerciseDataLoading = dbSupabase.ExerciseDataTable();

      final SplitLoading = dbSupabase.SplitTable();
      final SelectedMuscleLoading = dbSupabase.SelectedMuscleTable();
      final SelectedExerciseLoading = dbSupabase.SelectedExericseTable();
      final SplitStartedCompletedLoading = dbSupabase.SplitStartedCompletedTable();

      //načtení supabase do sqflite

      await Future.delayed(Duration(seconds: 3), () async {
        muscleList = await MuscleLoading;
        exerciseList = await ExerciseLoading;
        exerciseDataList = await ExerciseDataLoading;
        splitList = await SplitLoading;
        selectedMuscleList = await SelectedMuscleLoading;
        selectedExeciseList = await SelectedExerciseLoading;
        splitStartedCompletedList = await SplitStartedCompletedLoading;
        if (muscleList.isNotEmpty) {
          for (var element in muscleList) {
            print(element.nameOfMuscle);
          }
        } else {
          print("Loading time exceeded 5 seconds");
        }
        // await Future.delayed(Duration(seconds: 10));
      });

      // Pokud data byla načtena dříve než timeout

      // Nastavíme loading na false a aktualizujeme stav
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    loadDataFromSupabase();
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    dbSupabase.getUser();
    if (loading == true) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Loading data",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
                ),
                // LoadingAnimationWidget.waveDots(color: Colors.white, size: 20)
              ],
            ),
            SizedBox(
              height: 50,
            ),
            // LoadingAnimationWidget.discreteCircle(
            //   secondRingColor: ColorsProvider.color_2,
            //   thirdRingColor: Colors.transparent,
            //   color: ColorsProvider.color_2,
            //   size: 100,
            // ),
            // LoadingAnimationWidget.stretchedDots(
            //   color: ColorsProvider.color_2,
            //   size: 100,
            // ),
            // LoadingAnimationWidget.inkDrop(
            //   color: ColorsProvider.color_2,
            //   size: 100,
            // ),
            Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
              color: ColorsProvider.color_2,
              size: 100,
            )),
          ],
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<fitnessGlobalVariables>(
            create: (_) => fitnessGlobalVariables(),
          ),
        ],
        child: Scaffold(
          drawer: Drawer(
            backgroundColor: ColorsProvider.color_2,
            width: MediaQuery.of(context).size.width / 1.50,
            child: Column(
              children: [
                Container(
                  height: 50,
                ),
                Container(
                  height: 50,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(
                        width: 8,
                      ),
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
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                _categoryWidget('Food'),
                _buttonWidget(dbSupabase, context, '/scanFood', 'Scan food', Icons.fit_screen_rounded),
                _buttonWidget(dbSupabase, context, '/addFood', 'Add food', Icons.search_rounded),
                _buttonWidget(dbSupabase, context, '/newFood', 'New food', Icons.add_circle_outline_outlined),
                _buttonWidget(dbSupabase, context, '/foodStatistic', 'Statistic', Icons.bar_chart_rounded),
                _categoryWidget('Workout'),
                _buttonWidget(dbSupabase, context, '/fitnessNames', 'Manage fitness names', Icons.text_fields_rounded),
                _buttonWidget(dbSupabase, context, '/editDeleteExerciseData', 'Edit/Delete exercise data', Icons.edit_rounded),
                _buttonWidget(dbSupabase, context, '/fitnessStatistic', 'Statistic', Icons.insights_rounded),
                Spacer(),
                _buttonWidget(dbSupabase, context, '/settings', 'Settings', Icons.settings_outlined, paddingLeft: 0),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: _appBars[pageProvider],
          ),
          body: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                pageProvider = index;
              });
            },
            children: _pages,
          ),
          key: scaffoldKey,
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
        ),
      );
    }
  }

  Widget _categoryWidget(String category) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
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

  Widget _buttonWidget(SupabaseProvider dbSupabase, BuildContext context, String page, String name, IconData icon, {double paddingLeft = 20}) {
    return GestureDetector(
      onTap: () {
        dbSupabase.getUser();
        Navigator.pushNamed(context, page);
      },
      child: Container(
        height: 55,
        color: ColorsProvider.color_2,
        child: Padding(
          padding: EdgeInsets.only(left: paddingLeft),
          child: Row(
            mainAxisAlignment: page == '/settings' ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: ColorsProvider.color_8,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '$name',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorsProvider.color_8,
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
