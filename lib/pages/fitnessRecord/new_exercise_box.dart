import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:provider/provider.dart';

class NewExerciseBox extends StatefulWidget {
  const NewExerciseBox({Key? key}) : super(key: key);

  @override
  _NewExerciseBoxState createState() => _NewExerciseBoxState();
}

// final List<String> items = [
//   'biceps',
//   'triceps',
//   'shoulders',
// ];
//

class _NewExerciseBoxState extends State<NewExerciseBox> {
  List<Map<String, dynamic>> listMuscles = [];
  String? selectedMuscle;
  var textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    var dbFirebase = Provider.of<FirestoreService>(context);

    listMuscles = await dbFirebase.getMuscles();
    // Nastavte výchozí hodnotu na první sval, pokud není seznam prázdný
    if (listMuscles.isNotEmpty) {
      selectedMuscle = listMuscles[0]["name"];
    } else {
      selectedMuscle = " ";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: ColorsProvider.color_7,
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
                      style: TextStyle(
                          color: ColorsProvider.color_1, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorsProvider.color_9,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(child: SizedBox()),
                Center(
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'Name of Exercise:',
                        labelStyle: TextStyle(
                          color: ColorsProvider.color_1,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.color_2,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.color_2,
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                          color: ColorsProvider.color_1,
                          fontSize: 15,
                        ),
                      ),
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
                    style: TextStyle(color: ColorsProvider.color_1),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: listMuscles.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> muscle) {
                      print(dbFirebase.chosedMuscle);
                      return DropdownMenuItem<String>(
                        value: muscle["name"],
                        child: Text(
                          muscle["name"],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorsProvider.color_1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMuscle = value!; // Aktualizace vybraného svalu
                      });
                    },
                    value: dbFirebase.chosedMuscle,
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 150,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: ColorsProvider.color_2,
                          width: 0.5,
                        ),
                      ),
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
                      width: 150,
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
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      dbFirebase.addExercise(
                          textController.text.trim(), selectedMuscle!);
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsProvider.color_2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorsProvider.color_8,
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
