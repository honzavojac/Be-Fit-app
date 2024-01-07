import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int page = 1;
  setPage(var number) {
    this.page = number;
    notifyListeners();
  }
}
