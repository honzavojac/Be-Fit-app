// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Function delete;
  QuoteCard({required this.quote, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                quote.text,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                quote.author,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
              SizedBox(
                height: 2,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.delete),
                label: Text('data'),
              ),
            ],
          ),
        ));
  }
}
