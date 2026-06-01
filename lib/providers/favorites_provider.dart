import 'package:flutter/cupertino.dart';
import 'package:mealmate/services/storage_service.dart';


class FavoritesProvider with ChangeNotifier {

  List<String> _mealsIds = [];
  late final StorageService _storage;

  FavoritesProvider(Future<StorageService> storageFuture) {
    _loadFromStorage(storageFuture);
  }

  void _loadFromStorage(Future<StorageService> storageFuture) async {
    _storage = await storageFuture;
    final prefs = _storage.loadFavorites();
    _mealsIds = prefs;
    notifyListeners();
  }

  void addToFavorite(String mealId) {
    _mealsIds.add(mealId);
    _storage.saveFavorites(_mealsIds);
    notifyListeners();
  }

  void removeFromFavorite(String mealId){
    _mealsIds.remove(mealId);
    _storage.saveFavorites(_mealsIds);
    notifyListeners();
  }

  bool isFavorite(String mealId){
    return _mealsIds.contains(mealId);
  }

  int favoritesCount(){
    return _mealsIds.length;
  }
}