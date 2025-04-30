// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsumptionLogModelAdapter extends TypeAdapter<ConsumptionLogModel> {
  @override
  final int typeId = 6;

  @override
  ConsumptionLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumptionLogModel(
      id: fields[0] as String,
      materialId: fields[1] as String,
      materialName: fields[2] as String,
      quantity: fields[3] as double,
      unit: fields[4] as String,
      unitCost: fields[5] as double,
      totalCost: fields[6] as double,
      productId: fields[7] as String?,
      productName: fields[8] as String?,
      batchNumber: fields[9] as String?,
      consumedAt: fields[10] as DateTime,
      consumedBy: fields[11] as String,
      consumedByName: fields[12] as String,
      notes: fields[13] as String?,
      syncedWithServer: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ConsumptionLogModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.materialId)
      ..writeByte(2)
      ..write(obj.materialName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.unitCost)
      ..writeByte(6)
      ..write(obj.totalCost)
      ..writeByte(7)
      ..write(obj.productId)
      ..writeByte(8)
      ..write(obj.productName)
      ..writeByte(9)
      ..write(obj.batchNumber)
      ..writeByte(10)
      ..write(obj.consumedAt)
      ..writeByte(11)
      ..write(obj.consumedBy)
      ..writeByte(12)
      ..write(obj.consumedByName)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.syncedWithServer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumptionLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
