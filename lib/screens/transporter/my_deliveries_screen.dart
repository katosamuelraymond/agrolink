import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../services/logistics_service.dart';
import '../../services/order_service.dart';
import '../../models/logistics_model.dart';
import '../../models/order_model.dart';
import '../../models/produce_model.dart';
import '../../widgets/order_card.dart';

class MyDeliveriesScreen extends StatelessWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    final logisticsService = LogisticsService();
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Deliveries')),
      body: ValueListenableBuilder<Box<LogisticsModel>>(
        valueListenable: Hive.box<LogisticsModel>('logistics').listenable(),
        builder: (context, logisticsBox, _) {
          return ValueListenableBuilder<Box<OrderModel>>(
            valueListenable: Hive.box<OrderModel>('orders').listenable(),
            builder: (context, orderBox, _) {
              return ValueListenableBuilder<Box<ProduceModel>>(
                valueListenable: Hive.box<ProduceModel>('produce').listenable(),
                builder: (context, produceBox, _) {
                  final userId = sessionService.currentUser?.id;
                  final myDeliveries = logisticsBox.values
                      .where((d) => d.transporterId == userId)
                      .toList()
                    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                  if (myDeliveries.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No Active Deliveries',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Go to the Pickups tab to accept available orders.',
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
                    itemCount: myDeliveries.length,
                    itemBuilder: (context, index) {
                      final logistics = myDeliveries[index];
                      final order = orderBox.values
                          .firstWhere((o) => o.id == logistics.orderId, orElse: () => OrderModel(id: '', buyerId: '', farmerId: '', produceId: '', quantity: 0, totalPrice: 0, status: 'unknown', createdAt: DateTime.now(), updatedAt: DateTime.now()));
                      final produce = produceBox.values
                          .firstWhere((p) => p.id == order.produceId, orElse: () => ProduceModel(id: '', farmerId: '', cropName: 'Unknown', quantity: 0, unit: '', pricePerUnit: 0, description: '', status: 'unavailable', createdAt: DateTime.now()));

                      Widget? trailing;
                      if (logistics.status == 'awaiting') {
                        trailing = ElevatedButton(
                          onPressed: () async {
                            await logisticsService.updateLogisticsStatus(logistics.id, 'in_transit');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Delivery marked as In Transit!')),
                              );
                            }
                          },
                          child: const Text('Start Transit'),
                        );
                      } else if (logistics.status == 'in_transit') {
                        trailing = ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () async {
                            await logisticsService.updateLogisticsStatus(logistics.id, 'delivered');
                            await orderService.updateOrderStatus(logistics.orderId, 'delivered');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Delivery completed! 🎉')),
                              );
                            }
                          },
                          child: const Text('Mark Delivered', style: TextStyle(color: Colors.white)),
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
          );
        },
      ),
    );
  }
}
