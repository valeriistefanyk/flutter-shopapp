import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/product.dart';
import '../models/http_exceptions.dart';

const domain = 'shop-app-dd495-default-rtdb.europe-west1.firebasedatabase.app';
const productCollection = '/products';

class ProductsApi {
  static Future<List<Product>> fetchProducts() async {
    try {
      final rawResponse =
          await http.get(Uri.https(domain, '$productCollection.json'));
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
      final rawResponse =
          await http.post(Uri.https(domain, '$productCollection.json'),
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

  static Future<void> updateProduct(String id, Product newProduct) async {
    await http.patch(
      Uri.https(domain, '$productCollection/$id.json'),
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );
  }

  static Future<void> toggleFavorite(String id, bool isFavorite) async {
    final rawResponse = await http.patch(
        Uri.https(domain, '$productCollection/$id.json'),
        body: json.encode({'isFavorite': isFavorite}));
    if (rawResponse.statusCode >= 400) {
      throw HttpException('Could not toggle favorite');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final rawResponse =
        await http.delete(Uri.https(domain, '$productCollection/$id.json'));
    if (rawResponse.statusCode >= 400) {
      throw HttpException('Could not delete product');
    }
  }
}
