import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';

class OrderService {
  Box<OrderModel> get _orderBox => Hive.box<OrderModel>('orders');
  final _uuid = const Uuid();

  Future<OrderModel> placeOrder({
    required String produceId,
    required String buyerId,
    required String farmerId,
    required double quantityOrdered,
    required double totalPrice,
    required String pickupLocation,
    required String deliveryLocation,
  }) async {
    final id = _uuid.v4();
    final order = OrderModel(
      id: id,
      produceId: produceId,
      buyerId: buyerId,
      farmerId: farmerId,
      quantityOrdered: quantityOrdered,
      totalPrice: totalPrice,
      status: 'pending',
      pickupLocation: pickupLocation,
      deliveryLocation: deliveryLocation,
      createdAt: DateTime.now(),
    );

    await _orderBox.put(id, order);
    return order;
  }

  List<OrderModel> getOrdersForBuyer(String buyerId) {
    return _orderBox.values.where((o) => o.buyerId == buyerId).toList();
  }

  List<OrderModel> getOrdersForFarmer(String farmerId) {
    return _orderBox.values.where((o) => o.farmerId == farmerId).toList();
  }

  List<OrderModel> getAllConfirmedOrders() {
    return _orderBox.values.where((o) => o.status == 'confirmed').toList();
  }

  OrderModel? getOrderById(String id) {
    return _orderBox.get(id);
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final order = getOrderById(id);
    if (order != null) {
      final updated = OrderModel(
        id: order.id,
        produceId: order.produceId,
        buyerId: order.buyerId,
        farmerId: order.farmerId,
        quantityOrdered: order.quantityOrdered,
        totalPrice: order.totalPrice,
        status: status,
        pickupLocation: order.pickupLocation,
        deliveryLocation: order.deliveryLocation,
        createdAt: order.createdAt,
      );
      await _orderBox.put(id, updated);
    }
  }
}
