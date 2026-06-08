import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mealmate/services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  late bool _darkMode = false;
  late final StorageService _storage;

  ThemeProvider(Future<StorageService> storageFuture){
    _loadFromStorage(storageFuture);
  }

  void _loadFromStorage(Future<StorageService> storageFuture) async {
    _storage = await storageFuture;
    var _storagedMode = await _storage.loadDarkMode();
    if(_storagedMode == null){
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      _darkMode = brightness == Brightness.dark ? true : false;
    }else{
      _darkMode = _storagedMode;
    }

    notifyListeners();
  }

  void toggleDarkMode(){
    _darkMode = !_darkMode;
    _storage.saveDarkMode(_darkMode);
    notifyListeners();
  }

  bool isDarkMode(){
    return _darkMode;
  }


}