import 'package:diacritic/diacritic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/food_page.dart';
import 'package:provider/provider.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';

class MySearchBar extends StatefulWidget {
  final Function notifyParent;
  final SearchController searchController;
  final List<IntakeCategories> intakeCategories;
  const MySearchBar({
    Key? key,
    required this.notifyParent,
    required this.searchController,
    required this.intakeCategories,
  }) : super(key: key);

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    var supabaseProvider = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);

    return Container(
      height: 85,
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: SearchAnchor(
        searchController: widget.searchController,
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            elevation: WidgetStateProperty.all(25),
            shadowColor: WidgetStateProperty.all(ColorsProvider.color_4),
            controller: controller,
            padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 10.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (query) async {
              // Aktualizujte výsledky na základě vyhledávacího dotazu
              controller.openView();
            },
            leading: Icon(Icons.search, color: ColorsProvider.getColor2(context)),
            hintText: '${'search_food'.tr()}...',
            hintStyle: WidgetStatePropertyAll(
              TextStyle(
                color: ColorsProvider.getColor2(context),
              ),
            ),
          );
        },
        dividerColor: ColorsProvider.getColor2(context),
        headerTextStyle: TextStyle(color: ColorsProvider.getColor2(context)),
        viewBuilder: (suggestions) {
          final List<Widget> suggestionWidgets = suggestions.toList(); // Convert to List
          return ListView.builder(
            // scrollDirection: Axis.horizontal,
            itemCount: suggestionWidgets.length,
            itemBuilder: (context, index) {
              final widget = suggestionWidgets[index];
              return widget; // Access element using []
            },
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) async {
          // Získejte vyhledávací termín a odstraňte diakritiku
          String searchTerm = removeDiacritics(controller.text.toLowerCase());

          // Získejte výsledky ze Sqflite (offline data)
          List<Food> dataSqflite = await dbFitness.FoodTable(searchTerm);

          // Nastavte text "Recently used" pro položky ze Sqflite
          dataSqflite.forEach((element) {
            element.recentlyUsed = "recently_used".tr();
          });

          List<Food> dataSupabase = [];
          bool supabaseFailed = false;

          try {
            // Pokus o načtení výsledků ze Supabase
            dataSupabase = await supabaseProvider.FoodTable(searchTerm);
          } catch (e) {
            // Pokud dojde k chybě (např. výpadek připojení), zpracuje se chyba a označí, že Supabase selhalo
            supabaseFailed = true;
            print("Supabase data could not be loaded: $e");
          }

          if (!supabaseFailed) {
            // Pokud Supabase funguje, pokračujte s filtrováním dat

            // Filtrace: Získání ID všech položek ze Sqflite
            Set<int?> sqfliteIds = dataSqflite.map((food) => food.idFood).toSet();

            // Filtrujte položky ze Supabase, které mají stejné idFood jako položky v Sqflite
            List<Food> filteredSupabaseData = dataSupabase.where((food) {
              return !sqfliteIds.contains(food.idFood);
            }).toList();

            // Rozdělení Supabase dat na položky, které začínají a nezačínají na hledaný výraz
            List<Food> startingWithSearchTerm = filteredSupabaseData.where((food) {
              return food.unaccentName?.toLowerCase().startsWith(searchTerm) ?? false;
            }).toList();

            List<Food> notStartingWithSearchTerm = filteredSupabaseData.where((food) {
              return !(food.unaccentName?.toLowerCase().startsWith(searchTerm) ?? false);
            }).toList();

            // Seřazení obou částí podle názvu
            startingWithSearchTerm.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
            notStartingWithSearchTerm.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

            // Spojení dat: dataSqflite jako první, pak sortedSupabaseData
            dataSqflite.addAll([...startingWithSearchTerm, ...notStartingWithSearchTerm]);
          }

          print(dataSqflite.toString());

          // Mapování výsledků na ListTile
          List<Widget> suggestions = dataSqflite.map((food) {
            return ListTile(
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "${food.name ?? 'Unknown'}",
                        style: TextStyle(color: ColorsProvider.getColor2(context).withAlpha(230)),
                      ),
                    ),
                    if (food.recentlyUsed != null)
                      Expanded(
                        flex: 0,
                        child: Text(
                          " ${food.recentlyUsed}",
                          style: TextStyle(color: Colors.white30),
                        ),
                      ),
                  ],
                ),
              ),
              onTap: () async {
                controller.closeView(food.name ?? 'Unknown');
                // Přidejte akce po výběru položky jídla
                FocusScope.of(context).unfocus();
                await Navigator.pushNamed(context, '/addIntakePage', arguments: [food, quantity, true, widget.intakeCategories]);
                widget.notifyParent();
                controller.text = "";
              },
            );
          }).toList();

          double keyboardHeight = await MediaQuery.of(context).viewInsets.bottom;

          // Vložení seznamu návrhů a ListView s pevnou výškou
          return [
            ...suggestions,
            Container(
              height: keyboardHeight + 20,
              child: ListView(
                children: [
                  Center(
                      // child: Text("There is nothing more"),
                      )
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
