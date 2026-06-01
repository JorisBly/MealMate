
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  Future<Meal> getMealById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];
        if (meals != null && meals.isNotEmpty) {
          return Meal.fromJson(meals[0]);
        }
      }
      throw HttpException('Failed to load meal');
    }catch(e) {
      rethrow;
    }
  }

  Future<List<Meal>>searchMeals(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];
        return meals?.map((json) => Meal.fromJson(json)).toList() ?? [];
      }
      throw HttpException('Failed to search meals');
    }catch(e) {
      rethrow;
    }
  }

  Future<Meal>getRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];
        if (meals != null && meals.isNotEmpty) {
          return Meal.fromJson(meals[0]);
        }
      }
      throw HttpException('Failed to load meal');
    }catch(e) {
      rethrow;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? categories = data['categories'];
        if (categories != null && categories.isNotEmpty) {
          return categories.map((json) => Category.fromJson(json)).toList();
        }
      }
      throw HttpException('Failed to load categories');
    }catch(e) {
      rethrow;
    }
  }

  Future<List<Meal>> getMealsByCategory(Category category) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${category.name}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];
        return meals?.map((json) => Meal.fromJson(json)).toList() ?? [];
      }
      throw HttpException('Failed to load meals by category');
    }catch(e) {
      rethrow;
    }
  }

}