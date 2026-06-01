import 'package:flutter/material.dart';
import 'package:mealmate/screens/meal_details_screen.dart';

import '../models/meal.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
             Navigator.push(
                 context,
               MaterialPageRoute<void>(
                 builder: (context) => MealDetailsScreen(meal: meal),
               ),
             );
            },
            child: Image(
              image: NetworkImage(meal.imageUrl),
              semanticLabel: meal.name,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                meal.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
          ],),

      ),
    );
  }
}