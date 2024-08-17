import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import '../../providers/colors_provider.dart';
import 'home_page.dart';

class dateRow extends StatefulWidget {
  final Function back;
  final Function forward;
  final Function onDateSelected;
  const dateRow({
    super.key,
    required this.back,
    required this.forward,
    required this.onDateSelected,
  });

  @override
  State<dateRow> createState() => _dateRowState();
}

class _dateRowState extends State<dateRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              widget.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorsProvider.color_2,
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(80, 30),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: 300, // Define a fixed width
                      height: 300, // Define a fixed height
                      child: DatePicker(
                        centerLeadingDate: true,
                        minDate: DateTime(2020),
                        maxDate: DateTime.now(),
                        initialDate: selectedDate,
                        selectedDate: selectedDate,
                        highlightColor: Colors.transparent,
                        splashRadius: 0,
                        onDateSelected: (value) {
                          widget.onDateSelected(value); // Close the dialog when a date is selected
                        },
                        currentDateDecoration: BoxDecoration(
                          border: Border.all(color: ColorsProvider.color_2),
                          shape: BoxShape.circle,
                        ),
                        daysOfTheWeekTextStyle: const TextStyle(color: ColorsProvider.color_2),
                        enabledCellsDecoration: const BoxDecoration(),
                        initialPickerType: PickerType.days,
                        leadingDateTextStyle: const TextStyle(color: ColorsProvider.color_2),
                        slidersColor: ColorsProvider.color_2,
                        slidersSize: 25,
                        selectedCellDecoration: BoxDecoration(
                          color: ColorsProvider.color_2,
                          shape: BoxShape.circle,
                        ),
                        selectedCellTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        disabledCellsDecoration: BoxDecoration(
                          color: Colors.transparent,
                          backgroundBlendMode: BlendMode.colorBurn,
                          shape: BoxShape.circle,
                        ),
                        currentDateTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        enabledCellsTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: 120,
              // height: 40,
              // color: Colors.blueAccent,
              child: Center(
                child: Text(
                  "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}",
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsProvider.color_2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.forward();
            },
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorsProvider.color_2,
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(80, 30),
            ),
          ),
        ],
      ),
    );
  }
}
