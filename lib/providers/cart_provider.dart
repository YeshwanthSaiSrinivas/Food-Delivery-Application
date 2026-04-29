import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/item_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Item item) {
    final index = _items.indexWhere((e) => e.item.id == item.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((e) => e.item.id == id);
    notifyListeners();
  }

  void increaseQty(String id) {
    final item = _items.firstWhere((e) => e.item.id == id);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQty(String id) {
    final item = _items.firstWhere((e) => e.item.id == id);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.item.price * item.quantity);
  }

  int get itemCount {
    int count = 0;

    for (var item in _items) {
      count += item.quantity;
    }

    return count;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
