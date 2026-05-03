import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../services/order_service.dart';
import '../../services/payment_service.dart';
import '../../routes/app_routes.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  final _sessionService = SessionService();
  final _produceService = ProduceService();
  final _orderService = OrderService();
  final _paymentService = PaymentService();

  int _availableProduceCount = 0;
  int _activeOrdersCount = 0;
  int _pendingPaymentsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final user = _sessionService.currentUser;
    if (user != null) {
      final availableProduce = _produceService.getAllAvailableProduce();
      final myOrders = _orderService.getOrdersForBuyer(user.id);
      
      final activeOrders = myOrders.where((o) => o.status != 'delivered' && o.status != 'cancelled').length;
      
      int pendingPayments = 0;
      for (var order in myOrders) {
        if (order.status == 'confirmed') {
          final payments = _paymentService.getPaymentsForOrder(order.id);
          if (payments.isEmpty || payments.every((p) => p.status != 'completed')) {
            pendingPayments++;
          }
        }
      }

      setState(() {
        _availableProduceCount = availableProduce.length;
        _activeOrdersCount = activeOrders;
        _pendingPaymentsCount = pendingPayments;
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
        title: const Text('Buyer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Buyer!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Available\nProduce',
                    _availableProduceCount.toString(),
                    Icons.shopping_basket,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Active\nOrders',
                    _activeOrdersCount.toString(),
                    Icons.local_shipping,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              'Pending Payments',
              _pendingPaymentsCount.toString(),
              Icons.payment,
              Colors.redAccent,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.browseProduce).then((_) => _loadStats());
              },
              icon: const Icon(Icons.search),
              label: const Text('Browse Market'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.myOrders).then((_) => _loadStats());
              },
              icon: const Icon(Icons.list_alt),
              label: const Text('My Orders'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
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
