// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: NinjaCard(),
  ));
}

class NinjaCard extends StatefulWidget {
  const NinjaCard({super.key});

  @override
  State<NinjaCard> createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {
  int ninjaLevel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Charakter'),
        centerTitle: true,
        foregroundColor: Colors.amber,
        backgroundColor: Colors.grey[900],
        elevation: 10,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/Natálka.jpg'),
                radius: 40,
              ),
            ),
            Divider(
              height: 60,
              color: Colors.grey[400],
            ),
            Text(
              'Jméno',
              style: TextStyle(color: Colors.grey[400], letterSpacing: 2),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Natálka',
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Nálada Natálky (1-5)',
              style: TextStyle(color: Colors.grey[400], letterSpacing: 2),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ninjaLevel = ninjaLevel - 1;
                        if (ninjaLevel < 1) {
                          ninjaLevel = 1;
                        }
                      });
                    },
                    child: Icon(Icons.exposure_minus_1),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black),
                  ),
                ),
                Text(
                  '$ninjaLevel',
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ninjaLevel = ninjaLevel + 1;
                        if (ninjaLevel > 5) {
                          ninjaLevel = 5;
                        }
                      });
                    },
                    child: Icon(Icons.exposure_plus_1),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'drobniakovan@seznam.cz ',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
