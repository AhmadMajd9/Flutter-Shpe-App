import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderiTems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dataTime;

  OrderiTems(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dataTime});
}

class Orders with ChangeNotifier {
  List<OrderiTems> _oders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._oders);

  List<OrderiTems> get orders {
    return [..._oders];
  }

  Future<void> addOder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/oders/$userId.json?auth=$authToken';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'amount ': total,
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
          'dataTime': DateTime.now().toIso8601String(),
        }),
      );

      if (value.statusCode >= 400) {}

      _oders.insert(
        0,
        OrderiTems(
            id: json.decode(value.body)['name'],
            amount: total,
            products: cartProducts,
            dataTime: DateTime.now()),
      );
      notifyListeners();
    } catch (e) {}
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/oders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderiTems> loadedOrder = [];
      if (extractedDate == null) {
        return;
      }
      extractedDate.forEach((ordId, ordData) {
        loadedOrder.add(
          OrderiTems(
            id: ordId,
            amount: ordData['amount'],
            products: (ordData['products'] as List<dynamic>)
                .map((e) =>
                    CartItem(e['id'], e['title'], e['price'], e['quantity']))
                .toList(),
            dataTime: DateTime.parse(ordData['dataTime']),
          ),
        );
      });
      _oders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
