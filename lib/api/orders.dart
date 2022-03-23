import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../models/http_exceptions.dart';

const domain = 'shop-app-dd495-default-rtdb.europe-west1.firebasedatabase.app';
const orderCollection = '/orders';

class OrdersApi {
  static Future<List<OrderItem>> fetchOrders() async {
    try {
      final rawResponse =
          await http.get(Uri.https(domain, '$orderCollection.json'));
      final response = json.decode(rawResponse.body) as Map<String, dynamic>?;
      final List<OrderItem> loadedOrders = [];
      if (response != null) {
        response.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((cartItem) => CartItem(
                      id: cartItem['id'],
                      title: cartItem['title'],
                      quantity: cartItem['quantity'],
                      price: cartItem['price']))
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime'])));
        });
      }
      return loadedOrders.reversed.toList();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  static Future<String> addOrder(
      List<CartItem> cartProducts, double total, DateTime timestamp) async {
    try {
      final rawResponse =
          await http.post(Uri.https(domain, '$orderCollection.json'),
              body: json.encode({
                'amount': total,
                'dateTime': timestamp.toIso8601String(),
                'products': cartProducts
                    .map((product) => {
                          'id': product.id,
                          'price': product.price,
                          'quantity': product.quantity,
                          'title': product.title,
                        })
                    .toList()
              }));
      if (rawResponse.statusCode < 400) {
        final response = jsonDecode(rawResponse.body);
        final id = response['name'];
        if (id == null) {
          throw HttpException('Cannot fetch id');
        }
        return id;
      } else {
        throw HttpException(rawResponse.reasonPhrase.toString());
      }
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
