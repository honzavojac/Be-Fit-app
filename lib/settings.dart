import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/fitness_record_page%20copy.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'variables.dart';
import 'data_classes.dart';

class Settings extends StatefulWidget {
  final Function(ThemeMode) notifyMyApp;
  const Settings({super.key, required this.notifyMyApp});

  @override
  State<Settings> createState() => _SettingsState();
}
//TODO: odstranit sqflite / supabase přepínač
// upravit select jazyků
// dát tam color picker ale nebude zatím viditelný
// dát tam změnu jména,( věku zatím ne ),
// udělat odstranění učtu!!!

//
//
// String? selectedCountry;

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  List<Muscle> data1 = [];

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> load() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    data1 = await dbFitness.SyncFromSupabase(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
      // dbSupabase.getUser();
      // _nameController.text = dbSupabase.user?.name ?? '';
      selectedCountry = user!.country;
      load();
    });
  }

  List<Muscle> data3 = [];
  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Deleting user data",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
                            ),
                            // LoadingAnimationWidget.waveDots(color: Colors.white, size: 20)
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                          color: ColorsProvider.color_2,
                          size: 100,
                        )),
                      ],
                    ),
                  );
                },
              );
              await _deleteCacheDir();

              await dbFitness.deleteAllData();
              user = null;
              dbSupabase.clearUserData();
              _signOut();
            },
            icon: Icon(
              Icons.logout,
              color: ColorsProvider.color_9,
              size: 25,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Container(
            //   height: 50,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Text("sqflite"),
            //       Switch(
            //         activeTrackColor: ColorsProvider.color_2, activeColor: Colors.black,
            //         // activeColor: ColorsProvider.color_2,
            //         inactiveTrackColor: ColorsProvider.color_8,
            //         value: dbFitness.switchButton,
            //         onChanged: (value) {
            //           dbFitness.switchButton = value;
            //           print(dbFitness.switchButton);
            //           // setState(() {});,
            //           Navigator.of(context).pushNamedAndRemoveUntil('/account', (Route<dynamic> route) => false);
            //         },
            //       ),
            //       Text("supabase"),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Change theme",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    // color: ColorsProvider.color_8,
                    border: Border.all(width: 2),
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Light"),
                      Switch(
                        activeTrackColor: ColorsProvider.color_2,
                        activeColor: Colors.black,
                        // activeColor: ColorsProvider.color_2,
                        inactiveTrackColor: ColorsProvider.color_8,
                        value: isDarkMode,
                        onChanged: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? themeModeString = prefs.getString('themeMode');
                          // print(themeModeString);
                          if (!isDarkMode) {
                            widget.notifyMyApp(ThemeMode.dark);
                            darkTheme = true;
                          } else {
                            widget.notifyMyApp(ThemeMode.light);
                            darkTheme = false;
                          }
                        },
                      ),
                      Text("Dark"),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              // width: 200,
              color: const Color.fromARGB(255, 1, 41, 73),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(
                  //     child: TextField(
                  //       controller: _nameController,
                  //     ),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     dbSupabase.updateName(_nameController.text.trim());
                  //     dbSupabase.user!.name = _nameController.text.trim();
                  //   },
                  //   child: Text("save your name"),
                  // )
                ],
              ),
            ),
            Text(darkTheme.toString()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: 55,
                      decoration: BoxDecoration(
                        // color: Colors.grey[800],
                        border: Border.all(color: ColorsProvider.color_8, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedCountry,
                          items: languages.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(
                                country['name']!,
                                style: TextStyle(color: ColorsProvider.color_2),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedCountry = value;
                            setState(() {});
                          },
                          buttonStyleData: ButtonStyleData(
                            // width: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(18),
                            //   border: Border.all(
                            //     color: ColorsProvider.color_8,
                            //     width: 0.5,
                            //   ),
                            // ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            iconSize: 17,
                            iconEnabledColor: ColorsProvider.color_2,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(width: 2, color: ColorsProvider.color_8),
                            ),
                            offset: const Offset(0, -0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              interactive: true,
                              thickness: WidgetStateProperty.all(6),
                              thumbVisibility: WidgetStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            // height: 40,
                            padding: EdgeInsets.only(left: 10, right: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: HelpButton(
                      helpText: "This button allows you to change the language of the app. "
                          "Upon changing the language, the app will automatically adjust "
                          "the database category to match the selected language.",
                    ),
                  ),
                ],
              ),
            ),
            // TextField(
            //   // enabled: false,
            //   // readOnly: true,
            //   controller: textEditingController,
            // ),
            // TextField(
            //   // enabled: false,
            //   readOnly: true,
            //   controller: textEditingController,
            // ),
            Container(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () async {},
              child: Text("select databáze"),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                Stopwatch stopwatch = Stopwatch()..start();
                await dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
                stopwatch.stop();
                // print("SaveToSupabaseAndOrderSqlite trvalo: ${stopwatch.elapsedMilliseconds} ms");
              },
              child: Text("save to supabase"),
            ),
            SizedBox(
              height: 90,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     data3 = await dbFitness.SelectAllMuscleAndExercises();

            //     setState(() {});
            //   },
            //   child: Text("select databáze"),
            // ),
            // SizedBox(
            //   height: 80,
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await dbFitness.SelectAllData();
            //     setState(() {});
            //   },
            //   child: Text("select 2 databáze"),
            // ),
            // SizedBox(
            //   height: 80,
            // ),

            // ElevatedButton(
            //   onPressed: () async {
            //     await dbFitness.DeleteAllSplitStartedCompleteds();
            //     setState(() {});
            //   },
            //   child: Text("delete all splitStartedCompleted"),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await dbFitness.DeleteAllExerciseDatas();
            //     setState(() {});
            //   },
            //   child: Text("delete all exerciseData"),
            // ),
            SizedBox(
              height: 40,
            ),
            // Expanded(
            //   child: data3.isNotEmpty
            //       ? Container(
            //           color: Colors.brown,
            //           child: SingleChildScrollView(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: data3.map((muscle) {
            //                 return Container(
            //                   color: Colors.blue,
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(muscle.nameOfMuscle!),
            //                       Column(
            //                         children: muscle.exercises!.map((exercise) {
            //                           return Container(
            //                             color: ColorsProvider.color_2,
            //                             child: Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 Text(exercise.nameOfExercise ?? ""),
            //                                 Column(
            //                                   children: exercise.exerciseData!.map((exerciseData) {
            //                                     return Container(
            //                                       height: 30, width: 500,
            //                                       color: Colors.black,
            //                                       // margin: const EdgeInsets.only(top: 4.0),
            //                                       child: Text(
            //                                         'Weight: ${exerciseData.weight}, '
            //                                         'Reps: ${exerciseData.reps}, '
            //                                         'Difficulty: ${exerciseData.difficulty}',
            //                                         style: TextStyle(color: Colors.white),
            //                                       ),
            //                                     );
            //                                   }).toList(),
            //                                 ),
            //                               ],
            //                             ),
            //                           );
            //                         }).toList(),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               }).toList(),
            //             ),
            //           ),
            //         )
            //       : Container(
            //           color: Colors.amber,
            //         ),
            // )

            // ElevatedButton(
            //   onPressed: () async {
            //     await dbFitness.InsertSplitStartedCompleted(null, null, null, 86, true, 1);
            //     List<SplitStartedCompleted> splits = await dbFitness.SelectSplitStartedCompleted();
            //     for (var element in splits) {
            //       element.printSplitStartedCompleted();
            //     }

            //     setState(() {});
            //   },
            //   child: Text("add item"),
            // ),
            // SizedBox(
            //   height: 40,
            // ),

            // ElevatedButton(
            //   onPressed: () async {
            //     List<SplitStartedCompleted> splits = await dbFitness.SelectSplitStartedCompleted();
            //     for (var element in splits) {
            //       await dbFitness.SyncSqfliteToSupabase(dbSupabase, "split_started_completed", element, element.action!);
            //     }
            //     List<SplitStartedCompleted> a = await dbSupabase.SplitStartedCompletedTable();
            //     for (var element in a) {
            //       element.printSplitStartedCompleted();
            //     }
            //     setState(() {});
            //   },
            //   child: Text("to supabase"),
            // ),
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () async {
            //         await dbFitness.SyncFromSupabase(context);
            //         await load();
            //       },
            //       child: Text("sync databáze"),
            //     ),
            //     ElevatedButton(
            //       onPressed: () async {
            //         List<Muscle> musclesDelete = await dbFitness.SelectMuscles();
            //         for (var element in musclesDelete) {
            //           element.action = 3;
            //           await dbFitness.DeleteAction(3, element.idMuscle!);
            //         }

            //         // await load();
            //       },
            //       child: Text("delete all"),
            //     ),
            //     ElevatedButton(
            //       onPressed: () async {
            //         await dbFitness.InsertMuscle("biceps2");
            //         await load();
            //       },
            //       child: Text("add item"),
            //     ),
            //   ],
            // ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: data.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           color: Colors.brown,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             children: [
            //               Text("id: ${data[index].idMuscle} "),
            //               SizedBox(
            //                 width: 30,
            //               ),
            //               Expanded(
            //                 child: Text("name: ${data[index].nameOfMuscle}"),
            //               ),
            //               Text("supabaseId: ${data[index].supabaseIdMuscle}"),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class HelpButton extends StatefulWidget {
  final String helpText;
  const HelpButton({Key? key, required this.helpText}) : super(key: key);

  @override
  _HelpButtonState createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton> {
  OverlayEntry? _overlayEntry;

  void _showHelpOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _removeHelpOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy - size.height - 60.0, // Text se zobrazí nad ikonou
        left: offset.dx - 220, // Text se zobrazí vlevo od ikony
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.helpText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showHelpOverlay(context),
      onLongPressUp: _removeHelpOverlay,
      child: Icon(
        Icons.help_outline,
        color: Colors.white.withAlpha(100),
        size: 28,
      ),
    );
  }
}
