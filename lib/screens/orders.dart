import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../components/loader.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return buildLoader();
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text('Error: ${dataSnapshot.error.toString()}'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, ordersData, child) => ListView.builder(
                            itemCount: ordersData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrderItem(ordersData.orders[i]),
                          ));
                }
              }
            }));
  }
}
