import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class foodSecondaryAddBoxes extends StatefulWidget {
  const foodSecondaryAddBoxes({super.key});

  @override
  State<foodSecondaryAddBoxes> createState() => _foodSecondaryAddBoxesState();
}

class _foodSecondaryAddBoxesState extends State<foodSecondaryAddBoxes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text('Fats', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Saturated Fatty Acids',
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            10) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Trans Fatty Acids',
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            10) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Monounsaturated Fats',
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            10) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Polyunsaturated Fats',
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            10) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Carbs', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Sugars',
                    labelStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            10) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text('Others', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(
                          4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Salt',
                        labelStyle: TextStyle(fontSize: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                            fontSize:
                                10) // zobrazí se pokud je textové pole prázdné
                        //  icon: Icon(Icons.text_fields), //
                        ),
                    onChanged: (input) {},
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(
                          4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Water',
                        labelStyle: TextStyle(fontSize: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                            fontSize:
                                10) // zobrazí se pokud je textové pole prázdné
                        //  icon: Icon(Icons.text_fields), //
                        ),
                    onChanged: (input) {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(
                          4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Cholesterol',
                        labelStyle: TextStyle(fontSize: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                            fontSize:
                                10) // zobrazí se pokud je textové pole prázdné
                        //  icon: Icon(Icons.text_fields), //
                        ),
                    onChanged: (input) {},
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text('Vitamins', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
