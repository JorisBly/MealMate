import 'package:empty_view/empty_view.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';
import 'meal_details_screen.dart';
import '../widgets/meal_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = _apiService.getMealsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (LoadingIndicator.checkState(snapshot)) {
            return LoadingIndicator(
              snapshot: snapshot,
              loadingMessage: "Récupération des données...",
              emptyTitle: "Catégorie vide",
              emptyMessage: "Aucun plat trouvé pour cette catégorie.",
            );
          }

          final categoryMeals = snapshot.data!;

          if (categoryMeals.isEmpty) {
            return EmptyViewPresets.noData(
                title: "Aucune recette",
                description: "Aucune recette disponible dans cette catégorie.",
                buttonText: "Retour",
                onRefresh: () => Navigator.of(context).pop(),
              );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: categoryMeals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final meal = categoryMeals[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailsScreen(meal: meal),
                      ),
                    );
                  },
                  child: MealCard(
                    meal: meal,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}