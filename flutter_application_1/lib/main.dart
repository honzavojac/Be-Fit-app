// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print

//import 'dart:html';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: Row(
        children: [
          Expanded(flex: 5, child: Image.asset('assets/galaxy_1.jpg')),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.amber,
              child: Text('1'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.pink,
              child: Text('2'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.cyan,
              child: Text('3'),
            ),
          ),
        ],
      ),

      /*Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [Text('data'), Text('data')],
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.amber,
            child: Text('One'),
          ),
          Container(
            padding: EdgeInsets.all(30),
            color: Colors.red,
            child: Text('Two'),
          ),
          Container(
            padding: EdgeInsets.all(40),
            color: Colors.pink,
            child: Text('Three'),
          )
        ],
      ),*/

      /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('data'),
          ElevatedButton(
            onPressed: () {},
            child: Text('click me'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
          ),
          Container(
            color: Colors.tealAccent[400],
            padding: EdgeInsets.all(20),
            child: Text('ahoj'),
          )
        ],
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('click'),
        backgroundColor: Colors.black54,
      ),
    );
  }
}
