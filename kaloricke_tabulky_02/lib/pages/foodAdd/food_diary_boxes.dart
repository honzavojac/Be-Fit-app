import 'package:flutter/material.dart';

import 'my_search_bar.dart';

class foodDiaryBoxes extends StatefulWidget {
  const foodDiaryBoxes({super.key});

  @override
  State<foodDiaryBoxes> createState() => _foodDiaryBoxesState();
}

class _foodDiaryBoxesState extends State<foodDiaryBoxes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(style: BorderStyle.none),
      ),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          //reverse: true,
          itemCount: jidla.length,
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
                                Container(child: Text('100g ')),
                                Container(child: Text(jidla[index])),
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
