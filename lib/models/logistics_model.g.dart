// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogisticsModelAdapter extends TypeAdapter<LogisticsModel> {
  @override
  final int typeId = 4;

  @override
  LogisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogisticsModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      transporterId: fields[2] as String,
      pickupTime: fields[3] as DateTime?,
      deliveryTime: fields[4] as DateTime?,
      status: fields[5] as String,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LogisticsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.transporterId)
      ..writeByte(3)
      ..write(obj.pickupTime)
      ..writeByte(4)
      ..write(obj.deliveryTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
