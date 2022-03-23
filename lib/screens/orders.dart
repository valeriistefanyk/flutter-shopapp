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
  var _isLoading = false;
  var _isInit = false;
  late Orders ordersData;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      ordersData = Provider.of<Orders>(context);
      setState(() {
        _isLoading = true;
      });
      ordersData.fetchAndSetOrders().catchError((e) => print(e)).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        drawer: const AppDrawer(),
        body: _isLoading
            ? buildLoader()
            : ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
              ));
  }
}
