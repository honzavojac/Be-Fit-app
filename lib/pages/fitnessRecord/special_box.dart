import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:provider/provider.dart';

class SpecialBox extends StatefulWidget {
  const SpecialBox({Key? key}) : super(key: key);

  @override
  _SpecialBoxState createState() => _SpecialBoxState();
}

class _SpecialBoxState extends State<SpecialBox> {
  var textController = TextEditingController();
  List<Map<String, dynamic>> listMuscles = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirestoreService>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: ColorsProvider.color_7),
        height: 450,
        width: 300,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        // color: ColorsProvider.getColor8(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Enter Intensification technique:',
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: ColorsProvider.color_1,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.getColor2(context),
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.getColor2(context),
                                  width: 3.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 15,
                              ),
                              hintStyle: TextStyle(
                                color: ColorsProvider.color_1,
                                fontSize: 15,
                              ),
                            ),
                            controller: textController,
                            style: TextStyle(color: ColorsProvider.color_1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        // height: 50,
                        // color: ColorsProvider.getColor8(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Enter description:',
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: ColorsProvider.color_1,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.getColor2(context),
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.getColor2(context),
                                  width: 3.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 15,
                              ),
                              hintStyle: TextStyle(
                                color: ColorsProvider.color_1,
                                fontSize: 15,
                              ),
                            ),
                            controller: textController,
                            style: TextStyle(color: ColorsProvider.color_1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      print("uložení intenzifikační techniky");
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsProvider.getColor2(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorsProvider.getColor8(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorsProvider.color_9,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
