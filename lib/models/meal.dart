
class Meal {
  final String id;
  final String name;
  final String? category;
  final List<String>? ingredients;
  final String instruction;
  final String imageUrl;
  final String? country;
  final String? urlSource;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.ingredients,
    required this.instruction,
    required this.imageUrl,
    required this.country,
    this.urlSource,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (var i = 1; i <= 50; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        final combined = measure != null && measure.trim().isNotEmpty ? '$measure $ingredient' : ingredient;
        ingredients.add(combined);
      }else{
        break;
      }
    }

    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String?,
      ingredients: ingredients,
      instruction: json['strInstructions'] as String? ?? '',
      imageUrl: json['strMealThumb'] as String,
      country: json['strCountry'] as String?,
      urlSource: json['strYoutube'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strCategory': category,
        'strInstructions': instruction,
        'strMealThumb': imageUrl,
        'strCountry': country,
        'strYoutube': urlSource,
        'ingredients': ingredients,
      };

}