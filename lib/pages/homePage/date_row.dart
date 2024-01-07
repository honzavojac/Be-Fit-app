import 'package:flutter/material.dart';

import 'home_page.dart';

class dateRow extends StatefulWidget {
  const dateRow({super.key});

  @override
  State<dateRow> createState() => _dateRowState();
}

class _dateRowState extends State<dateRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      //color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.amber,
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(80, 30),
            ),
          ),
          SizedBox(
            child: Container(
              //padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              //color: Colors.blue,
              child: Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // nutrition.incrementKcal();
            },
            child:
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.amber),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(80, 30),
            ),
          )
        ],
      ),
    );
  }
}
