import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';

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