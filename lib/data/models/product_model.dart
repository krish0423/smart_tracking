import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';

part 'product_model.g.dart';

@HiveType(typeId: 3)
class ProductModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String category;
  
  @HiveField(4)
  final double rawMaterialCost;
  
  @HiveField(5)
  final double manufacturingCost;
  
  @HiveField(6)
  final double totalCost;
  
  @HiveField(7)
  final double suggestedPrice;
  
  @HiveField(8)
  final double actualPrice;
  
  @HiveField(9)
  final double profitMargin;
  
  @HiveField(10)
  final List<ProductMaterial> materials;
  
  @HiveField(11)
  final List<ProductProcess> processes;
  
  @HiveField(12)
  final String qrCode;
  
  @HiveField(13)
  final String barcode;
  
  @HiveField(14)
  final String sku;
  
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

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rawMaterialCost,
    required this.manufacturingCost,
    required this.totalCost,
    required this.suggestedPrice,
    required this.actualPrice,
    required this.profitMargin,
    required this.materials,
    required this.processes,
    required this.qrCode,
    required this.barcode,
    required this.sku,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.isActive = true,
  });
  
  // Factory constructor to create a ProductModel from a JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      rawMaterialCost: (json['rawMaterialCost'] as num).toDouble(),
      manufacturingCost: (json['manufacturingCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      suggestedPrice: (json['suggestedPrice'] as num).toDouble(),
      actualPrice: (json['actualPrice'] as num).toDouble(),
      profitMargin: (json['profitMargin'] as num).toDouble(),
      materials: (json['materials'] as List)
          .map((e) => ProductMaterial.fromJson(e as Map<String, dynamic>))
          .toList(),
      processes: (json['processes'] as List)
          .map((e) => ProductProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
      qrCode: json['qrCode'] as String,
      barcode: json['barcode'] as String,
      sku: json['sku'] as String,
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
  
  // Convert ProductModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'rawMaterialCost': rawMaterialCost,
      'manufacturingCost': manufacturingCost,
      'totalCost': totalCost,
      'suggestedPrice': suggestedPrice,
      'actualPrice': actualPrice,
      'profitMargin': profitMargin,
      'materials': materials.map((e) => e.toJson()).toList(),
      'processes': processes.map((e) => e.toJson()).toList(),
      'qrCode': qrCode,
      'barcode': barcode,
      'sku': sku,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'isActive': isActive,
    };
  }
  
  // Create a copy of ProductModel with some fields replaced
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? rawMaterialCost,
    double? manufacturingCost,
    double? totalCost,
    double? suggestedPrice,
    double? actualPrice,
    double? profitMargin,
    List<ProductMaterial>? materials,
    List<ProductProcess>? processes,
    String? qrCode,
    String? barcode,
    String? sku,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      rawMaterialCost: rawMaterialCost ?? this.rawMaterialCost,
      manufacturingCost: manufacturingCost ?? this.manufacturingCost,
      totalCost: totalCost ?? this.totalCost,
      suggestedPrice: suggestedPrice ?? this.suggestedPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      profitMargin: profitMargin ?? this.profitMargin,
      materials: materials ?? this.materials,
      processes: processes ?? this.processes,
      qrCode: qrCode ?? this.qrCode,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    rawMaterialCost,
    manufacturingCost,
    totalCost,
    suggestedPrice,
    actualPrice,
    profitMargin,
    materials,
    processes,
    qrCode,
    barcode,
    sku,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    isActive,
  ];
}

@HiveType(typeId: 4)
class ProductMaterial extends Equatable {
  @HiveField(0)
  final String materialId;
  
  @HiveField(1)
  final String materialName;
  
  @HiveField(2)
  final double quantity;
  
  @HiveField(3)
  final String unit;
  
  @HiveField(4)
  final double unitCost;
  
  @HiveField(5)
  final double totalCost;

  const ProductMaterial({
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.unitCost,
    required this.totalCost,
  });
  
  // Factory constructor to create a ProductMaterial from a JSON map
  factory ProductMaterial.fromJson(Map<String, dynamic> json) {
    return ProductMaterial(
      materialId: json['materialId'] as String,
      materialName: json['materialName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitCost: (json['unitCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }
  
  // Convert ProductMaterial to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'materialName': materialName,
      'quantity': quantity,
      'unit': unit,
      'unitCost': unitCost,
      'totalCost': totalCost,
    };
  }
  
  @override
  List<Object?> get props => [
    materialId,
    materialName,
    quantity,
    unit,
    unitCost,
    totalCost,
  ];
}

@HiveType(typeId: 5)
class ProductProcess extends Equatable {
  @HiveField(0)
  final String processId;
  
  @HiveField(1)
  final String processName;
  
  @HiveField(2)
  final double duration; // in minutes
  
  @HiveField(3)
  final double laborCost;
  
  @HiveField(4)
  final double overheadCost;
  
  @HiveField(5)
  final double totalCost;

  const ProductProcess({
    required this.processId,
    required this.processName,
    required this.duration,
    required this.laborCost,
    required this.overheadCost,
    required this.totalCost,
  });
  
  // Factory constructor to create a ProductProcess from a JSON map
  factory ProductProcess.fromJson(Map<String, dynamic> json) {
    return ProductProcess(
      processId: json['processId'] as String,
      processName: json['processName'] as String,
      duration: (json['duration'] as num).toDouble(),
      laborCost: (json['laborCost'] as num).toDouble(),
      overheadCost: (json['overheadCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }
  
  // Convert ProductProcess to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'processName': processName,
      'duration': duration,
      'laborCost': laborCost,
      'overheadCost': overheadCost,
      'totalCost': totalCost,
    };
  }
  
  @override
  List<Object?> get props => [
    processId,
    processName,
    duration,
    laborCost,
    overheadCost,
    totalCost,
  ];
} 