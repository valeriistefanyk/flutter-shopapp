import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview.dart';
import 'screens/product_detail.dart';
import 'screens/cart.dart';
import 'screens/orders.dart';
import 'screens/user_products.dart';
import 'screens/edit_product.dart';

import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'Shop App',
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        },
        theme: ThemeData(
            fontFamily: 'Lato',
            canvasColor: const Color(0xFFF5F5F7),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
      ),
    );
  }
}
