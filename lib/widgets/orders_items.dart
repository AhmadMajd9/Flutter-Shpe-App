import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrdesItem extends StatefulWidget {
  final ord.OrderiTems ordes;

  const OrdesItem(this.ordes);

  @override
  _OrdesItemState createState() => _OrdesItemState();
}

class _OrdesItemState extends State<OrdesItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    print(widget.ordes.amount);

    return AnimatedContainer(
      height:
          _expanded ? min(widget.ordes.products.length * 20.0 + 210, 200) : 95,
      duration: Duration(
        milliseconds: 300,
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.ordes.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.ordes.dataTime),
              ),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.ordes.products.length * 20.0 + 120, 100)
                  : 0,
              child: ListView(
                children: widget.ordes.products
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${e.quantity}x \$ ${e.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
