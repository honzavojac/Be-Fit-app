// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class FoodAddAppBar extends StatelessWidget {
  const FoodAddAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Přidání potraviny'),
    );
  }
}

class FoodAddcreen extends StatelessWidget {
  const FoodAddcreen({super.key});

  @override
  Widget build(BuildContext context) {
    String textFood;
    double numberProtein;
    double numberCarbs;
    double numberFats;
    double numberFiber;
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 250,
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                  r'[A-Za-z]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
              LengthLimitingTextInputFormatter(15)
            ],
            decoration: const InputDecoration(
              labelText: 'Food',
              hintText:
                  'Enter name of food:', // zobrazí se pokud je textové pole prázdné
              //  icon: Icon(Icons.text_fields), //
            ),
            onChanged: (input) {
              textFood = input;
              print('Text changed to: $textFood');
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                  LengthLimitingTextInputFormatter(
                      4) //omezí kolik znaků je možno zadat
                ],
                decoration: const InputDecoration(
                  labelText: 'Protein',
                  hintText:
                      'Enter value:', // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                ),
                onChanged: (input) {
                  numberProtein = double.parse(input);
                  print('Text changed to: $numberProtein');
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'[0-9]')), // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: const InputDecoration(
                  labelText: 'Carbs',
                  hintText:
                      'Enter value:', // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                ),
                onChanged: (input) {
                  numberCarbs = double.parse(input);
                  print('Text changed to: $numberCarbs');
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                  labelText: 'Fats',
                  hintText:
                      'Enter value:', // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                ),
                onChanged: (input) {
                  numberFats = double.parse(input);
                  print('Text changed to: $numberFats');
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(
                      4) // povoluje zadat pouze číselnou hodnotu => použiju pro vyhledávání v databázi
                ],
                decoration: const InputDecoration(
                  labelText: 'Fiber',
                  hintText:
                      'Enter value:', // zobrazí se pokud je textové pole prázdné
                  //  icon: Icon(Icons.text_fields), //
                ),
                onChanged: (input) {
                  numberFiber = double.parse(input);
                  print('Text changed to: $numberFiber');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
