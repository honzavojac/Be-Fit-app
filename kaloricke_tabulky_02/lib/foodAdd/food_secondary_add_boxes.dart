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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Kcal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Kcal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
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
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                  LengthLimitingTextInputFormatter(
                      4) //omezí kolik znaků je možno zadat
                ],
                decoration: const InputDecoration(
                    labelText: 'Protein',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[0-9]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: const InputDecoration(
                    labelText: 'Carbs',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
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
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Fats',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: const InputDecoration(
                  labelText: 'Fiber',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Colors.blue, // Barva levé strany rámečku
                      width: 2.0, // Šířka levé strany rámečku
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Enter value:',
                  hintStyle: TextStyle(fontSize: 15),
                ),
                onChanged: (input) {},
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    hintText: 'Enter value:',
                    hintStyle: TextStyle(
                        fontSize:
                            15) // zobrazí se pokud je textové pole prázdné
                    //  icon: Icon(Icons.text_fields), //
                    ),
                onChanged: (input) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
