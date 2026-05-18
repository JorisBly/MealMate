class Meal {
  final String name;
  final List<Object> ingredients;
  final String instruction;
  final String imageUrl;
  final String? urlSource;

  const Meal({
    required this.name,
    required this.ingredients,
    required this.instruction,
    required this.imageUrl,
    this.urlSource,
  });
}