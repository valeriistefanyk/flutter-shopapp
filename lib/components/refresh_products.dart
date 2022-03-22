import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

Future<void> refreshProducts(BuildContext context) async {
  await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
}

RefreshIndicator buildRefreshIndicator(
    {required BuildContext context, required Widget child}) {
  return RefreshIndicator(
      child: child, onRefresh: () => refreshProducts(context));
}
