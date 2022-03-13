import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/_dummy_data.dart';
import '../../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = DUMMY_PRODUCTS;

  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyShop')),
      body: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => ProductItem(
                loadedProducts[i].id,
                loadedProducts[i].title,
                loadedProducts[i].imageUrl,
              )),
    );
  }
}
