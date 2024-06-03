import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
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
  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
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

  @override
  void dispose() {
    super.dispose();
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

  void printNavigationStack(BuildContext context) {
    print('Navigation stack:');
    Navigator.popUntil(context, (route) {
      print(route.settings);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var _nameController = TextEditingController();
    dbSupabase.getUser();
    _nameController.text = dbSupabase.user!.name;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
            onPressed: () async {
              _signOut();
              await _deleteCacheDir();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
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
                      // setState(() {});
                    },
                    child: Text("save your name"),
                  )
                ],
              ),
            ),
            Container(
              height: 100,
            ),
            Container(
              height: 150,
              // color: const Color.fromARGB(255, 1, 41, 73),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // printNavigationStack(context);
                      // dbSupabase.getUser();
                      dbSupabase.getTodayFitness();
                      // setState(() {});
                    },
                    child: Text("uživatel ${dbSupabase.user!.email}"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
