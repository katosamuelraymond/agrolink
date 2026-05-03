import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../services/order_service.dart';
import '../../routes/app_routes.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final _sessionService = SessionService();
  final _produceService = ProduceService();
  final _orderService = OrderService();

  int _totalProduce = 0;
  int _pendingOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final userId = _sessionService.currentUserId;
    if (userId != null) {
      final produce = _produceService.getProduceByFarmer(userId);
      final orders = _orderService.getOrdersForFarmer(userId);

      setState(() {
        _totalProduce = produce.length;
        _pendingOrders = orders.where((o) => o.status == 'pending').length;
      });
    }
  }

  Future<void> _handleLogout() async {
    await _sessionService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.splash, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _sessionService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.fullName ?? "Farmer"}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Stats Overview
              const Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'My Produce',
                      _totalProduce.toString(),
                      Icons.inventory_2_outlined,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Pending Orders',
                      _pendingOrders.toString(),
                      Icons.pending_actions_outlined,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildActionCard(
                    'Add Produce',
                    Icons.add_circle_outline,
                    () => Navigator.pushNamed(context, AppRoutes.addProduce).then((_) => _loadStats()),
                  ),
                  _buildActionCard(
                    'Manage Produce',
                    Icons.edit_note,
                    () => Navigator.pushNamed(context, AppRoutes.myProduce).then((_) => _loadStats()),
                  ),
                  _buildActionCard(
                    'Order Requests',
                    Icons.receipt_long,
                    () => Navigator.pushNamed(context, AppRoutes.orderRequests).then((_) => _loadStats()),
                  ),
                  _buildActionCard(
                    'Logistics Status',
                    Icons.local_shipping_outlined,
                    () => Navigator.pushNamed(context, AppRoutes.logisticsStatus),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
