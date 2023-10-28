import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class changeServingSize extends StatefulWidget {
  const changeServingSize({super.key});

  @override
  State<changeServingSize> createState() => _changeServingSizeState();
}

final List<String> items = [
  'grams',
  '100 g',
];
String selectedValue = items[0];

class _changeServingSizeState extends State<changeServingSize> {
  @override
  Widget build(BuildContext context) {
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
                      color: Colors.yellow,
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
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: 120,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: 1,
                  color: Colors.white54,
                ),
                // color: Colors.redAccent,
              ),
              //elevation: 2,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              iconSize: 17,
              iconEnabledColor: Colors.amber,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                // color: Colors.redAccent,
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
