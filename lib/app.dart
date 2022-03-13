import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview/products_overview.dart';
import 'screens/product_detail/product_detail.dart';
import 'providers/products.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Shop App',
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen()
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
