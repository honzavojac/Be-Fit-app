import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/variables.dart';
import 'package:provider/provider.dart';

import '../../data_classes.dart';
import '../../database/fitness_database.dart';
import '../../providers/colors_provider.dart';
import '../../pages/foodAdd/my_search_bar.dart';

class Createfood extends StatefulWidget {
  const Createfood({super.key});

  @override
  State<Createfood> createState() => _CreatefoodState();
}

class _CreatefoodState extends State<Createfood> {
  List<IntakeCategories> intakeCategories = [];
  SearchController searchController = SearchController();
  List<TextEditingController> gramsControllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            Opacity(
              opacity: 0,
              child: IgnorePointer(
                ignoring: true,
                child: MySearchBar(
                  intakeCategories: intakeCategories,
                  notifyParent: () {},
                  searchController: searchController,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "enter name of food"),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                gramsControllers.isEmpty
                    ? Dismissible(
                        direction: DismissDirection.endToStart,
                        key: ValueKey<int>(0),
                        background: Container(
                          color: ColorsProvider.color_9,
                          child: Align(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(Icons.delete),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "název jídla",
                                  style: TextStyle(
                                    color: ColorsProvider.getColor2(context),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InputGramsTextField(context, gramsControllers[0]),
                                openSearchBar(searchController, context),
                              ],
                            )
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: ColorsProvider.getColor2(context),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                color: ColorsProvider.getColor8(context),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "add ingredients",
                                style: TextStyle(
                                  color: ColorsProvider.getColor8(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget InputGramsTextField(BuildContext context, TextEditingController gramsController) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width / 2,
    // color: Colors.blue,
    child: TextField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        // labelText: labelText,
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
      // controller: item,
      onChanged: (input) {
        if (input == "") {
        } else {}
      },
    ),
  );
}

Widget openSearchBar(SearchController searchController, BuildContext context) {
  var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

  return GestureDetector(
    child: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: ColorsProvider.getColor2(context)),
      child: Center(
        child: Icon(
          Icons.add,
          size: 30,
          color: ColorsProvider.getColor8(context),
        ),
      ),
    ),
    onTap: () {
      searchController.openView();

      //   for (var i = 0; i < intakeCategories.length; i++) {
      //     if (intakeCategories[i].supabaseIdIntakeCategory ==
      //         idIntakeCategory) {
      //       dbFitness.selectedIntakeCategoryValue = idIntakeCategory;
      //       print(dbFitness.selectedIntakeCategoryValue);
      //     }
      //   }
    },
  );
}
