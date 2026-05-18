import 'package:flutter/material.dart';
import 'package:mealmate/widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMate'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 👈 C'est ici qu'on dit qu'on veut 2 éléments max par ligne
        crossAxisSpacing: 12, // Espace horizontal entre les colonnes
        mainAxisSpacing: 12,  // Espace vertical entre les lignes
        padding: const EdgeInsets.all(12),
        children: [
          MealCard(title: "Poulet", imageUrl: "https://www.themealdb.com/images/media/meals/qtuwxu1468233098.jpg"),
          MealCard(title: "Burger", imageUrl: "https://www.themealdb.com/images/media/meals/1529444830.jpg"),
          MealCard(title: "Pizza", imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg"),
          MealCard(title: "Pizza", imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg"),
          MealCard(title: "Pizza", imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg"),
          MealCard(title: "Pizza", imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg"),
        ],
      ),
    );
  }
}