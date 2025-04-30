import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:smart_tracking_app/domain/entities/material.dart' as entity;

part 'material_model.g.dart';

@HiveType(typeId: 2)
class MaterialModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String category;
  
  @HiveField(4)
  final String unit;
  
  @HiveField(5)
  final double unitCost;
  
  @HiveField(6)
  final double currentStock;
  
  @HiveField(7)
  final double maxStock;
  
  @HiveField(8)
  final double minStock;
  
  @HiveField(9)
  final String barcode;
  
  @HiveField(10)
  final String qrCode;
  
  @HiveField(11)
  final String supplierId;
  
  @HiveField(12)
  final String supplierName;
  
  @HiveField(13)
  final String location;
  
  @HiveField(14)
  final DateTime lastRestockDate;
  
  @HiveField(15)
  final DateTime createdAt;
  
  @HiveField(16)
  final String createdBy;
  
  @HiveField(17)
  final DateTime? updatedAt;
  
  @HiveField(18)
  final String? updatedBy;
  
  @HiveField(19)
  final bool isActive;

  const MaterialModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    required this.unitCost,
    required this.currentStock,
    required this.maxStock,
    required this.minStock,
    required this.barcode,
    required this.qrCode,
    required this.supplierId,
    required this.supplierName,
    required this.location,
    required this.lastRestockDate,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.isActive = true,
  });
  
  // Calculate if the material is low in stock
  bool get isLowStock => currentStock <= minStock;
  
  // Calculate stock percentage
  double get stockPercentage => (currentStock / maxStock) * 100;
  
  // Factory constructor to create a MaterialModel from a JSON map
  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
      unitCost: (json['unitCost'] as num).toDouble(),
      currentStock: (json['currentStock'] as num).toDouble(),
      maxStock: (json['maxStock'] as num).toDouble(),
      minStock: (json['minStock'] as num).toDouble(),
      barcode: json['barcode'] as String,
      qrCode: json['qrCode'] as String,
      supplierId: json['supplierId'] as String,
      supplierName: json['supplierName'] as String,
      location: json['location'] as String,
      lastRestockDate: (json['lastRestockDate'] != null)
          ? (json['lastRestockDate'] as Timestamp).toDate()
          : DateTime.now(),
      createdAt: (json['createdAt'] != null)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      createdBy: json['createdBy'] as String,
      updatedAt: (json['updatedAt'] != null)
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      updatedBy: json['updatedBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
  
  // Convert MaterialModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'unit': unit,
      'unitCost': unitCost,
      'currentStock': currentStock,
      'maxStock': maxStock,
      'minStock': minStock,
      'barcode': barcode,
      'qrCode': qrCode,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'location': location,
      'lastRestockDate': lastRestockDate,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'isActive': isActive,
    };
  }
  
  // Create a copy of MaterialModel with some fields replaced
  MaterialModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? unit,
    double? unitCost,
    double? currentStock,
    double? maxStock,
    double? minStock,
    String? barcode,
    String? qrCode,
    String? supplierId,
    String? supplierName,
    String? location,
    DateTime? lastRestockDate,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    bool? isActive,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      unitCost: unitCost ?? this.unitCost,
      currentStock: currentStock ?? this.currentStock,
      maxStock: maxStock ?? this.maxStock,
      minStock: minStock ?? this.minStock,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      location: location ?? this.location,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
    );
  }
  
  // Update stock level
  MaterialModel updateStock(double newStockLevel, {String? updatedByUserId}) {
    return copyWith(
      currentStock: newStockLevel,
      updatedAt: DateTime.now(),
      updatedBy: updatedByUserId,
    );
  }
  
  // Reduce stock by consumption amount
  MaterialModel consumeStock(double amount, {String? updatedByUserId}) {
    final newStock = currentStock - amount;
    return updateStock(newStock > 0 ? newStock : 0, updatedByUserId: updatedByUserId);
  }
  
  // Add stock from restock
  MaterialModel addStock(double amount, {String? updatedByUserId}) {
    return copyWith(
      currentStock: currentStock + amount,
      lastRestockDate: DateTime.now(),
      updatedAt: DateTime.now(),
      updatedBy: updatedByUserId,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    unit,
    unitCost,
    currentStock,
    maxStock,
    minStock,
    barcode,
    qrCode,
    supplierId,
    supplierName,
    location,
    lastRestockDate,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    isActive,
  ];
}

class MaterialModel extends entity.Material {
  MaterialModel({
    required String id,
    required String name,
    required String description,
    String? barcode,
    String? qrCode,
    String? sku,
    required entity.MaterialUnit unit,
    required double costPerUnit,
    required double currentStock,
    required double reorderLevel,
    required double criticalLevel,
    String? supplier,
    String? supplierContact,
    String? imageUrl,
    String? location,
    Map<String, dynamic>? additionalProperties,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
  }) : super(
          id: id,
          name: name,
          description: description,
          barcode: barcode,
          qrCode: qrCode,
          sku: sku,
          unit: unit,
          costPerUnit: costPerUnit,
          currentStock: currentStock,
          reorderLevel: reorderLevel,
          criticalLevel: criticalLevel,
          supplier: supplier,
          supplierContact: supplierContact,
          imageUrl: imageUrl,
          location: location,
          additionalProperties: additionalProperties,
          createdAt: createdAt,
          updatedAt: updatedAt,
          createdBy: createdBy,
        );

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      barcode: json['barcode'] as String?,
      qrCode: json['qrCode'] as String?,
      sku: json['sku'] as String?,
      unit: _parseUnit(json['unit'] as String),
      costPerUnit: (json['costPerUnit'] as num).toDouble(),
      currentStock: (json['currentStock'] as num).toDouble(),
      reorderLevel: (json['reorderLevel'] as num).toDouble(),
      criticalLevel: (json['criticalLevel'] as num).toDouble(),
      supplier: json['supplier'] as String?,
      supplierContact: json['supplierContact'] as String?,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      additionalProperties: json['additionalProperties'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'barcode': barcode,
      'qrCode': qrCode,
      'sku': sku,
      'unit': unit.toString().split('.').last,
      'costPerUnit': costPerUnit,
      'currentStock': currentStock,
      'reorderLevel': reorderLevel,
      'criticalLevel': criticalLevel,
      'supplier': supplier,
      'supplierContact': supplierContact,
      'imageUrl': imageUrl,
      'location': location,
      'additionalProperties': additionalProperties,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  factory MaterialModel.fromEntity(entity.Material material) {
    return MaterialModel(
      id: material.id,
      name: material.name,
      description: material.description,
      barcode: material.barcode,
      qrCode: material.qrCode,
      sku: material.sku,
      unit: material.unit,
      costPerUnit: material.costPerUnit,
      currentStock: material.currentStock,
      reorderLevel: material.reorderLevel,
      criticalLevel: material.criticalLevel,
      supplier: material.supplier,
      supplierContact: material.supplierContact,
      imageUrl: material.imageUrl,
      location: material.location,
      additionalProperties: material.additionalProperties,
      createdAt: material.createdAt,
      updatedAt: material.updatedAt,
      createdBy: material.createdBy,
    );
  }

  MaterialModel copyWith({
    String? id,
    String? name,
    String? description,
    String? barcode,
    String? qrCode,
    String? sku,
    entity.MaterialUnit? unit,
    double? costPerUnit,
    double? currentStock,
    double? reorderLevel,
    double? criticalLevel,
    String? supplier,
    String? supplierContact,
    String? imageUrl,
    String? location,
    Map<String, dynamic>? additionalProperties,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
      sku: sku ?? this.sku,
      unit: unit ?? this.unit,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      currentStock: currentStock ?? this.currentStock,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      criticalLevel: criticalLevel ?? this.criticalLevel,
      supplier: supplier ?? this.supplier,
      supplierContact: supplierContact ?? this.supplierContact,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      additionalProperties: additionalProperties ?? this.additionalProperties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  static entity.MaterialUnit _parseUnit(String unitString) {
    switch (unitString) {
      case 'kg':
        return entity.MaterialUnit.kg;
      case 'grams':
        return entity.MaterialUnit.grams;
      case 'liters':
        return entity.MaterialUnit.liters;
      case 'meters':
        return entity.MaterialUnit.meters;
      case 'pieces':
        return entity.MaterialUnit.pieces;
      case 'sheets':
        return entity.MaterialUnit.sheets;
      case 'rolls':
        return entity.MaterialUnit.rolls;
      default:
        return entity.MaterialUnit.other;
    }
  }
} 