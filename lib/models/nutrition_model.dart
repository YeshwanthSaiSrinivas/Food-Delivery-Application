class Nutrition {
  final int kcal;
  final int grams;
  final int protein;
  final int fats;
  final int carbs;

  Nutrition({
    required this.kcal,
    required this.grams,
    required this.protein,
    required this.fats,
    required this.carbs,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      kcal: json['kcal'],
      grams: json['grams'],
      protein: json['protein'],
      fats: json['fats'],
      carbs: json['carbs'],
    );
  }
}
