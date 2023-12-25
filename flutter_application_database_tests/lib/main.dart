import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: FutureBuilder(
            future: DBHelper().a(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Item ${data[index]['id']} - ${data[index]['description']}'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
  