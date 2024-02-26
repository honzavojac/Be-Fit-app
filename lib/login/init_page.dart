import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/page_provider.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_global_variables.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_entry_page.dart';
import 'package:kaloricke_tabulky_02/pages/homePage/home_page.dart';
import 'package:provider/provider.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

final List<Widget> _appBars = [
  const FitnessRecordAppBar(),
  const HomeAppBar(),
  const FoodRecordAppBar(),
];

final List<Widget> _pages = [
  const FitnessRecordScreen(),
  HomeScreen(),
  const FoodRecordScreen(),
];

class _InitPageState extends State<InitPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<PageProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<fitnessGlobalVariables>(
          create: (_) => fitnessGlobalVariables(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: _appBars[pageProvider.page],
          ),
          body: PageView(
            controller: controller,
            onPageChanged: (index) {
              pageProvider.page = index;
              // Removed setState since it's not needed here
            },
            children: _pages,
          ),
          key: scaffoldKey,
          //bottomnavigationbar------------------------
          bottomNavigationBar: NavigationBar(
            height: 65,
            onDestinationSelected: (index) {
              pageProvider.page = index;
              controller.jumpToPage(pageProvider.page);
              // Removed setState since it's not needed here
            },
            indicatorColor: Colors.amber[800],
            selectedIndex: pageProvider.page,
            animationDuration: Duration(milliseconds: 1000),
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
      ),
    );
  }
}
