import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';
import '../../models/produce_model.dart';
import '../../widgets/order_card.dart';

class OrderRequestsScreen extends StatelessWidget {
  const OrderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text('Order Requests')),
      body: ValueListenableBuilder<Box<OrderModel>>(
        valueListenable: Hive.box<OrderModel>('orders').listenable(),
        builder: (context, orderBox, _) {
          return ValueListenableBuilder<Box<ProduceModel>>(
            valueListenable: Hive.box<ProduceModel>('produce').listenable(),
            builder: (context, produceBox, _) {
              final userId = sessionService.currentUserId;
              final orders = orderBox.values
                  .where((o) => o.farmerId == userId)
                  .toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              if (orders.isEmpty) {
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

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final produce = produceBox.values.firstWhere(
                    (p) => p.id == order.produceId,
                    orElse: () => ProduceModel(id: '', farmerId: '', cropName: 'Unknown', quantity: 0, unit: '', pricePerUnit: 0, description: '', status: 'unavailable', createdAt: DateTime.now()),
                  );

                  Widget? trailing;
                  if (order.status == 'pending') {
                    trailing = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await orderService.updateOrderStatus(order.id, 'cancelled');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order declined.')));
                            }
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Decline'),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () async {
                            await orderService.updateOrderStatus(order.id, 'confirmed');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order confirmed! ✅')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Accept'),
                        ),
                      ],
                    );
                  }

                  return OrderCard(
                    order: order,
                    produce: produce,
                    trailing: trailing,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
