import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodService {
  static const String _baseUrl = 'https://world.openfoodfacts.org';

  Future<List<FoodItem>> fetchFoods(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List products = json['products'];
      return products.map((productJson) => FoodItem.fromJson(productJson)).toList();
    } else {
      throw Exception('Failed to load food items: ${response.body}');
    }
  }
}
