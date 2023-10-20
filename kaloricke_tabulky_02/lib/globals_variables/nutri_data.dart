import 'package:flutter/foundation.dart';

class NutritionIncremment extends ChangeNotifier {
  double _kcal = 0;
  int _protein = 0;
  int _carbs = 0;

  double get kcalData => _kcal;
  int get proteinData => _protein;
  int get carbsData => _carbs;

  void updateKcal(double newValue) {
    _kcal = newValue;
    notifyListeners(); // Aktualizuje widgety, které poslouchají tento model
  }

  void incrementKcal() {
    _kcal += 500;

    notifyListeners(); // Aktualizuje widgety, které poslouchají tento model
  }

  void incrementProtein() {
    _protein += 20;

    notifyListeners(); // Aktualizuje widgety, které poslouchají tento model
  }

  void incrementCarbs() {
    _carbs += 100;
    notifyListeners(); // Aktualizuje widgety, které poslouchají tento model
  }
}
