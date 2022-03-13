import 'package:flutter/material.dart';
import 'screens/welcome/welcome.dart';
import 'screens/products_overview/products_overview.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      home: ProductOverviewScreen(),
      theme: ThemeData(fontFamily: 'Lato'),
    );
  }
}
