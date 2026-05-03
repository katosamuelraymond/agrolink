import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/order_service.dart';
import '../../services/produce_service.dart';
import '../../services/user_service.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';

class OrderRequestsScreen extends StatefulWidget {
  const OrderRequestsScreen({super.key});

  @override
  State<OrderRequestsScreen> createState() => _OrderRequestsScreenState();
}

class _OrderRequestsScreenState extends State<OrderRequestsScreen> {
  final _orderService = OrderService();
  final _produceService = ProduceService();
  final _userService = UserService();
  final _sessionService = SessionService();
  
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final userId = _sessionService.currentUserId;
    if (userId != null) {
      setState(() {
        _orders = _orderService.getOrdersForFarmer(userId)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  Future<void> _updateStatus(OrderModel order, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(order.id, newStatus);
      if (newStatus == 'confirmed') {
        // Also update produce status if necessary, e.g., to 'reserved' or 'sold' depending on logic
        // For simplicity, we just leave it available until fully sold, or reserve it.
      }
      _loadOrders();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order $newStatus!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Requests'),
      ),
      body: _orders.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async => _loadOrders(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final produce = _produceService.getProduceById(order.produceId);
                  final buyer = _userService.getUserById(order.buyerId);
                  
                  // Subtitle was removed as OrderCard now handles its own layout

                  List<Widget> actionButtons = [];
                  if (order.status == 'pending') {
                    actionButtons = [
                      TextButton(
                        onPressed: () => _updateStatus(order, 'cancelled'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Decline'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _updateStatus(order, 'confirmed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept Order'),
                      ),
                    ];
                  }

                  return OrderCard(
                    order: order,
                    produce: produce,
                    trailing: actionButtons.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actionButtons,
                          )
                        : null,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Orders Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'When buyers place orders for your produce, they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
