import 'package:flutter/material.dart';
import '../api/products.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    try {
      await ProductsApi.toggleFavorite(id, isFavorite);
    } catch (e) {
      isFavorite = oldStatus;
      rethrow;
    }
    notifyListeners();
  }
}
