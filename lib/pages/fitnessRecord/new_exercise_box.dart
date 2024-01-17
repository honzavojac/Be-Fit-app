import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

class NewExerciseBox extends StatefulWidget {
  const NewExerciseBox({Key? key}) : super(key: key);

  @override
  _NewExerciseBoxState createState() => _NewExerciseBoxState();
}

final List<String> items = [
  'biceps',
  'triceps',
  'shoulders',
];
String selectedValue = items[0];

class _NewExerciseBoxState extends State<NewExerciseBox> {
  @override
  Widget build(BuildContext context) {
    var dbHelper = Provider.of<DBHelper>(context);
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        height: 250,
        width: 220,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: Text(
                      "New Exercise",
                      style: TextStyle(color: Colors.amber[600], fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(child: Container()),
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Name of Exercise:',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(255, 179, 0, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 143, 0, 1),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 143, 0, 1),
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(255, 179, 0, 1),
                          fontSize: 15,
                        ),
                      ),
                      onChanged: (input) {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 20,
                  child: Text(
                    "Assign a Muscle",
                    style: TextStyle(color: Colors.amber[600]),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: FutureBuilder(future: dbHelper.Svaly(),builder: (context, snapshot) {
                    return DropdownButton2<String>(
                      isExpanded: true,
                      items: items
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 150,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Color.fromRGBO(255, 143, 0, 1),
                            width: 0.5,
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
                        width: 150,
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
                    );  
                  },
                  
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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
