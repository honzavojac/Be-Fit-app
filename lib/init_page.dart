import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
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
  // FitnessRecordAppBar(),
  // HomeAppBar(),
  // FoodRecordAppBar(),
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
        drawer: Drawer(
          width: MediaQuery.of(context).size.width / 2,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  dbSupabase.getUser();
                  Navigator.pushNamed(context, '/settings'); // Použijte pushNamed pro navigaci
                },
                child: Container(
                  height: 50,
                  color: ColorsProvider.color_2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        // Icon(
                        //   Icons.settings,
                        //   color: ColorsProvider.color_1,
                        //   size: ,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
            // leading: Builder(
            //   builder: (context) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         IconButton(
            //           icon: const Icon(Icons.menu),
            //           onPressed: () {
            //             Scaffold.of(context).openDrawer();
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // ),
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
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.fitness_center_rounded,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.fitness_center_rounded,
              ),
              label: 'Fitness',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.fastfood_rounded,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.fastfood,
              ),
              label: 'Add food',
            ),
          ],
        ),
      ),
    );
  }
}
