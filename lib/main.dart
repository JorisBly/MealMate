import 'package:flutter/material.dart';
import 'package:mealmate/providers/favorites_provider.dart';
import 'package:mealmate/providers/theme_provider.dart';
import 'package:mealmate/screens/home_screen.dart';
import 'package:mealmate/services/storage_service.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoritesProvider(StorageService.init())),
          ChangeNotifierProvider(create: (_) => ThemeProvider(StorageService.init())),
        ],
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'MealMate',
      themeMode: themeProvider.isDarkMode() ?
          ThemeMode.dark :
          ThemeMode.light,
      theme: ThemeData(
        colorScheme: .fromSeed(
            seedColor: Colors.deepPurple,
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
