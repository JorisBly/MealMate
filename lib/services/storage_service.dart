import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  static const String _favoritesKey = 'favorites_v1';

  List<String> loadFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<bool> saveFavorites(List<String> favorites) async {
    return await _prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> clearFavorites() async {
    return await _prefs.setStringList(_favoritesKey, []);
  }

  // Future<bool> loadDarkMode(){
  // }

  // Future<bool> saveDarkMode(){
  //
  // }
}