import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);
    List<Muscle> data = data1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
            onPressed: () async {
              await _deleteCacheDir();
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
            ),
            ElevatedButton(
              onPressed: () async {
                // for (var i = 0; i < data.length; i++) {
                //   print(data[i].supabaseIdMuscle);
                // }
                await dbSupabase.SplitStartedCompletedTable();
                setState(() {});
              },
              child: Text("select databáze"),
            ),
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
