import 'package:flutter/cupertino.dart';

import '../models/meal.dart';

class FavoritesProvider extends ChangeNotifier {

  final List<Meal> _meals = [];

  void addToFavorite(Meal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void removeFromFavorite(Meal meal){
    _meals.remove(meal);
    notifyListeners();
  }

  bool isFavorite(Meal meal){
    return _meals.any((food) => food.id == meal.id);
  }
}