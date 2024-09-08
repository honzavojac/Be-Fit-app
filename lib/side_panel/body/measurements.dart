import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/database/fitness_database.dart';
import 'package:kaloricke_tabulky_02/init_page.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MeasurementsWidget extends StatefulWidget {
  const MeasurementsWidget({super.key});

  @override
  State<MeasurementsWidget> createState() => _MeasurementsWidgetState();
}

class _MeasurementsWidgetState extends State<MeasurementsWidget> {
  TextEditingController weightTextEditingController = TextEditingController();
  TextEditingController heightTextEditingController = TextEditingController();
  TextEditingController abdominalCircumferenceTextEditingController = TextEditingController();
  TextEditingController chestCircumferenceTextEditingController = TextEditingController();
  TextEditingController waistCircumferenceTextEditingController = TextEditingController();
  TextEditingController thighCircumferenceTextEditingController = TextEditingController();
  TextEditingController neckCircumferenceTextEditingController = TextEditingController();
  TextEditingController bicepsCircumferenceTextEditingController = TextEditingController();

  double? weight;
  int? height;
  double? abdominalCircumference;
  double? chestCircumference;
  double? waistCircumference;
  double? thighCircumference;
  double? neckCircumference;
  double? bicepsCircumference;

  List<Measurements> measurements = [];
  bool show = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
    measurements = await dbFitness.SelectMeasurements();
    measurements.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );
    show = true;
    setState(() {});
  }

  Future<bool> processMeasurements() async {
    var dbFitness = Provider.of<FitnessProvider>(context, listen: false);

    DateTime dateTime = DateTime.now();
    String now = dateTime.toString().replaceRange(10, null, "");

    try {
      // Získání textu z textových polí
      String weightText = weightTextEditingController.text.trim().replaceAll(',', '.');
      String heightText = heightTextEditingController.text.trim().replaceAll(',', '.');
      String abdominalCircumferenceText = abdominalCircumferenceTextEditingController.text.trim().replaceAll(',', '.');
      String chestCircumferenceText = chestCircumferenceTextEditingController.text.trim().replaceAll(',', '.');
      String waistCircumferenceText = waistCircumferenceTextEditingController.text.trim().replaceAll(',', '.');
      String thighCircumferenceText = thighCircumferenceTextEditingController.text.trim().replaceAll(',', '.');
      String neckCircumferenceText = neckCircumferenceTextEditingController.text.trim().replaceAll(',', '.');
      String bicepsCircumferenceText = bicepsCircumferenceTextEditingController.text.trim().replaceAll(',', '.');

      // Kontrola a převod textu na číslo, pokud text není prázdný
      weight = weightText.isNotEmpty ? double.tryParse(weightText) : null;
      height = heightText.isNotEmpty ? int.tryParse(heightText) : null;
      abdominalCircumference = abdominalCircumferenceText.isNotEmpty ? double.tryParse(abdominalCircumferenceText) : null;
      chestCircumference = chestCircumferenceText.isNotEmpty ? double.tryParse(chestCircumferenceText) : null;
      waistCircumference = waistCircumferenceText.isNotEmpty ? double.tryParse(waistCircumferenceText) : null;
      thighCircumference = thighCircumferenceText.isNotEmpty ? double.tryParse(thighCircumferenceText) : null;
      neckCircumference = neckCircumferenceText.isNotEmpty ? double.tryParse(neckCircumferenceText) : null;
      bicepsCircumference = bicepsCircumferenceText.isNotEmpty ? double.tryParse(bicepsCircumferenceText) : null;

      // Podmínka, která zabrání vložení, pokud jsou všechny hodnoty prázdné nebo null
      if (weight == null && height == null && abdominalCircumference == null && chestCircumference == null && waistCircumference == null && thighCircumference == null && neckCircumference == null && bicepsCircumference == null) {
        print('Žádné měření nebylo zadáno. Vložení do databáze bylo zrušeno.');
        return false; // Žádné hodnoty k uložení
      }

      // Vytvoření instance Measurements
      Measurements measurements = Measurements(
        createdAt: now,
        weight: weight,
        height: height,
        abdominalCircumference: abdominalCircumference,
        chestCircumference: chestCircumference,
        waistCircumference: waistCircumference,
        thighCircumference: thighCircumference,
        neckCircumference: neckCircumference,
        bicepsCircumference: bicepsCircumference,
      );

      // Pokus o vložení měření do databáze
      try {
        await dbFitness.insertMeasurements(measurements, 1);
        loadData();
        return true; // Úspěšně uloženo
      } on Exception catch (e) {
        print("Stala se chyba při vkládání hodnot do sqflite databáze, chyba: $e");
        return false; // Chyba při ukládání
      }
    } catch (e) {
      // Zpracování chyb
      print('Chyba při zpracování dat: $e');
      return false; // Chyba při zpracování
    }
  }

  @override
  Widget build(BuildContext context) {
    final _sheet = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "measurement".tr(),
          style: TextStyle(color: ColorsProvider.getColor2(context), fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          show == true
              ? Container(
                  // color: Colors.blue.shade900,
                  child: ListView(
                    children: [
                      Column(
                        key: keyButton1,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextFieldWidget("Weight", weightTextEditingController),
                              TextFieldWidget("Height", heightTextEditingController),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 40,
                            child: Center(
                              child: Text(
                                "circumference".tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: ColorsProvider.getColor2(context),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFieldWidget("Abdominal", abdominalCircumferenceTextEditingController),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget("Chest", chestCircumferenceTextEditingController),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget("Waist", waistCircumferenceTextEditingController),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget("Thingh", thighCircumferenceTextEditingController),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget("Neck", neckCircumferenceTextEditingController),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldWidget("Biceps", bicepsCircumferenceTextEditingController),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            var dbFitness = Provider.of<FitnessProvider>(context, listen: false);
                            var dbSupabase = Provider.of<SupabaseProvider>(context, listen: false);

                            bool success = await processMeasurements();
                            AnimationController localAnimationController;
                            if (success) {
                              showTopSnackBar(
                                Overlay.of(context),

                                animationDuration: Duration(milliseconds: 1500),
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25, right: 25),
                                    child: CustomSnackBar.success(
                                      message: "success_insert_body_measurement".tr(),
                                    ),
                                  ),
                                ),
                                // persistent: true,
                                onAnimationControllerInit: (controller) => localAnimationController = controller,
                                displayDuration: Duration(microseconds: 750),
                                dismissType: DismissType.onSwipe,
                                dismissDirection: [DismissDirection.endToStart],
                                reverseAnimationDuration: Duration(milliseconds: 250),
                              );
                              weightTextEditingController.clear();
                              weightTextEditingController.clear();
                              heightTextEditingController.clear();
                              abdominalCircumferenceTextEditingController.clear();
                              chestCircumferenceTextEditingController.clear();
                              waistCircumferenceTextEditingController.clear();
                              thighCircumferenceTextEditingController.clear();
                              neckCircumferenceTextEditingController.clear();
                              bicepsCircumferenceTextEditingController.clear();
                              await dbFitness.SaveToSupabaseAndOrderSqlite(dbSupabase);
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),

                                animationDuration: Duration(milliseconds: 1500),
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25, right: 25),
                                    child: CustomSnackBar.error(
                                      message: "error_all_boxes_are_empty".tr(),
                                    ),
                                  ),
                                ),
                                // persistent: true,
                                onAnimationControllerInit: (controller) => localAnimationController = controller,
                                displayDuration: Duration(microseconds: 750),
                                dismissType: DismissType.onSwipe,
                                dismissDirection: [DismissDirection.endToStart],
                                reverseAnimationDuration: Duration(milliseconds: 250),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Container(
                              width: 170,
                              height: 50,
                              decoration: BoxDecoration(
                                color: ColorsProvider.getColor2(context),
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "save".tr(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsProvider.getColor8(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              : Container(
                  // color: Colors.blue,
                  ),
          DraggableScrollableSheet(
            key: _sheet,
            // shouldCloseOnMinExtent: false,
            initialChildSize: 0.1,
            maxChildSize: 0.6,
            minChildSize: 0.1, snapAnimationDuration: Duration(milliseconds: 100),
            expand: true,
            snap: false,
            snapSizes: [
              0.1,
              0.6,
            ],
            // snapAnimationDuration: Duration(milliseconds: 100),
            // controller: _controller,
            builder: (context, scrollController) {
              return Stack(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(123, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: 90,
                            // color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'swipe_up'.tr(),
                                    style: TextStyle(
                                      color: ColorsProvider.getColor2(context),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_upward_rounded,
                                    size: 25,
                                    color: ColorsProvider.getColor2(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: measurements.length,
                            (BuildContext context, int index) {
                              var measurement = measurements[index];
                              String now = "${measurement.createdAt!.replaceRange(0, 8, "")}.${measurement.createdAt!.replaceRange(0, 5, "").replaceRange(2, null, "")}.${measurement.createdAt!.replaceRange(4, null, "")}";
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsProvider.getColor2(context),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${now}",
                                              style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold, fontSize: 20),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(color: Color.fromARGB(135, 0, 0, 0), borderRadius: BorderRadius.circular(12)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                  child: Container(
                                                    width: 105,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "${"weight".tr()}: ${measurement.weight ?? ""}",
                                                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                        ),
                                                        Text(
                                                          "${"height".tr()}: ${measurement.height ?? ""}",
                                                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "circumference".tr(),
                                                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                                        )
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                            child: Container(
                                                              width: 150,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "${"abdominal".tr()}: ${measurement.abdominalCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    "${"chest".tr()}: ${measurement.chestCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    "${"waist".tr()}: ${measurement.waistCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5, right: 2, bottom: 2),
                                                            child: Container(
                                                              width: 100,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "${"thigh".tr()}: ${measurement.thighCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    "${"neck".tr()}: ${measurement.neckCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    "${"biceps".tr()}: ${measurement.bicepsCircumference ?? ""}",
                                                                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 15,
                  //   left: 0,
                  //   right: 20,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () async {
                  //           setState(() {});
                  //         },
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             // borderRadius: BorderRadius.circular(50),
                  //             shape: BoxShape.circle,
                  //             color: ColorsProvider.getColor8(context),
                  //           ),
                  //           child: Icon(
                  //             Icons.add_circle_outline_outlined,
                  //             color: ColorsProvider.getColor2(context),
                  //             size: 50,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget TextFieldWidget(String category, TextEditingController textEditingController) {
    String text = category.toLowerCase().tr();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          category == "Neck"
              ? "$text:  "
              : category != "Biceps"
                  ? "$text: "
                  : "$text:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: ColorsProvider.getColor2(context),
          ),
        ),
        category == "Weight" || category == "Height"
            ? SizedBox(
                width: 10,
              )
            : category == "Abdominal"
                ? SizedBox(
                    width: 10,
                  )
                : SizedBox(
                    width: 30,
                  ),
        Container(
          height: 50,
          width: 90,
          child: Center(
            child: TextField(
              controller: textEditingController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                category == "Weight"
                    ? CustomTextInputFormatter(category: category)
                    : category == "Height"
                        ? FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,3}'),
                          )
                        : CustomTextInputFormatter(category: category),
              ],
              decoration: InputDecoration(
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
                    width: 2.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 15,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  final String category;
  CustomTextInputFormatter({required this.category});
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Získání nového textu
    String newText = newValue.text;
    if (category == "Weight") {
      // Pokud je nový text prázdný, vrátíme zpět hodnotu
      if (newText.isEmpty) {
        return newValue;
      }

      // Kontrola, zda je první znak nula nebo tečka
      if (newText[0] == '0' || newText[0] == '.') {
        return TextEditingValue(text: "");
      }

      // Rozdělení textu podle tečky
      List<String> parts = newText.split('.');

      // Pokud je teček víc než jedna, vrátí zpět starou hodnotu
      if (parts.length > 2) {
        return oldValue;
      }

      // Kontrola délky části před tečkou
      String beforeDot = parts[0];
      if (beforeDot.length > 3) {
        beforeDot = beforeDot.substring(0, 3);
        return oldValue = TextEditingValue(text: "$beforeDot");
      }

      // Kontrola, zda tečka je povolena (po dvou číslech)
      if (beforeDot.length < 2 && newText.contains('.')) {
        return oldValue;
      }

      // Kontrola délky za tečkou
      if (parts.length == 2) {
        if (parts[1].length > 2) {
          newText = '${parts[0]}.${parts[1].substring(0, 2)}';
        }
      }

      // Vrátí novou hodnotu s upraveným textem
      return newValue.copyWith(
        text: newText,
        selection: newValue.selection.copyWith(
          baseOffset: newText.length,
          extentOffset: newText.length,
        ),
      );
    } else {
      if (newText.isEmpty) {
        return newValue;
      }

      // Kontrola, zda je první znak nula nebo tečka
      if (newText[0] == '0' || newText[0] == '.') {
        return TextEditingValue(text: "");
      }

      // Rozdělení textu podle tečky
      List<String> parts = newText.split('.');

      // Pokud je teček víc než jedna, vrátí zpět starou hodnotu
      if (parts.length > 2) {
        return oldValue;
      }

      // Kontrola délky části před tečkou
      String beforeDot = parts[0];
      if (beforeDot.length > 3) {
        beforeDot = beforeDot.substring(0, 3);
        return oldValue = TextEditingValue(text: "$beforeDot");
      }

      // Kontrola, zda tečka je povolena (po dvou číslech)
      if (beforeDot.length < 1 && newText.contains('.')) {
        return oldValue;
      }

      // Kontrola délky za tečkou
      if (parts.length == 2) {
        if (parts[1].length > 1) {
          newText = '${parts[0]}.${parts[1].substring(0, 1)}';
        }
      }

      // Vrátí novou hodnotu s upraveným textem
      return newValue.copyWith(
        text: newText,
        selection: newValue.selection.copyWith(
          baseOffset: newText.length,
          extentOffset: newText.length,
        ),
      );
    }
  }
}
