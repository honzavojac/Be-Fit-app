import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/data_classes.dart';
import 'package:kaloricke_tabulky_02/pages/fitnessRecord/new_muscle_box.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/supabase/supabase.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddSplitBox extends StatefulWidget {
  final Function() notifyParent;
  const AddSplitBox({
    Key? key,
    required this.notifyParent,
  }) : super(key: key);

  @override
  _AddSplitBoxState createState() => _AddSplitBoxState();
}

class _AddSplitBoxState extends State<AddSplitBox> {
  var _textController = TextEditingController();

  List<Muscle> muscles = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    await dbSupabase.getAllMuscles();
    muscles = dbSupabase.muscles;
    // dbSupabase.isCheckedList = List.generate(dbSupabase.muscles.length, (index) => false);
    if (dbSupabase.splitText != null) {
      _textController.text = dbSupabase.setTextController();
    } else {
      dbSupabase.clearTextController();
    }
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dbSupabase = Provider.of<SupabaseProvider>(context);
    loadData();
    muscles = dbSupabase.muscles;
    isCheckedList = dbSupabase.isCheckedList;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ColorsProvider.color_7,
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
                      Container(
                        height: 50,
                        // color: ColorsProvider.color_8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Name of Split:',
                              labelStyle: TextStyle(
                                color: ColorsProvider.color_1,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.color_2,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorsProvider.color_2,
                                  width: 3.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 15,
                              ),
                              hintText: 'Enter name of split:',
                              hintStyle: TextStyle(
                                color: ColorsProvider.color_1,
                                fontSize: 15,
                              ),
                            ),
                            controller: _textController,
                            onChanged: (value) {
                              dbSupabase.splitText = _textController.text.trim();
                              print(_textController.text.trim());
                            },
                            style: TextStyle(color: ColorsProvider.color_1),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: dbSupabase.muscles.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dbSupabase.muscles[index].nameOfMuscle!,
                                      ),
                                    ),
                                    Checkbox(
                                      value: isCheckedList[index],
                                      onChanged: (value) {
                                        isCheckedList[index] = value ?? false;
                                        print(isCheckedList);
                                        print(_textController.text.trim());

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      if (_textController.text.trim().isNotEmpty) {
                        dbSupabase.inserted = 0;
                        for (var i = 0; i < isCheckedList.length; i++) {
                          if (isCheckedList[i] == true) {
                            int idMuscle = dbSupabase.muscles[i].idMuscle!.toInt();
                            await dbSupabase.insertSplit('${_textController.text.trim()}', idMuscle);
                          }
                        }
                        await dbSupabase.getFitness();
                        widget.notifyParent();
                        // setState(() {});
                        Navigator.of(context).pop();
                      } else {
                        // ignore: unused_local_variable
                        AnimationController localAnimationController;

                        showTopSnackBar(
                          Overlay.of(context),

                          animationDuration: Duration(milliseconds: 1500),
                          Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, right: 25),
                              child: CustomSnackBar.error(
                                message: "Name of split is empty",
                              ),
                            ),
                          ),
                          // persistent: true,
                          onAnimationControllerInit: (controller) => localAnimationController = controller,
                          displayDuration: Duration(microseconds: 750),
                          dismissType: DismissType.onSwipe,
                          dismissDirection: [DismissDirection.endToStart],
                          reverseAnimationDuration: Duration(milliseconds: 250),
                          onTap: () {},
                        );
                      }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 150,
                    height: 35,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          ColorsProvider.color_2,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: NewMuscleBox(
                                notifyParent: refresh,
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "New Muscle",
                        style: TextStyle(color: ColorsProvider.color_8),
                      ),
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
          ],
        ),
      ),
    );
  }
}
