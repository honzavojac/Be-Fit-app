import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  var idk;
  @override
  void dispose() {
    idk = FirestoreService().getUsername();
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

  List<Person> person = [
    Person(id: 1, name: "honza"),
  ];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);
    var nameController = TextEditingController();
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    final _future = Supabase.instance.client.from('users').select();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
            onPressed: () async {
              await _deleteCacheDir();

              _firebaseAuth.signOut();
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
            FutureBuilder(
              future: dbFirebase.getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(),
                  );
                }

                final name = snapshot.data;

                if (name != null) {
                  return Text("Signed in as ${name.toString().toUpperCase()} with email ${user.email}");
                } else {
                  return Text("Signed in as ${"your name".toString().toUpperCase()} with email ${user.email}");
                }
              },
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
                        controller: nameController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dbFirebase.addUsername(nameController.text.trim());
                      setState(() {});
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
                    onPressed: () {
                      //  dbSupabase.createMuscle();
                      setState(() {});
                    },
                    child: Text("${person[0].id}"),
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
