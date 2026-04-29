import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../data/data.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _allItems = [];
  String _selectedCategory = "All";

  ItemProvider() {
    _allItems = data.map((e) => Item.fromJson(e)).toList();
  }

  List<Item> get allItems => _allItems;

  List<String> get categories {
    final cats = _allItems.map((e) => e.category).toSet().toList();
    cats.insert(0, "All");
    return cats;
  }

  String get selectedCategory => _selectedCategory;

  List<Item> get filteredItems {
    if (_selectedCategory == "All") return _allItems;
    return _allItems.where((e) => e.category == _selectedCategory).toList();
  }

  List<Item> get promotedItems {
    return _allItems.where((e) => e.isPromoted).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
