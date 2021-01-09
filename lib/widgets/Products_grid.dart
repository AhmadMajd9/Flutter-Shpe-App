import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFav;
  ProductsGrid(this.showOnlyFav);
  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<Products>(context);
    final products = showOnlyFav ? productDate.favoriteIems : productDate.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, indext) => ChangeNotifierProvider.value(
        value: products[indext],
        child: ProductItem(),
      ),
    );
  }
}
