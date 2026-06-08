import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/meal_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, required this.searchQuery});

  final String searchQuery;
  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Meal>> _searchResultsFuture;

  @override
  void initState() {
    super.initState();
    _searchResultsFuture = _apiService.searchMeals(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats pour "${widget.searchQuery}"'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _searchResultsFuture,
        builder: (context, snapshot) {
          if (LoadingIndicator.checkState(snapshot)) {
            return LoadingIndicator(
              snapshot: snapshot,
              loadingMessage: "Recherche en cours...",
              emptyTitle: "Aucun résultat",
              emptyMessage: "Nous n'avons trouvé aucun plat correspondant à votre recherche.",
            );
          }

          final meals = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: meals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return MealCard(meal: meals[index]);
              },
            ),
          );
        },
      ),
    );
  }
}