import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => [..._items];

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
  double get totalAmount {
  return _items.fold(0.0, (total, item) => total + item.price);
}
}
