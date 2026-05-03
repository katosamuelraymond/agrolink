import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/logistics_service.dart';
import '../../services/order_service.dart';
import '../../routes/app_routes.dart';

class TransporterDashboard extends StatefulWidget {
  const TransporterDashboard({super.key});

  @override
  State<TransporterDashboard> createState() => _TransporterDashboardState();
}

class _TransporterDashboardState extends State<TransporterDashboard> {
  final _sessionService = SessionService();
  final _logisticsService = LogisticsService();
  final _orderService = OrderService();

  int _availablePickupsCount = 0;
  int _inTransitCount = 0;
  int _deliveredCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final user = _sessionService.currentUser;
    if (user != null) {
      final confirmedOrders = _orderService.getAllConfirmedOrders();
      final myDeliveries = _logisticsService.getDeliveriesForTransporter(user.id);

      setState(() {
        _availablePickupsCount = confirmedOrders.length;
        _inTransitCount = myDeliveries.where((d) => d.status == 'in_transit' || d.status == 'awaiting').length;
        _deliveredCount = myDeliveries.where((d) => d.status == 'delivered').length;
      });
    }
  }

  Future<void> _logout() async {
    await _sessionService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporter Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Transporter!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Available\nPickups',
                    _availablePickupsCount.toString(),
                    Icons.map,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'In\nTransit',
                    _inTransitCount.toString(),
                    Icons.local_shipping,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              'Delivered',
              _deliveredCount.toString(),
              Icons.check_circle,
              Colors.green,
            ),

          ],
        ),
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
