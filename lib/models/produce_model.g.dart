// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produce_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProduceModelAdapter extends TypeAdapter<ProduceModel> {
  @override
  final int typeId = 1;

  @override
  ProduceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProduceModel(
      id: fields[0] as String,
      farmerId: fields[1] as String,
      cropName: fields[2] as String,
      quantity: fields[3] as double,
      unit: fields[4] as String,
      pricePerUnit: fields[5] as double,
      description: fields[6] as String,
      status: fields[7] as String,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProduceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.cropName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.pricePerUnit)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProduceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
