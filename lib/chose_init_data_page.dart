import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'variables.dart';

import 'login_supabase/splash_page.dart';
import 'main.dart';

class ChoseInitDataPage extends StatefulWidget {
  const ChoseInitDataPage({super.key});

  @override
  State<ChoseInitDataPage> createState() => _ChoseInitDataPageState();
}

class _ChoseInitDataPageState extends State<ChoseInitDataPage> {
  late String email;

  TextEditingController _nameController = TextEditingController(text: "Username");
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Načtení argumentů
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    email = args[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: ColorsProvider.color_2,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/gym.png',
                      height: 300,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        customText("Enter your name"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              border: Border.all(color: ColorsProvider.color_8, width: 4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextField(
                                controller: _nameController,
                                onTapOutside: (event) {
                                  setState(() {});
                                  FocusScope.of(context).unfocus();
                                },
                                onTap: () {
                                  _nameController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: _nameController.text.length,
                                  );
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.color_2),
                                ),
                                cursorColor: ColorsProvider.color_2,
                                style: TextStyle(color: ColorsProvider.color_2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        customText("Choose language"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Container(
                            // height: 55,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              border: Border.all(color: ColorsProvider.color_8, width: 4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                value: selectedCountry,
                                items: languages.map((country) {
                                  return DropdownMenuItem<String>(
                                    value: country['code'],
                                    child: Text(
                                      country['name']!,
                                      style: TextStyle(color: ColorsProvider.color_2),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCountry = value;
                                  setState(() {});
                                },
                                buttonStyleData: ButtonStyleData(
                                  // width: 180,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(18),
                                  //   border: Border.all(
                                  //     color: ColorsProvider.color_8,
                                  //     width: 0.5,
                                  //   ),
                                  // ),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                                  iconSize: 17,
                                  iconEnabledColor: ColorsProvider.color_1,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(width: 2, color: ColorsProvider.color_8),
                                  ),
                                  offset: const Offset(0, -0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    interactive: true,
                                    thickness: WidgetStateProperty.all(6),
                                    thumbVisibility: WidgetStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  // height: 40,
                                  padding: EdgeInsets.only(left: 10, right: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        customText("Select your date of birth"),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width: 300, // Define a fixed width
                                    height: 300, // Define a fixed height
                                    child: DatePicker(
                                      centerLeadingDate: true,
                                      minDate: DateTime(1900),
                                      maxDate: DateTime.now(),
                                      initialDate: _selectedDateOfBirth,
                                      selectedDate: _selectedDateOfBirth,
                                      highlightColor: Colors.transparent,
                                      splashRadius: 0,
                                      onDateSelected: (value) {
                                        _selectedDateOfBirth = value;
                                        print(value);
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      currentDateDecoration: BoxDecoration(
                                        border: Border.all(color: ColorsProvider.color_2),
                                        shape: BoxShape.circle,
                                      ),
                                      daysOfTheWeekTextStyle: const TextStyle(color: ColorsProvider.color_2),
                                      enabledCellsDecoration: const BoxDecoration(),
                                      initialPickerType: PickerType.days,
                                      leadingDateTextStyle: const TextStyle(color: ColorsProvider.color_2),
                                      slidersColor: ColorsProvider.color_2,
                                      slidersSize: 25,
                                      selectedCellDecoration: BoxDecoration(
                                        color: ColorsProvider.color_2,
                                        shape: BoxShape.circle,
                                      ),
                                      selectedCellTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      disabledCellsDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        backgroundBlendMode: BlendMode.colorBurn,
                                        shape: BoxShape.circle,
                                      ),
                                      currentDateTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      enabledCellsTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                border: Border.all(color: ColorsProvider.color_8, width: 4),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "${_selectedDateOfBirth != null ? (DateFormat('dd.MM.yyyy').format(_selectedDateOfBirth!)) : ""}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ColorsProvider.color_2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          var user = {
            'name': _nameController.text.trim(),
            'email': email,
            'country': selectedCountry,
            'birth_date': _selectedDateOfBirth.toString(),
          };
          await supabase.from("users").insert(user);
          var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
          var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

          UserSupabase? newUser = await dbSupabase.getUser();
          // Získání ID nově registrovaného uživatele
          print("id new newUser: ${newUser!.idUser}");
          final categories = [
            {'name': 'Meal 1', 'id_user': newUser.idUser},
            {'name': 'Meal 2', 'id_user': newUser.idUser},
            {'name': 'Meal 3', 'id_user': newUser.idUser},
            {'name': 'Meal 4', 'id_user': newUser.idUser},
            {'name': 'Meal 5', 'id_user': newUser.idUser},
            {'name': 'Meal 6', 'id_user': newUser.idUser},
          ];
          await supabase.from("intake_categories").insert(categories);
          var data = await supabase.from("intake_categories").select().eq("id_user", newUser.idUser);
          List<dynamic> finalData = data;
          final List<IntakeCategories> intakeCategories = finalData.map((e) => IntakeCategories.fromJson(e)).toList();
          for (var intakeCategory in intakeCategories) {
            print(intakeCategory.name);
            await dbFitness.insertIntakeCategory(intakeCategory.name!, 0, intakeCategory.idIntakeCategory!);
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashPage()),
            (Route<dynamic> route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            width: 170,
            height: 50,
            decoration: BoxDecoration(
              color: (_nameController.text != "" && selectedCountry != null && _selectedDateOfBirth != null) ? ColorsProvider.color_8 : ColorsProvider.color_8.withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Go to app",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: (_nameController.text != "" && selectedCountry != null && _selectedDateOfBirth != null) ? ColorsProvider.color_2 : ColorsProvider.color_2.withAlpha(100),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget customText(String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$text",
                style: TextStyle(
                  fontSize: 17,
                  color: ColorsProvider.color_8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
