import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/change_new_food_box_servingSize.dart';

class foodMainAddBoxes extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController kcalController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;
  final TextEditingController fiberController;
  final List<String> quantity;
  const foodMainAddBoxes({
    super.key,
    required this.nameController,
    required this.weightController,
    required this.kcalController,
    required this.proteinController,
    required this.carbsController,
    required this.fatsController,
    required this.fiberController,
    required this.quantity,
  });

  @override
  State<foodMainAddBoxes> createState() => _foodMainAddBoxesState();
}

class _foodMainAddBoxesState extends State<foodMainAddBoxes> {
  @override
  void initState() {
    super.initState();
    widget.nameController.clear();
    widget.weightController.clear();
    widget.kcalController.clear();
    widget.proteinController.clear();
    widget.carbsController.clear();
    widget.fatsController.clear();
    widget.fiberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 50,
      ),
      Center(child: inputFoodItems("name_of_food".tr(), widget.nameController, 330, "text")),
      SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          inputFoodItems("serving_size".tr(), widget.weightController, 150, "numeric"),
          changeNewFoodServingSize(
            quantity: widget.quantity,
          ),
        ],
      ),
      const SizedBox(
        height: 35,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          inputFoodItems("Kcal", widget.kcalController, 150, "numeric"),
        ],
      ),
      const SizedBox(
        height: 35,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          inputFoodItems("protein".tr(), widget.proteinController, 150, "numeric"),
          inputFoodItems("carbs".tr(), widget.carbsController, 150, "numeric"),
        ],
      ),
      const SizedBox(
        height: 35,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          inputFoodItems("fat".tr(), widget.fatsController, 150, "numeric"),
          inputFoodItems("fiber".tr(), widget.fiberController, 150, "numeric"),
        ],
      ),
    ]);
  }

  Widget inputFoodItems(String labelText, TextEditingController item, double size, String keyboard) {
    return SizedBox(
      width: size,
      child: TextField(
        inputFormatters: [
// povoluje zadat pouze string hodnotu => použiju pro vyhledávání v databázi
          keyboard == "text" ? LengthLimitingTextInputFormatter(50) : LengthLimitingTextInputFormatter(6)
        ],
        keyboardType: keyboard == "text" ? TextInputType.text : TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: ColorsProvider.getColor2(context),
          ),
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
          // hintText: 'Enter name of $latelText:',
          hintStyle: TextStyle(color: ColorsProvider.getColor2(context), fontSize: 15), // zobrazí se pokud je textové pole prázdné
        ),
        controller: item,
        onChanged: (input) {
          if (input == "") {
          } else {}
        },
      ),
    );
  }
}
