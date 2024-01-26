import 'package:flutter/material.dart';

class VitaminsBox extends StatefulWidget {
  const VitaminsBox({super.key});

  @override
  State<VitaminsBox> createState() => _VitaminsBoxState();
}

bool isChecked_A = false;
bool isChecked_B1 = false;
bool isChecked_B2 = false;
bool isChecked_B3 = false;
bool isChecked_B4 = false;
bool isChecked_B5 = false;
bool isChecked_B6 = false;
bool isChecked_B7 = false;
bool isChecked_B9 = false;
bool isChecked_B12 = false;
bool isChecked_C = false;
bool isChecked_D = false;
bool isChecked_E = false;
bool isChecked_K = false;

class _VitaminsBoxState extends State<VitaminsBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text('A', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ), // Rounded Checkbox
                    value: isChecked_A,
                    onChanged: (inputValue) {
                      setState(
                        () {
                          isChecked_A = inputValue!;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B1', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B1,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B1 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B2', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B2,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B2 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B3', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B3,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B3 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text('B4', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B4,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B4 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B5', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B5,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B5 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B6', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B6,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B6 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B7', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B7,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B7 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text('B9', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B9,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B9 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('B12', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_B12,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_B12 = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('C', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_C,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_C = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('D', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_D,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_D = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text('E', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_E,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_E = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('K', style: TextStyle(fontSize: 20)),
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0))), // Rounded Checkbox
                    value: isChecked_K,
                    onChanged: (inputValue) {
                      setState(() {
                        isChecked_K = inputValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
