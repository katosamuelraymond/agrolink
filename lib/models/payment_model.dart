import 'package:hive/hive.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 3)
class PaymentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String method;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime paidAt;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAt,
  });
}
