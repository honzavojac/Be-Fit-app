// const_variables.dart

import 'package:flutter/material.dart';

List<Map<String, String>> languages = [
  {'code': 'none', 'name': 'Undefined'},
  {'code': 'CS', 'name': 'Czech'},
  {'code': 'DE', 'name': 'German'},
  {'code': 'FR', 'name': 'French'},
  {'code': 'HU', 'name': 'Hungarian'},
  {'code': 'IT', 'name': 'Italian'},
  {'code': 'PL', 'name': 'Polish'},
  {'code': 'UA', 'name': 'Ukrainian'},
  {'code': 'EN', 'name': 'English (UK)'},
];

String? selectedCountry;
// bool? hasToOpenDropdown = false;
bool darkTheme = true;
List<Locale> locales = [
  Locale('cs'),
  Locale('en'),
  Locale('de'),
];
List<Widget> flags = [
  ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: Image.asset(
      'icons/flags/png100px/cz.png',
      package: 'country_icons',
      // height: 40,
      // width: 80,
      fit: BoxFit.cover, // Přizpůsobení obrázku rozměrům
    ),
  ),
  ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: Image.asset(
      'icons/flags/png100px/gb.png',
      package: 'country_icons',
      // height: 40,
      // width: 100,
      fit: BoxFit.cover, // Přizpůsobení obrázku rozměrům
    ),
  ),
  ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: Image.asset(
      'icons/flags/png100px/de.png',
      package: 'country_icons',
      // height: 40,
      // width: 80,
      fit: BoxFit.cover, // Přizpůsobení obrázku rozměrům
    ),
  ),
];
