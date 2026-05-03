import 'package:flutter/material.dart';
import '../../services/produce_service.dart';
import '../../services/order_service.dart';
import '../../services/session_service.dart';
import '../../models/produce_model.dart';
import '../../widgets/produce_card.dart';

class BrowseProduceScreen extends StatefulWidget {
  const BrowseProduceScreen({super.key});

  @override
  State<BrowseProduceScreen> createState() => _BrowseProduceScreenState();
}

class _BrowseProduceScreenState extends State<BrowseProduceScreen> {
  final _produceService = ProduceService();
  final _orderService = OrderService();
  final _sessionService = SessionService();

  List<ProduceModel> _availableProduce = [];

  @override
  void initState() {
    super.initState();
    _loadProduce();
  }

  void _loadProduce() {
    setState(() {
      _availableProduce = _produceService.getAllAvailableProduce();
    });
  }

  void _showOrderDialog(ProduceModel produce) {
    double quantity = 1;
    final deliveryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            double totalPrice = quantity * produce.pricePerUnit;
            return AlertDialog(
              title: Text('Order ${produce.cropName}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Price: UGX ${produce.pricePerUnit} per ${produce.unit}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity:'),
                        Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(quantity.toStringAsFixed(0), style: const TextStyle(fontSize: 18)),
                            IconButton(
                              onPressed: quantity < produce.quantity ? () => setState(() => quantity++) : null,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: deliveryController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total: UGX $totalPrice',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (deliveryController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter delivery location')),
                      );
                      return;
                    }
                    
                    final user = _sessionService.currentUser;
                    if (user != null) {
                      await _orderService.placeOrder(
                        produceId: produce.id,
                        buyerId: user.id,
                        farmerId: produce.farmerId,
                        quantityOrdered: quantity,
                        totalPrice: totalPrice,
                        pickupLocation: 'Farm', // Mocked pickup location for now
                        deliveryLocation: deliveryController.text,
                      );
                      
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed successfully!')),
                        );
                      }
                    }
                  },
                  child: const Text('Place Order'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Produce')),
      body: _availableProduce.isEmpty
          ? const Center(child: Text('No produce available right now.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _availableProduce.length,
              itemBuilder: (context, index) {
                final produce = _availableProduce[index];
                return ProduceCard(
                  produce: produce,
                  onTap: () => _showOrderDialog(produce),
                );
              },
            ),
    );
  }
}
