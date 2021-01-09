import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import '../widgets/card_item.dart';

class CartScreen extends StatelessWidget {
  static final routeId = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(' Your Card'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OdrerButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) => CartItem(
                  cart.item.values.toList()[i].id,
                  cart.item.keys.toList()[i],
                  cart.item.values.toList()[i].price,
                  cart.item.values.toList()[i].quantity,
                  cart.item.values.toList()[i].title),
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OdrerButton extends StatefulWidget {
  const OdrerButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;
  @override
  _OdrerButtonState createState() => _OdrerButtonState();
}

class _OdrerButtonState extends State<OdrerButton> {
  @override
  Widget build(BuildContext context) {
    var _isLoadind = false;

    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoadind)
          ? null
          : () async {
              setState(() {
                _isLoadind = true;
              });
              await Provider.of<Orders>(context, listen: false).addOder(
                  widget.cart.item.values.toList(), widget.cart.totalAmount);
              setState(() {
                _isLoadind = false;
              });
              widget.cart.clear();
            },
      child: Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
