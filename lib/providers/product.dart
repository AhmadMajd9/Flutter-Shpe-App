import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desctiption;
  final double price;
  final String imgeUrl;
  bool isFaborite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.desctiption,
      @required this.price,
      @required this.imgeUrl,
      this.isFaborite = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldState = isFaborite;
    isFaborite = !isFaborite;
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/userFoavortes/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
        url,
        body: json.encode(isFaborite),
      );
      if (response.statusCode >= 400) {
        isFaborite = oldState;
        notifyListeners();
      }
    } catch (e) {
      isFaborite = oldState;
      notifyListeners();
    }

    notifyListeners();
  }
}
