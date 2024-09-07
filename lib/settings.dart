import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/login_supabase/splash_page.dart';
import 'package:kaloricke_tabulky_02/main.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'variables.dart';
import 'data_classes.dart';

class Settings extends StatefulWidget {
  final Function(ThemeMode) notifyMyApp;
  const Settings({super.key, required this.notifyMyApp});

  @override
  State<Settings> createState() => _SettingsState();
}
//! TODO: odstranit sqflite / supabase přepínač
//! upravit select jazyků
// dát tam color picker ale nebude zatím viditelný
//! dát tam změnu jména,( věku zatím ne ),
//! udělat odstranění učtu!!!

//
//
// String? selectedCountry;

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  List<Muscle> data1 = [];

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> load() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    data1 = await dbFitness.SyncFromSupabase(context);
    language = await _getLanguage();
    await dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
    print("saved to supabase");
    print(language);

    setState(() {});
  }

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    // Změnit jazyk v aplikaci
    context.setLocale(locale);

    // Uložit volbu jazyka do SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language_code', locale.languageCode);
  }

  Future<String> _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language_code');

    if (languageCode != null) {
      return languageCode;
    } else {
      return 'en'; // Defaultní jazyk, pokud žádný není uložen
    }
  }

  String? language;
  @override
  // Future<void> didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   language = await _getLanguage();
  // }

  @override
  void initState() {
    super.initState();
    load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);
      // dbSupabase.getUser();
      // _nameController.text = dbSupabase.user?.name ?? '';
      selectedCountry = user!.country;
      _nameController.text = user!.name;
    });
  }

  Future<void> waitForSyncingToComplete() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

    bool syncing = dbFitness.checkIfSyncing();

    // Check if syncing is true
    while (syncing) {
      // Wait for a short duration before checking again
      await Future.delayed(Duration(milliseconds: 500));

      // Re-check the value of syncing
      syncing = dbFitness.checkIfSyncing();
    }
    await dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
    print("uloženo a sjednoceny databáze");
  }

  List<Muscle> data3 = [];
  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    var dbFitness = Provider.of<FitnessProvider>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr()),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Deleting user data",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
                            ),
                            // LoadingAnimationWidget.waveDots(color: Colors.white, size: 20)
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                          color: ColorsProvider.getColor2(context),
                          size: 100,
                        )),
                      ],
                    ),
                  );
                },
              );
              await waitForSyncingToComplete();

              await _deleteCacheDir();

              await dbFitness.deleteAllData();
              user = null;
              dbSupabase.clearUserData();
              _signOut();
            },
            icon: Icon(
              Icons.logout,
              color: ColorsProvider.color_9,
              size: 25,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   height: 50,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Text("sqflite"),
          //       Switch(
          //         activeTrackColor: ColorsProvider.getColor2(context), activeColor: Colors.black,
          //         // activeColor: ColorsProvider.getColor2(context),
          //         inactiveTrackColor: ColorsProvider.getColor8(context),
          //         value: dbFitness.switchButton,
          //         onChanged: (value) {
          //           dbFitness.switchButton = value;
          //           print(dbFitness.switchButton);
          //           // setState(() {});,
          //           Navigator.of(context).pushNamedAndRemoveUntil('/account', (Route<dynamic> route) => false);
          //         },
          //       ),
          //       Text("supabase"),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 20,
          // ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "change_language".tr(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 70,
                child: ListView.builder(
                  itemCount: flags.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        // height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: locales[index].languageCode.toString().toLowerCase() == language.toString().toLowerCase() ? ColorsProvider.getColor2(context) : Colors.transparent, // Výchozí barva nebo jiná barva
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                              onTap: () {
                                language = locales[index].languageCode;
                                _changeLanguage(context, locales[index]);
                                load();

                                // setState(() {});
                              },
                              child: flags[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Spacer(
            flex: 1,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "change_theme".tr(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    // color: ColorsProvider.getColor8(context),
                    border: Border.all(width: 2),
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("light".tr()),
                      Switch(
                        activeTrackColor: ColorsProvider.getColor2(context),
                        activeColor: Colors.black,
                        // activeColor: ColorsProvider.getColor2(context),
                        inactiveTrackColor: ColorsProvider.getColor8(context),
                        value: isDarkMode,
                        onChanged: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.getString('themeMode');
                          // print(themeModeString);
                          if (!isDarkMode) {
                            widget.notifyMyApp(ThemeMode.dark);
                            darkTheme = true;
                          } else {
                            widget.notifyMyApp(ThemeMode.light);
                            darkTheme = false;
                          }
                        },
                      ),
                      Text("dark".tr()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(
            flex: 1,
          ),

          // Column(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 25),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Text(
          //               "Change your name",
          //               style: TextStyle(fontSize: 18),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 50),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           // color: Colors.grey[800],
          //           border: Border.all(color: ColorsProvider.getColor8(context), width: 2),
          //           borderRadius: BorderRadius.circular(18),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 20),
          //           child: TextField(
          //             controller: _nameController,
          //             onTapOutside: (event) {
          //               setState(() {});
          //               FocusScope.of(context).unfocus();
          //             },
          //             onTap: () {
          //               _nameController.selection = TextSelection(
          //                 baseOffset: 0,
          //                 extentOffset: _nameController.text.length,
          //               );
          //             },
          //             onChanged: (value) async {
          //               print(value);
          //               switch (user!.action) {
          //                 case 0:
          //                   await dbFitness.updateUser(value, 2);

          //                   break;
          //                 case 1:
          //                   await dbFitness.updateUser(value, 1);

          //                   break;
          //                 case 2:
          //                   await dbFitness.updateUser(value, 2);

          //                   break;
          //                 default:
          //               }
          //             },
          //             decoration: InputDecoration(
          //               border: InputBorder.none,
          //               hintText: "Name",
          //               hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ColorsProvider.getColor2(context)),
          //             ),
          //             cursorColor: ColorsProvider.getColor2(context),
          //             style: TextStyle(color: ColorsProvider.getColor2(context)),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "change_food_database".tr(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedCountry,
                          items: languages.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['code'],
                              child: Text(
                                country['name']!,
                                style: TextStyle(color: ColorsProvider.getColor2(context)),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            selectedCountry = value;
                            print(value);
                            await dbFitness.updateUserFoodDatabaseLanguage(value!);
                            user!.country = value;
                            setState(() {});
                          },
                          buttonStyleData: ButtonStyleData(
                            // width: 180,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down_outlined),
                            iconSize: 17,
                            iconEnabledColor: ColorsProvider.getColor2(context),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                width: 2,
                                color: ColorsProvider.getColor8(context),
                              ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: HelpButton(helpText: "change_food_database_help".tr()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(
            flex: 5,
          ),

          // SizedBox(
          //   height: 40,
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     Stopwatch stopwatch = Stopwatch()..start();
          //     await dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
          //     stopwatch.stop();
          //     // print("SaveToSupabaseAndOrderSqlite trvalo: ${stopwatch.elapsedMilliseconds} ms");
          //   },
          //   child: Text("save to supabase"),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     Stopwatch stopwatch = Stopwatch()..start();
          //     await dbSupabase.deleteUserAccount();
          //     stopwatch.stop();
          //     // print("SaveToSupabaseAndOrderSqlite trvalo: ${stopwatch.elapsedMilliseconds} ms");
          //   },
          //   child: Text("delete user"),
          // ),

          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class HelpButton extends StatefulWidget {
  final String helpText;
  const HelpButton({Key? key, required this.helpText}) : super(key: key);

  @override
  _HelpButtonState createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton> {
  OverlayEntry? _overlayEntry;

  void _showHelpOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeHelpOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy - size.height - 60.0, // Text se zobrazí nad ikonou
        left: offset.dx - 220, // Text se zobrazí vlevo od ikony
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              widget.helpText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showHelpOverlay(context),
      onLongPressUp: _removeHelpOverlay,
      child: Icon(
        Icons.help_outline,
        color: Colors.white.withAlpha(100),
        size: 28,
      ),
    );
  }
}
