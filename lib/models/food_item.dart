class FoodItem {
  final String name;
  final double energy;
  final double protein;
  final double fat;
  final double carbohydrates;

  FoodItem({
    required this.name,
    required this.energy,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['product_name'] ?? 'Unknown',
      energy: _parseDouble(json['nutriments']['energy_value']),
      protein: _parseDouble(json['nutriments']['proteins']),
      fat: _parseDouble(json['nutriments']['fat']),
      carbohydrates: _parseDouble(json['nutriments']['carbohydrates']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }
}
