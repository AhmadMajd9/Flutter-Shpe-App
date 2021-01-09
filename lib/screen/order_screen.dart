import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/orders_items.dart';

class OrdersScreen extends StatefulWidget {
  static final routeId = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context).fetchAndSetProducts();
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    print(ordersData.orders[1].amount);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) =>
                  OrdesItem(ordersData.orders[index]),
              itemCount: ordersData.orders.length,
            ),
      drawer: AppDrawer(),
    );
  }
}
