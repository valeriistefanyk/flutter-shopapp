import 'package:flutter/foundation.dart';
import 'cart.dart';
import '../api/orders.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      _orders = await OrdersApi.fetchOrders();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestapm = DateTime.now();
    try {
      final id = await OrdersApi.addOrder(cartProducts, total, timestapm);
      _orders.insert(
          0,
          OrderItem(
            id: id,
            amount: total,
            products: cartProducts,
            dateTime: timestapm,
          ));
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
