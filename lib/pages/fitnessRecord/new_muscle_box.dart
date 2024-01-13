import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMuscleBox extends StatefulWidget {
  const NewMuscleBox({Key? key}) : super(key: key);

  @override
  _NewMuscleBoxState createState() => _NewMuscleBoxState();
}

class _NewMuscleBoxState extends State<NewMuscleBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        height: 200,
        width: 220,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: Text(
                      "New Muscle",
                      style: TextStyle(color: Colors.amber[600], fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.amber,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(child: Container()),
                Container(
                  height: 80,
                  width: 220,
                  child: Center(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Name of Muscle:',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(255, 179, 0, 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 143, 0, 1),
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 143, 0, 1),
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        hintText: 'Enter value:',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(255, 179, 0, 1),
                          fontSize: 15,
                        ),
                      ),
                      onChanged: (input) {},
                    ),
                  ),
                ),
                Spacer(),
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
                      'Save',
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
          ],
        ),
      ),
    );
  }
}
