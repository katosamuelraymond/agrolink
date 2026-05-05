import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../models/produce_model.dart';
import '../services/user_service.dart';
import '../services/logistics_service.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final ProduceModel? produce;
  final VoidCallback? onTap;
  final Widget? trailing;

  const OrderCard({
    super.key,
    required this.order,
    this.produce,
    this.onTap,
    this.trailing,
  });

  Color _getStatusColor() {
    switch (order.status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'picked_up': return Colors.purple;
      case 'in_transit': return Colors.indigo;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'UGX ', decimalDigits: 0);
    final userService = UserService();
    final logisticsService = LogisticsService();

    final buyer = userService.getUserById(order.buyerId);
    final farmer = userService.getUserById(order.farmerId);

    // Find transporter if order has been picked up
    final logisticsEntries = logisticsService.getDeliveriesForOrder(order.id);
    final transporter = logisticsEntries.isNotEmpty
        ? userService.getUserById(logisticsEntries.first.transporterId)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row: Crop name + status badge ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      produce?.cropName ?? 'Unknown Produce',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor()),
                    ),
                    child: Text(
                      order.status.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Quantity + Price ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    'Qty Ordered',
                    '${order.quantityOrdered} ${produce?.unit ?? ''}',
                    Icons.shopping_cart_outlined,
                  ),
                  _buildInfoColumn(
                    'Total',
                    currencyFormat.format(order.totalPrice),
                    Icons.payments_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // ── People involved ──
              if (buyer != null)
                _buildPersonRow(Icons.person, 'Buyer', buyer.fullName, buyer.phone, Colors.blue),
              if (farmer != null)
                _buildPersonRow(Icons.agriculture, 'Farmer', farmer.fullName, farmer.phone, Colors.green),
              if (transporter != null) ...[
                const SizedBox(height: 4),
                _buildPersonRow(Icons.local_shipping, 'Transporter', transporter.fullName, transporter.phone, Colors.purple),
              ],

              const SizedBox(height: 8),

              // ── Delivery location + action button ──
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'To: ${order.deliveryLocation}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonRow(IconData icon, String role, String name, String phone, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            '$role: ',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Text(
            '(+256 $phone)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}
