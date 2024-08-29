import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../providers/colors_provider.dart';

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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorsProvider.getColor2(context), width: 1),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Center(
                        child: Text(
                          'Carbs',
                          style: TextStyle(fontSize: 20, color: ColorsProvider.color_1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: InputDecoration(
                  labelText: 'Saturated Fatty Acids',
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: ColorsProvider.color_1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: InputDecoration(
                  labelText: 'Trans Fatty Acids',
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: ColorsProvider.color_1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
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
              width: 150,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: InputDecoration(
                  labelText: 'Monounsaturated Fats',
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: ColorsProvider.color_1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: InputDecoration(
                  labelText: 'Polyunsaturated Fats',
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: ColorsProvider.color_1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: ColorsProvider.getColor2(context), width: 1),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Center(
                        child: Text(
                          'Carbs',
                          style: TextStyle(fontSize: 20, color: ColorsProvider.color_1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: InputDecoration(
                  labelText: 'Sugars',
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: ColorsProvider.color_1,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: ColorsProvider.getColor2(context),
                      width: 3.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: ColorsProvider.getColor2(context), width: 1),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Center(
                            child: Text(
                              'Carbs',
                              style: TextStyle(fontSize: 20, color: ColorsProvider.color_1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: InputDecoration(
                      labelText: 'Salt',
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: ColorsProvider.color_1,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 3.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      hintText: 'Enter value:',
                      hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                    ),
                    onChanged: (input) {},
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: InputDecoration(
                      labelText: 'Water',
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: ColorsProvider.color_1,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 3.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      hintText: 'Enter value:',
                      hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
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
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                    ],
                    decoration: InputDecoration(
                      labelText: 'Cholesterol',
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: ColorsProvider.color_1,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide: BorderSide(
                          color: ColorsProvider.getColor2(context),
                          width: 3.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      hintText: 'Enter value:',
                      hintStyle: TextStyle(color: ColorsProvider.color_1, fontSize: 15), // zobrazí se pokud je textové pole prázdné
                    ),
                    onChanged: (input) {},
                  ),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            //       child: Text('Vitamins', style: TextStyle(fontSize: 20)),
            //     ),
            //   ],
            // ),
          ],
        ),
      ],
    );
  }
}
