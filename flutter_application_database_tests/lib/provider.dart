import 'package:flutter/widgets.dart';

class CounterProvider extends ChangeNotifier {
  int value;
  CounterProvider({
    this.value = 0,
  });
  void incremmentValue() {
    value++;
    notifyListeners();
  }

  void decremmentValue() {
    value--;
    notifyListeners();
  }
}
