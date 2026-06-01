import 'package:flutter/cupertino.dart';
import 'package:mealmate/services/storage_service.dart';

import '../models/meal.dart';


class FavoritesProvider with ChangeNotifier {

  List<Map<String, dynamic>> _meals = [];
  late final StorageService _storage;

  FavoritesProvider(Future<StorageService> storageFuture) {
    _loadFromStorage(storageFuture);
  }

  void _loadFromStorage(Future<StorageService> storageFuture) async {
    _storage = await storageFuture;
    final prefs = _storage.loadFavorites();
    _meals = prefs.cast<Map<String, dynamic>>();
    notifyListeners();
  }

  void addToFavorite(Meal meal) {
    _meals.add(meal.toJson());
    _storage.saveFavorites(_meals);
    notifyListeners();
  }

  void removeFromFavorite(Meal meal){
    _meals.removeWhere((mealItem) => Meal.fromJson(mealItem).id == meal.id);
    _storage.saveFavorites(_meals);
    notifyListeners();
  }

  bool isFavorite(Meal meal){
    return _meals.any((mealItem) => Meal.fromJson(mealItem).id == meal.id);
  }

  int favoritesCount(){
    return _meals.length;
  }

  List<Map<String, dynamic>> getFavorites(){
    return _meals;
  }

  bool clearFavorites(){
    _meals = [];
    _storage.saveFavorites(_meals);
    notifyListeners();
    return true;
  }
}