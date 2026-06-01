import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import 'meal_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final favoriteMeals = context.watch<FavoritesProvider>().getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos favoris"),
      ),
      body: favoriteMeals.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Vous n'avez pas encore de favoris.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: favoriteMeals.length,
          itemBuilder: (context, index) {
            final meal = Meal.fromJson(favoriteMeals[index]);

            return Card(
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailsScreen(meal: meal),
                    ),
                  );
                },
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Image.network(
                          meal.imageUrl,
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
                                meal.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (meal.category != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  meal.category!,
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
      ),
    );
  }
}