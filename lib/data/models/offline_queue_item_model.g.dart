// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_queue_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineQueueItemModelAdapter extends TypeAdapter<OfflineQueueItemModel> {
  @override
  final int typeId = 9;

  @override
  OfflineQueueItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineQueueItemModel(
      id: fields[0] as String,
      operationType: fields[1] as OfflineOperationType,
      entityType: fields[2] as OfflineEntityType,
      data: (fields[3] as Map).cast<String, dynamic>(),
      createdAt: fields[4] as DateTime,
      retryCount: fields[5] as int,
      isPriority: fields[6] as bool,
      lastRetryAt: fields[7] as DateTime?,
      errorMessage: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineQueueItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operationType)
      ..writeByte(2)
      ..write(obj.entityType)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.retryCount)
      ..writeByte(6)
      ..write(obj.isPriority)
      ..writeByte(7)
      ..write(obj.lastRetryAt)
      ..writeByte(8)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineQueueItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineOperationTypeAdapter extends TypeAdapter<OfflineOperationType> {
  @override
  final int typeId = 7;

  @override
  OfflineOperationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OfflineOperationType.create;
      case 1:
        return OfflineOperationType.update;
      case 2:
        return OfflineOperationType.delete;
      case 3:
        return OfflineOperationType.scan;
      default:
        return OfflineOperationType.create;
    }
  }

  @override
  void write(BinaryWriter writer, OfflineOperationType obj) {
    switch (obj) {
      case OfflineOperationType.create:
        writer.writeByte(0);
        break;
      case OfflineOperationType.update:
        writer.writeByte(1);
        break;
      case OfflineOperationType.delete:
        writer.writeByte(2);
        break;
      case OfflineOperationType.scan:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineOperationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OfflineEntityTypeAdapter extends TypeAdapter<OfflineEntityType> {
  @override
  final int typeId = 8;

  @override
  OfflineEntityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OfflineEntityType.material;
      case 1:
        return OfflineEntityType.product;
      case 2:
        return OfflineEntityType.user;
      case 3:
        return OfflineEntityType.consumptionLog;
      default:
        return OfflineEntityType.material;
    }
  }

  @override
  void write(BinaryWriter writer, OfflineEntityType obj) {
    switch (obj) {
      case OfflineEntityType.material:
        writer.writeByte(0);
        break;
      case OfflineEntityType.product:
        writer.writeByte(1);
        break;
      case OfflineEntityType.user:
        writer.writeByte(2);
        break;
      case OfflineEntityType.consumptionLog:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineEntityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
