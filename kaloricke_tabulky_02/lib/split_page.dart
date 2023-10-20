import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitPage extends StatelessWidget {
  const SplitPage();

  @override
  Widget build(BuildContext context) {
    // Zde můžete definovat obsah vaší stránky nebo widgetu
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your split'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue,
            ),
            Container(
              margin: EdgeInsets.all(40),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  LengthLimitingTextInputFormatter(5),
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                //cursorHeight: 20.0,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  //  border: InputBorder.none,
                  labelText: 'Category 1',
                  labelStyle: TextStyle(color: Colors.amber),
                  // hintText: 'Enter value:',
                  hintStyle: TextStyle(fontSize: 15),
                ),
                onChanged: (input) {},
              ),
            ),
          ],
        ));
  }
}
