import 'package:flutter/cupertino.dart';


class FavoritesProvider extends ChangeNotifier {

  final List<String> _mealsIds = [];

  void addToFavorite(String mealId) {
    _mealsIds.add(mealId);
    notifyListeners();
  }

  void removeFromFavorite(String mealId){
    _mealsIds.remove(mealId);
    notifyListeners();
  }

  bool isFavorite(String mealId){
    return _mealsIds.any((mealId) => mealId == mealId);
  }
}