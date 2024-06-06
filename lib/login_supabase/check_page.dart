import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:provider/provider.dart';

import 'auth_page.dart';
import '../init_page.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});
  void loadData(BuildContext context) async {
    var dbFirebase = Provider.of<FirestoreService>(context, listen: false);

    // Příklad: Získání aktuálně přihlášeného uživatele
    var currentUser = dbFirebase.auth.currentUser;
    if (currentUser != null) {
      print('Přihlášený uživatel: ${currentUser.email}');
    } else {
      print('Nikdo není přihlášen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InitPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
