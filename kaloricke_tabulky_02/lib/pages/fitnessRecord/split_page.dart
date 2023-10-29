import 'package:flutter/material.dart';
import 'dart:io';

class SplitPage extends StatefulWidget {
  const SplitPage();

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  List<Tab> tabs = [];

  @override
  void initState() {
    super.initState();
    tabs = loadTabsFromFile();
  }

  void addTab() {
    setState(() {
      tabs.add(Tab(
        child: Text('New Tab'),
      ));
      saveTabsToFile(tabs);
    });
  }

  void saveTabsToFile(List<Tab> tabs) async {
    final file = File('tabs.txt');
    final tabNames = tabs.map((tab) => tab.child.toString()).toList();
    await file.writeAsString(tabNames.join('\n'));
  }

  List<Tab> loadTabsFromFile() {
    final file = File('tabs.txt');
    if (!file.existsSync()) {
      return [];
    }

    final tabNames = file.readAsStringSync().split('\n');
    final tabs = tabNames.map((name) => Tab(child: Text(name))).toList();
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit your split'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addTab();
              },
            ),
          ],
          bottom: TabBar(
            tabs: tabs,

            indicatorColor: Colors.amber,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.amber,
            isScrollable: true,
            //labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
            //overlayColor: MaterialStatePropertyAll(Colors.black),
            // unselectedLabelColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SplitPage(),
    ),
  );
}
