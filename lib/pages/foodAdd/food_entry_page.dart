import 'package:flutter/material.dart';
import 'package:kaloricke_tabulky_02/models/food_item.dart';
import 'package:kaloricke_tabulky_02/providers/colors_provider.dart';
import 'package:kaloricke_tabulky_02/pages/foodAdd/newFood/food_add_page.dart';
import 'package:kaloricke_tabulky_02/services_open_food_api/food_service.dart';

DateTime now = DateTime.now();
String formattedDate = "${now.day}.${now.month}.${now.year}";

class FoodRecordAppBar extends StatelessWidget {
  const FoodRecordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 35,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodNewScreen()),
                );
              },
              icon: Icon(Icons.add_circle_outline_sharp),
              label: Text('New food'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ColorsProvider.color_2),
                foregroundColor: MaterialStateProperty.all(ColorsProvider.color_8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String selected = 'g';

class FoodRecordScreen extends StatefulWidget {
  @override
  _FoodRecordScreenState createState() => _FoodRecordScreenState();
}

class _FoodRecordScreenState extends State<FoodRecordScreen> {
  final TextEditingController _controller = TextEditingController();
  final FoodService _foodService = FoodService();
  List<FoodItem> _foodItems = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchFoods(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final foodItems = await _foodService.fetchFoods(query);
      setState(() {
        _foodItems = foodItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load food items: $e'; // Zobrazíme konkrétní chybu
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Food Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchFoods(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text(_errorMessage))
            else if (_foodItems.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _foodItems.length,
                  itemBuilder: (context, index) {
                    final foodItem = _foodItems[index];
                    return ListTile(
                      title: Text(foodItem.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Energy: ${foodItem.energy} kcal'),
                          Text('Protein: ${foodItem.protein} g'),
                          Text('Fat: ${foodItem.fat} g'),
                          Text('Carbohydrates: ${foodItem.carbohydrates} g'),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
