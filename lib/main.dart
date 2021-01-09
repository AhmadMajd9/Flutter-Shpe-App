import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screen/auth_screen.dart';
import 'package:shopapp/screen/card_screen.dart';
import 'package:shopapp/screen/order_screen.dart';
import 'package:shopapp/screen/edit_product_screen.dart';
import 'package:shopapp/screen/splash_screen.dart';
import './screen/products_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';

import 'screen/user_prudoct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (context, auth, previous) => Products(
            auth.token,
            auth.userID,
            previous == null ? [] : previous.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (context, auth, previous) => Orders(
            auth.token,
            auth.userID,
            previous == null ? [] : previous.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            //  '/': (context) => AuthScreen(),
            CartScreen.routeId: (context) => CartScreen(),
            ProductOverViewScreen.routeId: (context) => ProductOverViewScreen(),
            ProductDetaillScreen.routeId: (context) => ProductDetaillScreen(),
            OrdersScreen.routeId: (context) => OrdersScreen(),
            UserProductsScreen.routeId: (context) => UserProductsScreen(),
            EditProdcutScreen.routeId: (context) => EditProdcutScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop !'),
      ),
    );
  }
}
