import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaloricke_tabulky_02/colors_provider.dart';
import 'package:kaloricke_tabulky_02/firestore/firestore.dart';
import 'package:provider/provider.dart';

class NewMuscleBox extends StatefulWidget {
  const NewMuscleBox({Key? key}) : super(key: key);

  @override
  _NewMuscleBoxState createState() => _NewMuscleBoxState();
}

class _NewMuscleBoxState extends State<NewMuscleBox> {
  var textController = TextEditingController();
  @override
  void initState() {
    textController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dbFirebase = Provider.of<FirestoreService>(context);

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
                      style: TextStyle(
                          color: ColorsProvider.color_1, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorsProvider.color_9,
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
                          color: ColorsProvider.color_1,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.color_2,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: ColorsProvider.color_2,
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        hintText: 'Enter name of muscle:',
                        hintStyle: TextStyle(
                          color: ColorsProvider.color_1,
                          fontSize: 15,
                        ),
                      ),
                      controller: textController,
                      style: TextStyle(color: ColorsProvider.color_1),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() async {
                        Navigator.of(context).pop();
                        dbFirebase.isCheckedList.add(false);
                        await dbFirebase.addMuscle(textController.text.trim());
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsProvider.color_2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorsProvider.color_8,
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
