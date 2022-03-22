import 'dart:convert';

import 'package:http/http.dart' as http;
import '../providers/product.dart';

const domain = 'shop-app-dd495-default-rtdb.europe-west1.firebasedatabase.app';
const productCollection = '/products.json';

class ProductsApi {
  static Future<List<Product>> fetchProducts() async {
    try {
      final rawResponse = await http.get(Uri.https(domain, productCollection));
      final response = json.decode(rawResponse.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      response.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      return loadedProducts;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> addProduct(Product product) async {
    try {
      final rawResponse = await http.post(Uri.https(domain, productCollection),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          }));
      if ((rawResponse.statusCode ~/ 100) == 2) {
        final response = jsonDecode(rawResponse.body);
        final id = response['name'];
        return id ?? 'invalid';
      } else {
        throw Exception(rawResponse.reasonPhrase);
      }
    } catch (error) {
      rethrow;
    }
  }
}
