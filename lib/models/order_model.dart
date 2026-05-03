import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String produceId;

  @HiveField(2)
  final String buyerId;

  @HiveField(3)
  final String farmerId;

  @HiveField(4)
  final double quantityOrdered;

  @HiveField(5)
  final double totalPrice;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final String pickupLocation;

  @HiveField(8)
  final String deliveryLocation;

  @HiveField(9)
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.produceId,
    required this.buyerId,
    required this.farmerId,
    required this.quantityOrdered,
    required this.totalPrice,
    required this.status,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.createdAt,
  });
}
