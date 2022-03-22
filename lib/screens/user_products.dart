import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../components/refresh_products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () => refreshProducts(context),
                icon: const Icon(Icons.update))
          ],
        ),
        drawer: const AppDrawer(),
        body: buildRefreshIndicator(
          context: context,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (ctx, i) => Column(
                      children: [
                        UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                            (id) => productsData.deleteProduct(id)),
                        const Divider(),
                      ],
                    )),
          ),
        ));
  }
}
