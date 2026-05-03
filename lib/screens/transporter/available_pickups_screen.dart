import 'package:flutter/material.dart';
import '../../services/order_service.dart';
import '../../services/logistics_service.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../models/order_model.dart';
import '../../widgets/order_card.dart';

class AvailablePickupsScreen extends StatefulWidget {
  const AvailablePickupsScreen({super.key});

  @override
  State<AvailablePickupsScreen> createState() => _AvailablePickupsScreenState();
}

class _AvailablePickupsScreenState extends State<AvailablePickupsScreen> {
  final _orderService = OrderService();
  final _logisticsService = LogisticsService();
  final _sessionService = SessionService();
  final _produceService = ProduceService();

  List<OrderModel> _availablePickups = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadPickups();
  }

  void _loadPickups() {
    setState(() {
      _availablePickups = _orderService.getAllConfirmedOrders();
      _availablePickups.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // oldest first
    });
  }

  Future<void> _acceptPickup(OrderModel order) async {
    final user = _sessionService.currentUser;
    if (user == null) return;

    setState(() => _isProcessing = true);

    try {
      // Create logistics entry
      await _logisticsService.createLogisticsEntry(
        orderId: order.id,
        transporterId: user.id,
        notes: '',
      );

      // Update order status to picked_up
      await _orderService.updateOrderStatus(order.id, 'picked_up');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pickup Accepted!')),
        );
        _loadPickups();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Pickups')),
      body: RefreshIndicator(
        onRefresh: () async => _loadPickups(),
        child: _availablePickups.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  const SizedBox(height: 100),
                  Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'You\'re all caught up!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new delivery requests.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _loadPickups,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
              itemCount: _availablePickups.length,
              itemBuilder: (context, index) {
                final order = _availablePickups[index];
                final produce = _produceService.getProduceById(order.produceId);
                
                return OrderCard(
                  order: order,
                  produce: produce,
                  trailing: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _acceptPickup(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: _isProcessing 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Accept Pickup', style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
      ),
    );
  }
}
