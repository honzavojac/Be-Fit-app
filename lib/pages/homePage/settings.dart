

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
      var dbFirebase = Provider.of<FirestoreService>(context);

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
      body: Center(
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

                final name = snapshot.data!;
                return Text("sign in as ${name} with email ${user.email}");
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
