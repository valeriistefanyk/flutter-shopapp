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
      theme: ThemeData(
          fontFamily: 'Lato',
          canvasColor: const Color(0xFFF5F5F7),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange)),
    );
  }
}
