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
import '../widgets/loading_indicator.dart'; // Import indispensable pour tes états
import '../widgets/meal_card.dart';

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
                        builder: (context) => const FavoritesScreen(),
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
                  builder: (context) => const SettingsScreen(),
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

            // 1. UTILISATION DE LA MEALCARD POUR LE PLAT DU JOUR (PROPRE ET COMPACT)
            FutureBuilder<Meal>(
              future: _randomMealFuture,
              builder: (context, snapshot) {
                if (LoadingIndicator.checkState(snapshot)) {
                  return  SizedBox(
                    height: 140,
                    child: LoadingIndicator(
                      snapshot: snapshot,
                      loadingMessage: "Sélection du plat du jour...",
                    ),
                  );
                }

                final randomMeal = snapshot.data!;

                return SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: MealCard(meal: randomMeal),
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
                  if (LoadingIndicator.checkState(snapshot)) {
                    return LoadingIndicator(
                      snapshot: snapshot,
                      loadingMessage: "Chargement des catégories...",
                      emptyTitle: "Aucune catégorie",
                      emptyMessage: "Impossible de récupérer les catégories culinaires.",
                    );
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
                          splashColor: theme.colorScheme.primary.withAlpha(30),
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