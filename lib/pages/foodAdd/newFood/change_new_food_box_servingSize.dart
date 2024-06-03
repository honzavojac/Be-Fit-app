import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

class changeNewFoodServingSize extends StatefulWidget {
  const changeNewFoodServingSize({super.key});

  @override
  State<changeNewFoodServingSize> createState() => _changeNewFoodServingSizeState();
}

final List<String> items = [
  'grams',
  '100g',
];
String selectedValue = items[0];

class _changeNewFoodServingSizeState extends State<changeNewFoodServingSize> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
                dbHelper.setNewFoodSelectedValue(selectedValue);
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 120,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ColorsProvider.color_2,
                  width: 0.5,
                ),
              ),
              //elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              iconSize: 17,
              iconEnabledColor: ColorsProvider.color_1,
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
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
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
