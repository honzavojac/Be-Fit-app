import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets_for_multiple_screens/change_servingSize.dart';

class myDataboxes extends StatefulWidget {
  const myDataboxes({super.key});

  @override
  State<myDataboxes> createState() => _myDataboxesState();
}

class _myDataboxesState extends State<myDataboxes> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                labelText: 'Serving size',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                hintText: 'Enter value:',
                hintStyle: TextStyle(
                    fontSize: 15) // zobrazí se pokud je textové pole prázdné
                //  icon: Icon(Icons.text_fields), //
                ),
            onChanged: (input) {},
          ),
        ),
        changeServingSize(),
      ],
    );
  }
}
