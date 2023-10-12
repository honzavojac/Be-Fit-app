// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky/main.dart';


class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalorické tabulky'),
        centerTitle: true,
        foregroundColor: Colors.amber,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        //backgroundColor: Colors.blueGrey,
        //width: 20,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Domů'),
              onTap: () {
                 
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KalorikceTabulkyHome()));
                // Zde můžete definovat akci po klepnutí na položku menu
                //Navigator.pop(context); // Zavřít lištu
               },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Nastavení'),
              onTap: () {
                // Zde můžete definovat akci po klepnutí na položku menu
                Navigator.pop(context); // Zavřít lištu
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Obsah hlavního obsahu'),
      ),
    );
  }
}
