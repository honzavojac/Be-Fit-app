import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:provider/provider.dart';

class choseYourSplit extends StatefulWidget {
  const choseYourSplit({super.key});

  @override
  State<choseYourSplit> createState() => _choseYourSplitState();
}

class _choseYourSplitState extends State<choseYourSplit> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 40,
            child: DropdownButtonHideUnderline(
              child: FutureBuilder(
                future: dbHelper.getNazvySplitu(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No data available.'),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    List<String>? items = snapshot.data!;
                    if (dbHelper.selectedValue.isEmpty) {
                      dbHelper.selectedValue = items.first;
                    }
                    return DropdownButton2<String>(
                      isExpanded: true,
                      items: items.map(
                        (String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorsProvider.color_1),
                              overflow: TextOverflow.clip,
                            ),
                          );
                        },
                      ).toList(),
                      value: dbHelper.selectedValue,
                      onChanged: (value) {
                        print("---${dbHelper.selectedValue}");
                        print(value);
                        dbHelper.selectedValue = value!;
                        setState(() {});
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 230,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: ColorsProvider.getColor2(context),
                            width: 0.5,
                          ),
                        ),
                        // elevation: 2,
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
                        width: 300,
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
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
