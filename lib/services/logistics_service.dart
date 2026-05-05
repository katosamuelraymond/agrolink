import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/logistics_model.dart';

class LogisticsService {
  Box<LogisticsModel> get _logisticsBox => Hive.box<LogisticsModel>('logistics');
  final _uuid = const Uuid();

  Future<LogisticsModel> createLogisticsEntry({
    required String orderId,
    required String transporterId,
    required String notes,
  }) async {
    final id = _uuid.v4();
    final logistics = LogisticsModel(
      id: id,
      orderId: orderId,
      transporterId: transporterId,
      status: 'awaiting',
      notes: notes,
    );

    await _logisticsBox.put(id, logistics);
    return logistics;
  }

  List<LogisticsModel> getDeliveriesForTransporter(String transporterId) {
    return _logisticsBox.values.where((l) => l.transporterId == transporterId).toList();
  }

  LogisticsModel? getLogisticsByOrderId(String orderId) {
    try {
      return _logisticsBox.values.firstWhere((l) => l.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  List<LogisticsModel> getDeliveriesForOrder(String orderId) {
  return _logisticsBox.values.where((l) => l.orderId == orderId).toList();
}

  LogisticsModel? getLogisticsById(String id) {
    return _logisticsBox.get(id);
  }

  Future<void> updateLogisticsStatus(String id, String status) async {
    final logistics = getLogisticsById(id);
    if (logistics != null) {
      final updated = LogisticsModel(
        id: logistics.id,
        orderId: logistics.orderId,
        transporterId: logistics.transporterId,
        pickupTime: status == 'in_transit' ? DateTime.now() : logistics.pickupTime,
        deliveryTime: status == 'delivered' ? DateTime.now() : logistics.deliveryTime,
        status: status,
        notes: logistics.notes,
      );
      await _logisticsBox.put(id, updated);
    }
  }
}
