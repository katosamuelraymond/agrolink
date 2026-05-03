import 'package:flutter/material.dart';
import '../../services/logistics_service.dart';
import '../../services/order_service.dart';
import '../../services/session_service.dart';
import '../../services/produce_service.dart';
import '../../models/logistics_model.dart';
import '../../widgets/order_card.dart';

class MyDeliveriesScreen extends StatefulWidget {
  const MyDeliveriesScreen({super.key});

  @override
  State<MyDeliveriesScreen> createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  final _logisticsService = LogisticsService();
  final _orderService = OrderService();
  final _sessionService = SessionService();
  final _produceService = ProduceService();

  List<LogisticsModel> _myDeliveries = [];

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  void _loadDeliveries() {
    final user = _sessionService.currentUser;
    if (user != null) {
      setState(() {
        _myDeliveries = _logisticsService.getDeliveriesForTransporter(user.id);
      });
    }
  }

  Future<void> _updateStatus(LogisticsModel logistics, String newStatus) async {
    await _logisticsService.updateLogisticsStatus(logistics.id, newStatus);
    if (newStatus == 'delivered') {
      await _orderService.updateOrderStatus(logistics.orderId, 'delivered');
    }
    
    if (mounted) {
      _loadDeliveries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delivery marked as $newStatus!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Deliveries')),
      body: _myDeliveries.isEmpty
          ? const Center(child: Text('You have no active deliveries.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _myDeliveries.length,
              itemBuilder: (context, index) {
                final logistics = _myDeliveries[index];
                final order = _orderService.getOrderById(logistics.orderId);
                
                if (order == null) return const SizedBox.shrink();
                
                final produce = _produceService.getProduceById(order.produceId);
                
                Widget? trailing;
                if (logistics.status == 'awaiting') {
                  trailing = ElevatedButton(
                    onPressed: () => _updateStatus(logistics, 'in_transit'),
                    child: const Text('Start Transit'),
                  );
                } else if (logistics.status == 'in_transit') {
                  trailing = ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => _updateStatus(logistics, 'delivered'),
                    child: const Text('Mark Delivered', style: TextStyle(color: Colors.white)),
                  );
                }

                return OrderCard(
                  order: order,
                  produce: produce,
                  trailing: trailing,
                );
              },
            ),
    );
  }
}
