import 'package:flutter/material.dart';
import 'package:shopapp/models/http_excaption.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'p1 Red Shirt',
    //   desctiption: 'A red shirt - it prettty red !',
    //   price: 29.99,
    //   imgeUrl:
    //       "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'p2 Red Shirt',
    //   desctiption: 'A red shirt - it prettty red !',
    //   price: 29.99,
    //   imgeUrl:
    //       "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'p3 Red Shirt',
    //   desctiption: 'A red shirt - it prettty red !',
    //   price: 29.99,
    //   imgeUrl:
    //       "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'p4 Red Shirt',
    //   desctiption: 'A red shirt - it prettty red !',
    //   price: 29.99,
    //   imgeUrl:
    //       "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'p5 Red Shirt',
    //   desctiption: 'A red shirt - it prettty red !',
    //   price: 29.99,
    //   imgeUrl:
    //       "https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/480x240/54ca71fb94ad3_-_5summer_skills_burger_470_0808-de.jpg",
    // ),
  ];

  // var _showFavoritesOnly = false;
  final String autToken;
  final String userID;

  Products(this.autToken, this.userID, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFaborite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteIems {
    return _items.where((element) => element.isFaborite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userID"' : '';
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/products.json?auth=$autToken&$filterString';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedDate = json.decode(response.body) as Map<String, dynamic>;

      final favoriturl =
          'https://ubar-app-e2fcc.firebaseio.com/userFoavortes/$userID/.json?auth=$autToken';
      final favoritresponse = await http.get(favoriturl);
      final favoritrData = json.decode(favoritresponse.body);

      final List<Product> loadedProduct = [];
      extractedDate.forEach((proId, prodData) {
        loadedProduct.add(Product(
            id: proId,
            title: prodData['title '],
            desctiption: prodData['description'],
            price: prodData['price'],
            isFaborite:
                favoritrData == null ? false : favoritrData[proId] ?? false,
            imgeUrl: prodData['imgUrl']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/products.json?auth=$autToken';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title ': product.title,
          'description': product.desctiption,
          'price': product.price,
          'imgUrl': product.imgeUrl,
          'creatorId': userID,
        }),
      );
      final newProduct = Product(
          id: json.decode(value.body)["name"],
          title: product.title,
          desctiption: product.desctiption,
          price: product.price,
          imgeUrl: product.imgeUrl);
      _items.insert(0, newProduct);

      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    print("id ${_items[productIndex].id}");
    if (productIndex >= 0) {
      final url =
          'https://ubar-app-e2fcc.firebaseio.com/products.json?auth=$autToken';
      await http.patch(url,
          body: json.encode({
            'title ': newProduct.title,
            'description': newProduct.desctiption,
            'price': newProduct.price,
            'imgUrl': newProduct.imgeUrl,
          }));
      print("aaaaavvvvvv");

      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print("no Prount found");
    }
  }

  Future<void> deletProduct(String id) async {
    final url =
        'https://ubar-app-e2fcc.firebaseio.com/products/$id.json?auth=$autToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Coulld not delette product?');
    }
    existingProduct = null;
  }

  // void showFavoritseInly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product fingById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
