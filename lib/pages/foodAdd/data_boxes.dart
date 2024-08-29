import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

import 'change_data_box_servingSize.dart';

class myDataboxes extends StatefulWidget {
  const myDataboxes({super.key});

  @override
  State<myDataboxes> createState() => _myDataboxesState();
}

class _myDataboxesState extends State<myDataboxes> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return Row(
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
                labelText: 'Serving size',
                labelStyle: TextStyle(color: ColorsProvider.getColor2(context)),
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
                hintStyle: TextStyle(color: ColorsProvider.getColor2(context), fontSize: 15) // zobrazí se pokud je textové pole prázdné
                //  icon: Icon(Icons.text_fields), //
                ),
            onChanged: (input) {
              int value = int.parse(input);
              dbHelper.Grams(value);
            },
          ),
        ),
        changeDataBoxServingSize(),
      ],
    );
  }
}
