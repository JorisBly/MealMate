import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:mealmate/services/storage_service.dart';

class DailyProvider with ChangeNotifier {
  late DateTime? _lastDate = null;
  late String? _lastDailyMealId = null;
  late final StorageService _storage;

  DailyProvider(Future<StorageService> storageFuture) {
    _loadFromStorage(storageFuture);
  }

  void _loadFromStorage(Future<StorageService> storageFuture) async {
     _storage = await storageFuture;
    var _storagedDate = await _storage.loadlastDailyDate();

    if (_storagedDate == null) return null;

    final parts = _storagedDate.split('/');
    final todayStr = DateTime.now().toIso8601String().split('T')[0];


    if (parts.length == 2 && parts[1] == todayStr) {
      _lastDailyMealId = parts[0];
      _lastDate = DateTime.parse(parts[1]);
    }
    notifyListeners();
  }


  DateTime? getLastDate(){
    return _lastDate;
  }

  String? getLastDailyMealId(){
    return _lastDailyMealId;
  }

  void saveDailyMeal(String mealId) async {
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    var newData = '$mealId/$todayStr';
    await _storage.saveLastDailyDate(newData);
    _lastDailyMealId = mealId;
    _lastDate = DateTime.parse(todayStr);
    notifyListeners();
  }

}