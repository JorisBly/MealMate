import 'package:flutter/material.dart';
import 'package:mealmate/models/meal.dart';
import 'package:mealmate/widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Meal> meals = const [
    Meal(
      name: "Poulet",
      ingredients: ["Poulet", "Riz", "Tomate"],
      instruction: "Faire cuire le poulet, le riz et la tomate",
      imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg" ,
      urlSource: "",
    ),
    Meal(
      name: "Big burger",
      ingredients: ["Burger", "Frites", "Salade"],
      instruction: "Faire cuire le burger, les frites et la salade",
      imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg" ,
      urlSource: "https://www.themealdb.com/images/media/meals/1529444830.jpg",
    ),
    Meal(
      name: "Pizza de fou",
      ingredients: ["Pizza", "Fromage", "Tomate"],
      instruction: "Faire cuire la pizza, le fromage et la tomate",
      imageUrl: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg" ,
      urlSource: "https://www.themealdb.com/images/media/meals/x0lk931587671540.jpg",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMate'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: const EdgeInsets.all(12),
        children: [
          for (var meal in meals)
            MealCard(
              title: meal.name,
              imageUrl: meal.imageUrl,
            ),
        ],
      ),
    );
  }
}