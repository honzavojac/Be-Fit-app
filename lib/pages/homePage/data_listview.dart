import 'package:flutter/material.dart';

class dataListview extends StatefulWidget {
  const dataListview({super.key});

  @override
  State<dataListview> createState() => _dataListviewState();
}

//deklarace dvourozměrného pole jídel
List<List<dynamic>> listOfFood = [
  [1, 100, 'kuřecí maso', 21, 0, 1, 0, 121],
  [2, 20, 'rohlík', 1, 2, 3, 4, 90],
  [3, 30, 'protein', 21, 0, 0, 0, 100],
  [4, 150, 'brambory', 2, 35, 0, 4, 160],
  [5, 50, 'Svíčková na smetaně s hosukovým knedlíkem', 1, 5, 0, 2, 20],
  [6, 25, 'mrkev', 0, 6, 0, 3, 10],
];

class _dataListviewState extends State<dataListview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(style: BorderStyle.none),
        // Default border style
      ),
      child: ListView.builder(
          // physics: BouncingScrollPhysics(),
          //reverse: true,
          itemCount: listOfFood.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                //Container(
                                //  child: Text(
                                //    listOfFood[index])),
                                Container(
                                  child: Text(listOfFood[index][2]),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(Icons.delete_outline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 0.15,
                  color: Colors.amber[800],
                )
              ],
            );
          }),
    );
  }
}
