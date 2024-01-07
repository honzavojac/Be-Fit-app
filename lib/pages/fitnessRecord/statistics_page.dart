import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen();
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 25),
              child: TextField(),
            ),
            Container(
              height: 400,
              width: 300,
              color: Color.fromARGB(255, 0, 87, 218),
              child: Center(
                child: FutureBuilder<List<Note>>(
                  future: dbHelper.Notes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Chyba: ${snapshot.error}'));
                    } else {
                      List<Note> notes = snapshot.data!;
                      return ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Dismissible(
                            key: Key(note.czfoodname),
                            background: Container(
                              color: Colors.green,
                              child: Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Icon(Icons.edit),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Icon(Icons.delete),
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return false;
                              } else {
                                bool delete = true;
                                setState(
                                  () {
                                    dbHelper.deleteItem(notes[index].id,notes[index].czfoodname);
                                    notes.removeAt(index);
                                  },
                                );
                                return delete;
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  child: Text(" id: ${notes[index].id}"),
                                  // Další informace, které chcete zobrazit
                                ),
                                Container(
                                  height: 50, width: 200,
                                  child: buildAnimatedText(
                                      "${notes[index].czfoodname}"),
                                  //  Text(
                                  //     "description:${notes[index].czfoodname}")
                                  // Další informace, které chcete zobrazit
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

Widget buildAnimatedText(String text) {
  if (text.length <= 29) {
    print("${text.indexOf(text)} ${text.length}");
    return Text(text);
  } else {
    print("${text.length}text je větší než 15 znaků");
    return Marquee(
      text: text,
      style: TextStyle(color: Colors.black),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 50.0,
      // velocity: 100.0,
      pauseAfterRound: Duration(seconds: 1),
      startPadding: 0.0,
      // accelerationDuration: Duration(seconds: 1),
      // accelerationCurve: Curves.linear,
      // decelerationDuration: Duration(milliseconds: 500),
      // decelerationCurve: Curves.easeOut,
    );
  }
}
