import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.title, this.price, this.quantity);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get item {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void addItem(String productid, double price, String title) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (value) =>
              CartItem(value.id, value.title, value.price, value.quantity + 1));
    } else {
      _items.putIfAbsent(productid,
          () => CartItem(DateTime.now().toString(), title, price, 1));
    }
    notifyListeners();
  }

  void removItem(String Productid) {
    _items.remove(Productid);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String ProductId) {
    if (!_items.containsKey(ProductId)) {
      return;
    }
    if (_items[ProductId].quantity > 1) {
      _items.update(
          ProductId,
          (value) =>
              CartItem(value.id, value.title, value.price, value.quantity - 1));
    }
    if (_items[ProductId].quantity == 1) {
      _items.remove(ProductId);
    }
    notifyListeners();
  }
}
