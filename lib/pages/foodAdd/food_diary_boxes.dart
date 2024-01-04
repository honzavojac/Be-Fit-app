import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import 'my_search_bar.dart';

class foodDiaryBoxes extends StatefulWidget {
  const foodDiaryBoxes({super.key});

  @override
  State<foodDiaryBoxes> createState() => _foodDiaryBoxesState();
}

class _foodDiaryBoxesState extends State<foodDiaryBoxes> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(style: BorderStyle.none),
      ),
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
                          dbHelper.deleteItem(notes[index].id);
                          notes.removeAt(index);
                        },
                      );
                      return delete;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        child: Text(" id: ${notes[index].id}"),
                        // Další informace, které chcete zobrazit
                      ),
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          child:
                              buildAnimatedText("${notes[index].czfoodname}"),
                          //  Text(
                          //     "description:${notes[index].czfoodname}")
                          // Další informace, které chcete zobrazit
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
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
      style: TextStyle(color: Colors.white),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 50.0,
      // velocity: 100.0,
      startAfter: Duration(seconds: 2),
      pauseAfterRound: Duration(seconds: 2),
      startPadding: 0.0,
      // accelerationDuration: Duration(seconds: 1),
      // accelerationCurve: Curves.linear,
      // decelerationDuration: Duration(milliseconds: 500),
      // decelerationCurve: Curves.easeOut,
    );
  }
}
