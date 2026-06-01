import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:mealmate/models/category.dart';
import 'package:mealmate/models/meal.dart';
import 'package:mealmate/screens/category_screen.dart';
import 'package:mealmate/services/api_service.dart';
import 'package:mealmate/widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String _searchInput = "";

  final ApiService _apiService = ApiService();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MealMate'),
          actions:[
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SettingsScreen(),
                //   ),
                // );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SettingsScreen(),
                //   ),
                // );
              },
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                _searchInput = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search for meals',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }

                final categories = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Center(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => CategoryScreen(category: category),
                                  ),
                                );
                              },
                              child: Image(
                                image: NetworkImage(category.thumbnailUrl),
                                semanticLabel: category.name,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],),

                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),)
    );
  }

}