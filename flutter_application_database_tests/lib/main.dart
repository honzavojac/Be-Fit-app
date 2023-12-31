import 'package:flutter/material.dart';
import 'package:flutter_application_database_tests/database.dart';
import 'package:flutter_application_database_tests/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  DBHelper dbHelper = DBHelper();
  // databaseFactory = databaseFactoryFfi;

  await dbHelper.initializeDB();
  // await dbHelper.insertItem("ahoj1");
  // dbHelper.deleteItem();
  // Počkáme na dokončení inicializace databáze

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CounterProvider(),
        ),
      ],
      child: MyApp(dbHelper: dbHelper),
    ),
  );
}

class MyApp extends StatefulWidget {
  final DBHelper dbHelper;

  const MyApp({Key? key, required this.dbHelper}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Container(
                width: 300,
                height: 50,
                color: Colors.blue,
                child: buildAnimatedText(
                    'Some sample text that takes some space.'))),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.amber,
                  width: 200,
                  height: 400,
                  child: FutureBuilder<List<Note>>(
                    future: widget.dbHelper.Notes(),
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
                                    ()  {
                                      widget.dbHelper
                                          .deleteItem(notes[index].id);
                                      notes.removeAt(index);
                                    },
                                  );
                                  return delete;
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    child: Text(" id: ${notes[index].id}"),
                                    // Další informace, které chcete zobrazit
                                  ),
                                  Container(
                                    height: 50, width: 100,
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
              ],
            ),
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Center(
                child: Text(
                  context.watch<CounterProvider>().value.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          context.read<CounterProvider>().incremmentValue();
          widget.dbHelper.insertItem("item");
        }),
      ),
    );
  }
}

Widget buildAnimatedText(String text) {
  if (text.length <= 50) {
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
