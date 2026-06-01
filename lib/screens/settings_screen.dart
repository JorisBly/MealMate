import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // État local temporaire pour le Toggle

  // Fonction pour afficher la boîte de dialogue de confirmation (AlertDialog)
  void _showClearFavoritesDialog(BuildContext context, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Attention'),
            ],
          ),
          content: const Text(
            'Voulez-vous vraiment supprimer toutes les recettes de vos favoris ? Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Ferme l'AlertDialog sans rien faire
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                provider.clearFavorites();
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tous les favoris ont été effacés.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Effacer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- SECTION 1 : THÈME ---
          Text(
            'Affichage',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Activer le thème sombre sur toute l\'application'),
              secondary: const Icon(Icons.brightness_6),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
                // TODO: Relier au StorageService et à un ThemeProvider pour la persistance globale
              },
            ),
          ),
          const SizedBox(height: 24),

          // --- SECTION 2 : DONNÉES (Action destructive) ---
          Text(
            'Données',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Effacer tous mes favoris', style: TextStyle(color: Colors.red)),
              subtitle: Text('${favoritesProvider.favoritesCount()} recette(s) enregistrée(s)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showClearFavoritesDialog(context, favoritesProvider),
            ),
          ),
          const SizedBox(height: 24),

          // --- SECTION 3 : À PROPOS ---
          Text(
            'À propos',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Nom de l\'application', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('MealMate'),
                    ],
                  ),
                  const Divider(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Version', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('1.0.0'),
                    ],
                  ),
                  const Divider(height: 24),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Source des données', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        'Cette application utilise l\'API publique et gratuite de TheMealDB pour récupérer l\'ensemble de ses recettes de cuisine.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}