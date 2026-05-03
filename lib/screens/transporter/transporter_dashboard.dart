import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/session_service.dart';
import '../../models/order_model.dart';
import '../../models/logistics_model.dart';
import '../../routes/app_routes.dart';

class TransporterDashboard extends StatelessWidget {
  const TransporterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionService = SessionService();
    final user = sessionService.currentUser;
    final userId = user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporter Dashboard'),
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
      body: ValueListenableBuilder<Box<OrderModel>>(
        valueListenable: Hive.box<OrderModel>('orders').listenable(),
        builder: (context, orderBox, _) {
          return ValueListenableBuilder<Box<LogisticsModel>>(
            valueListenable: Hive.box<LogisticsModel>('logistics').listenable(),
            builder: (context, logisticsBox, _) {
              final availablePickupsCount = orderBox.values.where((o) => o.status == 'confirmed').length;
              final myDeliveries = logisticsBox.values.where((d) => d.transporterId == userId).toList();
              final inTransitCount = myDeliveries.where((d) => d.status == 'in_transit' || d.status == 'awaiting').length;
              final deliveredCount = myDeliveries.where((d) => d.status == 'delivered').length;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome, ${user?.fullName ?? "Transporter"}!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here is your delivery overview',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Available\nPickups',
                            availablePickupsCount.toString(),
                            Icons.map,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            'In\nTransit',
                            inTransitCount.toString(),
                            Icons.local_shipping,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      'Total Delivered',
                      deliveredCount.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ],
                ),
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
