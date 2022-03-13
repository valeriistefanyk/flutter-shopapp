import 'package:flutter/material.dart';
import 'screens/welcome/welcome.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      home: const WelcomeScreen(),
      theme: ThemeData(fontFamily: 'Lato'),
    );
  }
}
