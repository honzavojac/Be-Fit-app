import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';

import '../../providers/colors_provider.dart';

class NewMuscleBox extends StatefulWidget {
  final Function() notifyParent;
  const NewMuscleBox({
    Key? key,
    required this.notifyParent,
  }) : super(key: key);

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
    var dbSupabase = Provider.of<SupabaseProvider>(context);

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
                      style: TextStyle(color: ColorsProvider.color_1, fontSize: 20),
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
                      decoration: InputDecoration(
                        labelText: 'Name of Muscle:',
                        labelStyle: TextStyle(
                          color: ColorsProvider.color_1,
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
                    onPressed: () async {
                      dbSupabase.isCheckedList.add(false);
                      await dbSupabase.insertMuscle(textController.text.trim());
                      await dbSupabase.getAllMuscles();

                      widget.notifyParent();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsProvider.getColor2(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: ColorsProvider.getColor8(context),
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
