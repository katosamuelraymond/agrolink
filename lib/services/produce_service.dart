import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/produce_model.dart';

class ProduceService {
  Box<ProduceModel> get _produceBox => Hive.box<ProduceModel>('produce');
  final _uuid = const Uuid();

  Future<ProduceModel> addProduce({
    required String farmerId,
    required String cropName,
    required double quantity,
    required String unit,
    required double pricePerUnit,
    required String description,
  }) async {
    final id = _uuid.v4();
    final produce = ProduceModel(
      id: id,
      farmerId: farmerId,
      cropName: cropName,
      quantity: quantity,
      unit: unit,
      pricePerUnit: pricePerUnit,
      description: description,
      status: 'available',
      createdAt: DateTime.now(),
    );

    await _produceBox.put(id, produce);
    return produce;
  }

  List<ProduceModel> getProduceByFarmer(String farmerId) {
    return _produceBox.values.where((p) => p.farmerId == farmerId).toList();
  }

  List<ProduceModel> getAllAvailableProduce() {
    return _produceBox.values.where((p) => p.status == 'available').toList();
  }

  ProduceModel? getProduceById(String id) {
    return _produceBox.get(id);
  }

  Future<void> updateProduceStatus(String id, String status) async {
    final produce = getProduceById(id);
    if (produce != null) {
      final updated = ProduceModel(
        id: produce.id,
        farmerId: produce.farmerId,
        cropName: produce.cropName,
        quantity: produce.quantity,
        unit: produce.unit,
        pricePerUnit: produce.pricePerUnit,
        description: produce.description,
        status: status,
        createdAt: produce.createdAt,
      );
      await _produceBox.put(id, updated);
    }
  }

  Future<void> deleteProduce(String id) async {
    await _produceBox.delete(id);
  }

  Future<void> updateProduce({
    required String id,
    required String cropName,
    required double quantity,
    required String unit,
    required double pricePerUnit,
    required String description,
  }) async {
    final produce = getProduceById(id);
    if (produce != null) {
      final updated = ProduceModel(
        id: produce.id,
        farmerId: produce.farmerId,
        cropName: cropName,
        quantity: quantity,
        unit: unit,
        pricePerUnit: pricePerUnit,
        description: description,
        status: produce.status,
        createdAt: produce.createdAt,
      );
      await _produceBox.put(id, updated);
    }
  }

  /// Deducts [amount] from produce's quantity.
  /// Automatically sets status to 'sold' if quantity reaches 0.
  Future<void> deductQuantity(String id, double amount) async {
    final produce = getProduceById(id);
    if (produce == null) return;

    final newQuantity = (produce.quantity - amount).clamp(0.0, double.infinity);
    final newStatus = newQuantity <= 0 ? 'sold' : produce.status;

    final updated = ProduceModel(
      id: produce.id,
      farmerId: produce.farmerId,
      cropName: produce.cropName,
      quantity: newQuantity,
      unit: produce.unit,
      pricePerUnit: produce.pricePerUnit,
      description: produce.description,
      status: newStatus,
      createdAt: produce.createdAt,
    );
    await _produceBox.put(id, updated);
  }
}
