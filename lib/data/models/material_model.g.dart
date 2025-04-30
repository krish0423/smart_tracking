// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialModelAdapter extends TypeAdapter<MaterialModel> {
  @override
  final int typeId = 2;

  @override
  MaterialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      unit: fields[4] as String,
      unitCost: fields[5] as double,
      currentStock: fields[6] as double,
      maxStock: fields[7] as double,
      minStock: fields[8] as double,
      barcode: fields[9] as String,
      qrCode: fields[10] as String,
      supplierId: fields[11] as String,
      supplierName: fields[12] as String,
      location: fields[13] as String,
      lastRestockDate: fields[14] as DateTime,
      createdAt: fields[15] as DateTime,
      createdBy: fields[16] as String,
      updatedAt: fields[17] as DateTime?,
      updatedBy: fields[18] as String?,
      isActive: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.unitCost)
      ..writeByte(6)
      ..write(obj.currentStock)
      ..writeByte(7)
      ..write(obj.maxStock)
      ..writeByte(8)
      ..write(obj.minStock)
      ..writeByte(9)
      ..write(obj.barcode)
      ..writeByte(10)
      ..write(obj.qrCode)
      ..writeByte(11)
      ..write(obj.supplierId)
      ..writeByte(12)
      ..write(obj.supplierName)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.lastRestockDate)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.createdBy)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.updatedBy)
      ..writeByte(19)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
