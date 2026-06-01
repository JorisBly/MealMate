import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:mealmate/services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  late bool? _darkMode = false;
  late final StorageService _storage;

  ThemeProvider(Future<StorageService> storageFuture){
    _loadFromStorage(storageFuture);
  }

  void _loadFromStorage(Future<StorageService> storageFuture) async {
    _storage = await storageFuture;
    _darkMode = await _storage.loadDarkMode();
    notifyListeners();
  }

  void toggleDarkMode(){
    _darkMode = _darkMode!;
    _storage.saveDarkMode(_darkMode!);
    notifyListeners();
  }
}