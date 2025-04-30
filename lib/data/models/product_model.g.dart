// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 3;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      rawMaterialCost: fields[4] as double,
      manufacturingCost: fields[5] as double,
      totalCost: fields[6] as double,
      suggestedPrice: fields[7] as double,
      actualPrice: fields[8] as double,
      profitMargin: fields[9] as double,
      materials: (fields[10] as List).cast<ProductMaterial>(),
      processes: (fields[11] as List).cast<ProductProcess>(),
      qrCode: fields[12] as String,
      barcode: fields[13] as String,
      sku: fields[14] as String,
      createdAt: fields[15] as DateTime,
      createdBy: fields[16] as String,
      updatedAt: fields[17] as DateTime?,
      updatedBy: fields[18] as String?,
      isActive: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
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
      ..write(obj.rawMaterialCost)
      ..writeByte(5)
      ..write(obj.manufacturingCost)
      ..writeByte(6)
      ..write(obj.totalCost)
      ..writeByte(7)
      ..write(obj.suggestedPrice)
      ..writeByte(8)
      ..write(obj.actualPrice)
      ..writeByte(9)
      ..write(obj.profitMargin)
      ..writeByte(10)
      ..write(obj.materials)
      ..writeByte(11)
      ..write(obj.processes)
      ..writeByte(12)
      ..write(obj.qrCode)
      ..writeByte(13)
      ..write(obj.barcode)
      ..writeByte(14)
      ..write(obj.sku)
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
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductMaterialAdapter extends TypeAdapter<ProductMaterial> {
  @override
  final int typeId = 4;

  @override
  ProductMaterial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductMaterial(
      materialId: fields[0] as String,
      materialName: fields[1] as String,
      quantity: fields[2] as double,
      unit: fields[3] as String,
      unitCost: fields[4] as double,
      totalCost: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductMaterial obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.materialId)
      ..writeByte(1)
      ..write(obj.materialName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.unitCost)
      ..writeByte(5)
      ..write(obj.totalCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductMaterialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductProcessAdapter extends TypeAdapter<ProductProcess> {
  @override
  final int typeId = 5;

  @override
  ProductProcess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductProcess(
      processId: fields[0] as String,
      processName: fields[1] as String,
      duration: fields[2] as double,
      laborCost: fields[3] as double,
      overheadCost: fields[4] as double,
      totalCost: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProductProcess obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.processId)
      ..writeByte(1)
      ..write(obj.processName)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.laborCost)
      ..writeByte(4)
      ..write(obj.overheadCost)
      ..writeByte(5)
      ..write(obj.totalCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductProcessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
