import 'package:hive/hive.dart';

part 'logistics_model.g.dart';

@HiveType(typeId: 4)
class LogisticsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final String transporterId;

  @HiveField(3)
  final DateTime? pickupTime;

  @HiveField(4)
  final DateTime? deliveryTime;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String notes;

  LogisticsModel({
    required this.id,
    required this.orderId,
    required this.transporterId,
    this.pickupTime,
    this.deliveryTime,
    required this.status,
    required this.notes,
  });
}
