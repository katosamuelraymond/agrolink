import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../models/produce_model.dart';
import '../../models/order_model.dart';
import '../../models/payment_model.dart';
import '../../routes/app_routes.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    final user = sessionService.currentUser;
    final userId = user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await sessionService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<ProduceModel>>(
        valueListenable: Hive.box<ProduceModel>('produce').listenable(),
        builder: (context, produceBox, _) {
          return ValueListenableBuilder<Box<OrderModel>>(
            valueListenable: Hive.box<OrderModel>('orders').listenable(),
            builder: (context, orderBox, _) {
              return ValueListenableBuilder<Box<PaymentModel>>(
                valueListenable: Hive.box<PaymentModel>('payments').listenable(),
                builder: (context, paymentBox, _) {
                  final availableProduceCount = produceBox.values.where((p) => p.status == 'available').length;
                  final myOrders = orderBox.values.where((o) => o.buyerId == userId).toList();
                  final activeOrdersCount = myOrders.where((o) => o.status != 'delivered' && o.status != 'cancelled').length;
                  final pendingPaymentsCount = myOrders.where((o) {
                    if (o.status != 'confirmed') return false;
                    final paid = paymentBox.values.any((p) => p.orderId == o.id && p.status == 'completed');
                    return !paid;
                  }).length;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome, ${user?.fullName ?? "Buyer"}!',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Here is your activity overview',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Available\nProduce',
                                availableProduceCount.toString(),
                                Icons.shopping_basket,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                'Active\nOrders',
                                activeOrdersCount.toString(),
                                Icons.local_shipping,
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryCard(
                          'Pending Payments',
                          pendingPaymentsCount.toString(),
                          Icons.payment,
                          Colors.redAccent,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
