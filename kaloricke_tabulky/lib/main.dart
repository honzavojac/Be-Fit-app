// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky/main_page.dart';
import 'first_page.dart';
import 'second_page.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false, // skrývá debug banner
      home: KalorikceTabulkyHome(),
      /*theme: ThemeData( // Nastavení barvy pozadí pro celou aplikaci
    scaffoldBackgroundColor: Colors.blue, */
      /*  routes: {
          'first_page': (context) => FirstPage(),
        }*/
    ));

class KalorikceTabulkyHome extends StatefulWidget {
  const KalorikceTabulkyHome({Key? key}) : super(key: key);

  @override
  State<KalorikceTabulkyHome> createState() => _KalorikceTabulkyHomeState();
}

class _KalorikceTabulkyHomeState extends State<KalorikceTabulkyHome> {
  // Globální proměnná pro padding
  EdgeInsets globalPadding = EdgeInsets.fromLTRB(15, 5, 15, 8);
  Color colorBox = Color.fromARGB(255, 255, 154, 1);

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Souhrn'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 154, 1),
        foregroundColor: Colors.black,
      ),
      drawer: Drawer(
        //backgroundColor: Colors.blueGrey,
        //width: 20,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
          children: [
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Souhrn'),
              onTap: () {
                // Zde můžete definovat akci po klepnutí na položku menu
                index = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Nastavení'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => FirstPage()));
                // Zde můžete definovat akci po klepnutí na položku menu
                //Navigator.pop(context); // Zavřít lištu
                index = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Nastavení'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => FirstPage()));
                // Zde můžete definovat akci po klepnutí na položku menu
                //Navigator.pop(context); // Zavřít lištu
                index = 2;
                setState(() {});
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: index,
        children: [mainPage(), FirstPage(), SecondPage()],
      ),
    );
  }
}
