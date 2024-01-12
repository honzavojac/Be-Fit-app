import 'package:flutter/material.dart';

class AddMuscleBox extends StatefulWidget {
  const AddMuscleBox({Key? key}) : super(key: key);

  @override
  _AddMuscleBoxState createState() => _AddMuscleBoxState();
}

class _AddMuscleBoxState extends State<AddMuscleBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: Colors.blue[800],
        ),
        height: 300,
        width: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Text("data"),
                            ),
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Add Muscle',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black, // Barva ikony
                  size: 30, // Velikost ikony
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.zero), // Nulování odsazení
                ),
                constraints: BoxConstraints.tightFor(
                    width: 30, height: 30), // Velikost tlačítka
              ),
            ),
          ],
        ),
      ),
    );
  }
}
