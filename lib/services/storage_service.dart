import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;
  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  static const String _favoritesKey = 'favorites_v1';

  List<Map<String, dynamic>> loadFavorites() {
    final List<String> savedStrings = _prefs.getStringList(_favoritesKey) ?? [];

    return savedStrings.map((stringElement) {
      return json.decode(stringElement) as Map<String, dynamic>;
    }).toList();
  }

  Future<bool> saveFavorites(List<Map<String, dynamic>> favoritesMaps) async {
    final List<String> stringsToSave = favoritesMaps.map((mealMap) {
      return json.encode(mealMap);
    }).toList();

    return await _prefs.setStringList(_favoritesKey, stringsToSave);
  }

  Future<bool> clearFavorites() async {
    return await _prefs.setStringList(_favoritesKey, []);
  }
}