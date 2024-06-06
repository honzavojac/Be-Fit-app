import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_entry_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';

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
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    dbSupabase.getUser();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<fitnessGlobalVariables>(
          create: (_) => fitnessGlobalVariables(),
        ),
      ],
      child: Scaffold(
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
          height: 65,
          onDestinationSelected: (index) {
            setState(() {
              pageProvider = index;
              controller.jumpToPage(pageProvider);
            });
          },
          indicatorColor: Colors.amber[800],
          selectedIndex: pageProvider,
          animationDuration: const Duration(milliseconds: 1000),
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.fitness_center_rounded,
                color: Colors.black,
              ),
              icon: Icon(Icons.fitness_center_rounded),
              label: 'Fitness',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.fastfood_rounded,
                color: Colors.black,
              ),
              icon: Icon(Icons.fastfood),
              label: 'Add food',
            ),
          ],
        ),
      ),
    );
  }
}
