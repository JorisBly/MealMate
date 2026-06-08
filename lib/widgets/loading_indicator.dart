// lib/widgets/loading_indicator.dart
import 'package:empty_view/empty_view.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final String? loadingMessage;

  final String? emptyTitle;
  final String? emptyMessage;

  final VoidCallback? onRetry;

  const LoadingIndicator({
    super.key,
    required this.snapshot,
    this.loadingMessage,
    this.emptyTitle,
    this.emptyMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return EmptyViewPresets.noInternet(
        title: "Erreur de connexion",
        description: "Impossible de joindre le serveur. Vérifie ton réseau.",
      );
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      final theme = Theme.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (loadingMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                loadingMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    final data = snapshot.data;
    if (data == null || (data is List && data.isEmpty)) {
      return EmptyViewPresets.noData(
        title: emptyTitle ?? "Aucun résultat",
        description: emptyMessage ?? "Aucune recette trouvée",
        buttonText: "Retour",
        onRefresh: () => Navigator.of(context).pop(),
      );
    }

    return const SizedBox.shrink();
  }

  static bool checkState(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
      return true;
    }

    final data = snapshot.data;
    if (data == null || (data is List && data.isEmpty)) {
      return true;
    }

    return false;
  }
}