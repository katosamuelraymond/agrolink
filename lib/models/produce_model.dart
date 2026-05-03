import 'package:hive/hive.dart';

part 'produce_model.g.dart';

@HiveType(typeId: 1)
class ProduceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String farmerId;

  @HiveField(2)
  final String cropName;

  @HiveField(3)
  final double quantity;

  @HiveField(4)
  final String unit;

  @HiveField(5)
  final double pricePerUnit;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final String status;

  @HiveField(8)
  final DateTime createdAt;

  ProduceModel({
    required this.id,
    required this.farmerId,
    required this.cropName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}
