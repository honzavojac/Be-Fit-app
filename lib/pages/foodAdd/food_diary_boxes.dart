import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
// import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

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
        color: ColorsProvider.color_7,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(style: BorderStyle.none),
      ),
      child: FutureBuilder<List<Note>>(
        future: dbHelper.Notes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Chyba: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Note> notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(note.czfoodname),
                  background: Container(
                    color: ColorsProvider.color_9,
                    child: Align(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(Icons.delete),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 5),
                        backgroundColor: ColorsProvider.color_2,
                        content: Container(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Do you want delete this record?',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(ColorsProvider.color_8),
                                  foregroundColor: WidgetStatePropertyAll(
                                    ColorsProvider.color_1,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    dbHelper.deleteItem(notes[index].id, notes[index].czfoodname);
                                    notes.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                                child: Text("yes"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return null;
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsProvider.color_2,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(style: BorderStyle.none),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: LayoutBuilder(builder: (context, constraints) {
                                TextPainter textPainter = TextPainter(
                                  text: TextSpan(text: "${notes[index].czfoodname}", style: TextStyle(fontSize: 16.0)),
                                  textDirection: TextDirection.ltr,
                                );

                                textPainter.layout(maxWidth: constraints.maxWidth);
                                // print(
                                //     "${textPainter.width} ${constraints.maxWidth}");
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 20,
                                        // child: buildAnimatedText("${notes[index].czfoodname}", textPainter.width, constraints.maxWidth),
                                        //  Text(
                                        //     "description:${notes[index].czfoodname}")
                                        // Další informace, které chcete zobrazit
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 5),
                        child: Container(
                          // color: ColorsProvider.color_8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Text("Serving"),
                                    height: 18,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("${notes[index].grams} g"),
                                    height: 20,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 18,
                                    child: Text(" Kcal"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: Text("${notes[index].kcal}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 18,
                                    child: Text(" Protein"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: Text("${notes[index].protein}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 18,
                                    child: Text(" Carbs"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: Text("${notes[index].carbs}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 18,
                                    child: Text(" Fat"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: Text("${notes[index].fat}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 18,
                                    child: Text(" Fiber"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    child: Text("${notes[index].fiber}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                ],
                              ),
                            ],
                          ),
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

// Widget buildAnimatedText(String text, double textPainter, double boxConstraints) {
//   if (textPainter < boxConstraints) {
//     // print("${text.indexOf(text)} ${text.length}");
//     return Text(
//       text,
//       style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 15),
//     );
//   } else {
//     // print("${text.length}text je větší než widget");
//     return Marquee(
//       text: text,
//       style: TextStyle(color: ColorsProvider.color_8, fontWeight: FontWeight.bold, fontSize: 15),
//       scrollAxis: Axis.horizontal,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       blankSpace: 50.0,
//       // velocity: 100.0,
//       startAfter: Duration(seconds: 2),
//       pauseAfterRound: Duration(seconds: 2),
//       startPadding: 0.0,
//       // accelerationDuration: Duration(seconds: 1),
//       // accelerationCurve: Curves.linear,
//       // decelerationDuration: Duration(milliseconds: 500),
//       // decelerationCurve: Curves.easeOut,
//     );
//   }
// }
