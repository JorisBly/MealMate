import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Une erreur est survenue lors de la recherche.',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun résultat trouvé pour "${widget.searchQuery}".',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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