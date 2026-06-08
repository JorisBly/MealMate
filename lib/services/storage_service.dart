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
  static const String _darkModeKey = 'darkMode';

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

  Future<bool?> loadDarkMode() async{
    final result = await _prefs.getBool(_darkModeKey);
    return result;
  }

  Future<bool> saveDarkMode(bool darkMode) async {
    return await _prefs.setBool(_darkModeKey, darkMode);
  }
}