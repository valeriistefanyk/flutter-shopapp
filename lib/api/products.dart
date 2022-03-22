import 'dart:convert';

import 'package:http/http.dart' as http;
import '../providers/product.dart';

const domain = 'shop-app-dd495-default-rtdb.europe-west1.firebasedatabase.app';

class ProductsApi {
  static Future<String> addProduct(Product product) async {
    try {
      final rawResponse = await http.post(Uri.https(domain, '/proct'),
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
