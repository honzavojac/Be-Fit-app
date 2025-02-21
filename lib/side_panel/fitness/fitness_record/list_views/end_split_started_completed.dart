import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloricke_tabulky_02/bloc/fitness_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/fitness_event.dart';
import '../../../../providers/colors_provider.dart';

import 'package:easy_localization/easy_localization.dart';

Widget endSplitStartedCompleted(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(55, 8, 55, 5),
            child: Container(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm End Entry'),
                        content: Text('Do you really want to end the entry?'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //no
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: ColorsProvider.getColor2(context),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: ColorsProvider.getColor8(context), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //yes
                                  context.read<FitnessBloc>().add(UpdateSplitStartedCompletedBloc(null, true));
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  // padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                  decoration: BoxDecoration(
                                    color: ColorsProvider.color_9,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(ColorsProvider.color_5),
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Aby se řádek smrskl na minimální možnou šířku
                  children: [
                    Text(
                      "end_this_split".tr(),
                      style: TextStyle(color: ColorsProvider.color_3, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8), // Oddělovač mezi textem a ikonou
                    Icon(
                      Icons.check_circle_outline,
                      // Icons.pause,
                      color: ColorsProvider.color_3,
                    ), // Ikonu umístíme na konec
                  ],
                ),
              ),
            ),
          ),
        ),
        // Container(
        //   height: 35,
        //   child: ElevatedButton.icon(
        //     onPressed: () async {
        //       await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SplitPage(
        //             notifyParent: widget.refresh,
        //           ),
        //         ),
        //       );
        //       widget.refresh();
        //     },
        //     icon: Icon(Icons.edit_outlined),
        //     label: Text(
        //       'Edit split',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     style: ButtonStyle(
        //       backgroundColor: WidgetStateProperty.all(ColorsProvider.getColor2(context)),
        //       foregroundColor: WidgetStateProperty.all(ColorsProvider.getColor8(context)),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: 10,
        // ),
      ],
    ),
  );
}
