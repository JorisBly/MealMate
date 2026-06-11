import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // 1. IMPORT DU PACKAGE

import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<Meal> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = _apiService.getMealById(widget.meal.id);
  }

  Future<void> _launchVideo(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir la vidéo.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meal = widget.meal;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        elevation: 0,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final isFavorite = favoritesProvider.isFavorite(meal);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: isFavorite ? Colors.red : null,
                tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                onPressed: () {
                  if (isFavorite) {
                    favoritesProvider.removeFromFavorite(meal);
                  } else {
                    favoritesProvider.addToFavorite(meal);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (LoadingIndicator.checkState(snapshot)) {
            return LoadingIndicator(
              snapshot: snapshot,
              loadingMessage: "Récupération des données...",
              emptyTitle: "Aucun détail",
              emptyMessage: "Aucun détail disponible pour cette recette.",
            );
          }

          final meal = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: meal.id,
                  child: Image.network(
                    meal.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          if (meal.category != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                meal.category!,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (meal.country != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: theme.colorScheme.onSecondaryContainer,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    meal.country!,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const Divider(height: 32),

                      if (meal.ingredients != null && meal.ingredients!.isNotEmpty) ...[
                        _buildSectionTitle(context, "Ingrédients"),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 0,
                          color: theme.colorScheme.surfaceContainerLow,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: meal.ingredients!.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 20,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          meal.ingredients![index],
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (meal.urlSource != null && meal.urlSource!.isNotEmpty) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0000),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _launchVideo(meal.urlSource!, context),
                            icon: const Icon(Icons.play_circle_fill_rounded),
                            label: const Text(
                              "Voir la vidéo de la recette",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      _buildSectionTitle(context, "Instructions"),
                      const SizedBox(height: 12),
                      Text(
                        meal.instruction,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}