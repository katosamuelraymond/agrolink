import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';
import '../../routes/app_routes.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _orderService = OrderService();
  final _sessionService = SessionService();
  final _produceService = ProduceService();

  List<OrderModel> _myOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final user = _sessionService.currentUser;
    if (user != null) {
      setState(() {
        _myOrders = _orderService.getOrdersForBuyer(user.id);
        // Sort by newest first
        _myOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: _myOrders.isEmpty
          ? const Center(child: Text('You have not placed any orders yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _myOrders.length,
              itemBuilder: (context, index) {
                final order = _myOrders[index];
                final produce = _produceService.getProduceById(order.produceId);
                
                return OrderCard(
                  order: order,
                  produce: produce,
                  trailing: order.status == 'confirmed'
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.payment,
                              arguments: order,
                            ).then((_) => _loadOrders());
                          },
                          child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
                        )
                      : null,
                );
              },
            ),
    );
  }
}
