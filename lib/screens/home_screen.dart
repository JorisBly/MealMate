import 'package:flutter/material.dart';
import 'package:mealmate/models/category.dart';
import 'package:mealmate/models/meal.dart';
import 'package:mealmate/providers/daily_provider.dart';
import 'package:mealmate/screens/category_screen.dart';
import 'package:mealmate/screens/favorites_screen.dart';
import 'package:mealmate/screens/search_results_screen.dart';
import 'package:mealmate/screens/meal_details_screen.dart';
import 'package:mealmate/screens/settings_screen.dart';
import 'package:mealmate/services/api_service.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchInput = "";

  final ApiService _apiService = ApiService();
  late Future<List<Category>> _categoriesFuture;
  late Future<Meal> _randomMealFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getCategories();
    _randomMealFuture = _initDailyMeal();
  }

  Future<Meal> _initDailyMeal() async {
    final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
    int attempts = 0;
    while (dailyProvider.getLastDailyMealId() == null &&
        dailyProvider.getLastDate() == null &&
        attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      attempts++;
    }
    final cachedId = dailyProvider.getLastDailyMealId();
    final today = DateTime.now().day;
    final lastDateStr = dailyProvider.getLastDate();

    if (cachedId != null && lastDateStr != null && lastDateStr.day == today) {
      return await _apiService.getMealById(cachedId);
    } else {
      final newRandomMeal = await _apiService.getRandomMeal();
      dailyProvider.saveDailyMeal(newRandomMeal.id);
      return newRandomMeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMate'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final count = favoritesProvider.favoritesCount();

              return Badge(
                label: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                isLabelVisible: count > 0,
                child: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            TextField(
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _searchInput = value.trim();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsScreen(searchQuery: _searchInput),
                    ),
                  );
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search for meals',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Découverte du jour",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            FutureBuilder<Meal>(
              future: _randomMealFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Impossible de charger la découverte du jour.");
                } else if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final randomMeal = snapshot.data!;

                return Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailsScreen(meal: randomMeal),
                        ),
                      );
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.network(
                              randomMeal.imageUrl,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    randomMeal.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (randomMeal.category != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      randomMeal.category!,
                                      style: TextStyle(color: theme.colorScheme.primary),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            Text(
              "Catégories",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

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
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => CategoryScreen(category: category),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                category.thumbnailUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                semanticLabel: category.name,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
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