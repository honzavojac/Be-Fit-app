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
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_classes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

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
      var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
      dbSupabase.getUser();
      _nameController.text = dbSupabase.user?.name ?? '';
      load();
    });
  }

  String? _selectedCountry;
  final List<Map<String, String>> _countries = [
    {'code': 'CZ', 'name': 'Czech Republic'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'HU', 'name': 'Hungary'},
    {'code': 'IT', 'name': 'Italy'},
    {'code': 'PL', 'name': 'Poland'},
    {'code': 'UA', 'name': 'Ukraine'},
    {'code': 'US', 'name': 'United States'},
    {'code': 'EN', 'name': 'United Kingdom'}
  ];

  List<Muscle> data3 = [];
  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);

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
                },
              );
              await _deleteCacheDir();

              await dbFitness.deleteAllData();
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
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("sqflite"),
                  Switch(
                    activeTrackColor: ColorsProvider.color_2, activeColor: Colors.black,
                    // activeColor: ColorsProvider.color_2,
                    inactiveTrackColor: ColorsProvider.color_8,
                    value: dbFitness.switchButton,
                    onChanged: (value) {
                      dbFitness.switchButton = value;
                      print(dbFitness.switchButton);
                      // setState(() {});,
                      Navigator.of(context).pushNamedAndRemoveUntil('/account', (Route<dynamic> route) => false);
                    },
                  ),
                  Text("supabase"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              color: const Color.fromARGB(255, 1, 41, 73),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextField(
                        controller: _nameController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dbSupabase.updateName(_nameController.text.trim());
                      dbSupabase.user!.name = _nameController.text.trim();
                    },
                    child: Text("save your name"),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
              child: DropdownButton<String>(
                value: _selectedCountry,
                hint: Text('Select Country'),
                items: _countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Text(country['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                  // Můžete zde přidat další logiku, například uložit vybranou zemi do databáze nebo změnit jazyk aplikace
                  print('Selected Country Code: $_selectedCountry');
                },
                isExpanded: true,
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
              onPressed: () async {
                await dbFitness.SelectAllData();
              },
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
