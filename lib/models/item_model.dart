import 'nutrition_model.dart';

class Item {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final double price;
  final bool isPromoted;
  final Nutrition nutrition;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.isPromoted,
    required this.nutrition,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      isPromoted: json['isPromoted'],
      nutrition: Nutrition.fromJson(json['nutrition']),
    );
  }
}
