import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

class changeDataBoxServingSize extends StatefulWidget {
  const changeDataBoxServingSize({super.key});

  @override
  State<changeDataBoxServingSize> createState() => _changeDataBoxServingSizeState();
}

final List<String> items = [
  'grams',
  '100g',
];
String selectedValue = items[0];

class _changeDataBoxServingSizeState extends State<changeDataBoxServingSize> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    '$selectedValue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorsProvider.getColor2(context)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
                dbHelper.setSelectedValue(selectedValue);
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 120,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ColorsProvider.getColor2(context),
                  width: 0.5,
                ),
              ),
              //elevation: 2,
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              iconSize: 17,
              iconEnabledColor: ColorsProvider.getColor2(context),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              offset: const Offset(0, -10),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
    );
  }
}
