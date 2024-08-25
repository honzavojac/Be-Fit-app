import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/database/database_provider.dart';
import 'package:provider/provider.dart';

class changeNewFoodServingSize extends StatefulWidget {
  final List<String> quantity;
  final Function()? notifyParent;

  const changeNewFoodServingSize({
    super.key,
    required this.quantity,
    this.notifyParent,
  });

  @override
  State<changeNewFoodServingSize> createState() => _changeNewFoodServingSizeState();
}

class _changeNewFoodServingSizeState extends State<changeNewFoodServingSize> {
  late String selectedValue;
  late int selectedQuantity;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    selectedQuantity = dbFitness.selectedQuantity = 0;
    selectedValue = widget.quantity[selectedQuantity];
  }

  @override
  Widget build(BuildContext context) {
    var dbFitness = Provider.of<FitnessProvider>(context);

    return Container(
      width: 100,
      height: 50,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          items: widget.quantity
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorsProvider.color_2),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) async {
            setState(() {
              selectedValue = value!;
              dbFitness.selectedQuantity = widget.quantity.indexOf(value);
              print(dbFitness.selectedQuantity);

              // Zavolejte notifyParent, pokud je definována
              if (widget.notifyParent != null) {
                widget.notifyParent!(); // Zavolejte funkci bez argumentů
              }
            });
          },
          alignment: Alignment.center,
          style: TextStyle(
            // color: ColorsProvider.color_8,
            fontWeight: FontWeight.bold,
            fontSize: 5,
          ),
          isDense: true,
          menuItemStyleData: MenuItemStyleData(
              // height: 37,
              ),
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            offset: Offset(-0, -3),
            elevation: 2,
            // width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromARGB(195, 0, 0, 0),
            ),
          ),
          buttonStyleData: ButtonStyleData(
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 0.5, color: ColorsProvider.color_2),
            ),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      ),
    );
  }
}
