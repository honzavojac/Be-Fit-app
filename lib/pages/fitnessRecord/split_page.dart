import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Edit your split'),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Add exercise",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Note>>(
                    future: dbHelper.Notes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Chyba: ${snapshot.error}'),
                        );
                      } else {
                        List<Note> splitData = snapshot.data!;
                        return DefaultTabController(
                          length: splitData.length,
                          initialIndex: 0,
                          child: TabBar(
                            tabs: splitData
                                .map(
                                  (note) => Column(
                                    children: [
                                      Text(
                                        "biceps",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "biceps",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        "biceps",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                            indicatorColor: Colors.amber,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.amber,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  iconSize: 40,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.amber[800],
                    ),
                  ),
                  onPressed: () {},
                  color: Colors.black,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blueGrey,
                child: ListView(
                  children: [
                    Container(
                      color: Colors.red,
                      height: 40,
                    ),
                    Container(
                      color: Colors.blue,
                      height: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.red,
                      height: 40,
                    ),
                    Container(
                      color: Colors.blue,
                      height: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.red,
                      height: 40,
                    ),
                    Container(
                      color: Colors.blue,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 70,
          ),
        ],
      ),
    );
  }
}
