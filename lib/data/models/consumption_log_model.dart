import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';

part 'consumption_log_model.g.dart';

@HiveType(typeId: 6)
class ConsumptionLogModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String materialId;
  
  @HiveField(2)
  final String materialName;
  
  @HiveField(3)
  final double quantity;
  
  @HiveField(4)
  final String unit;
  
  @HiveField(5)
  final double unitCost;
  
  @HiveField(6)
  final double totalCost;
  
  @HiveField(7)
  final String? productId;
  
  @HiveField(8)
  final String? productName;
  
  @HiveField(9)
  final String? batchNumber;
  
  @HiveField(10)
  final DateTime consumedAt;
  
  @HiveField(11)
  final String consumedBy;
  
  @HiveField(12)
  final String consumedByName;
  
  @HiveField(13)
  final String? notes;
  
  @HiveField(14)
  final bool syncedWithServer;

  const ConsumptionLogModel({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.unitCost,
    required this.totalCost,
    this.productId,
    this.productName,
    this.batchNumber,
    required this.consumedAt,
    required this.consumedBy,
    required this.consumedByName,
    this.notes,
    this.syncedWithServer = false,
  });
  
  // Factory constructor to create a ConsumptionLogModel from a JSON map
  factory ConsumptionLogModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionLogModel(
      id: json['id'] as String,
      materialId: json['materialId'] as String,
      materialName: json['materialName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitCost: (json['unitCost'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      batchNumber: json['batchNumber'] as String?,
      consumedAt: (json['consumedAt'] != null)
          ? (json['consumedAt'] as Timestamp).toDate()
          : DateTime.now(),
      consumedBy: json['consumedBy'] as String,
      consumedByName: json['consumedByName'] as String,
      notes: json['notes'] as String?,
      syncedWithServer: json['syncedWithServer'] as bool? ?? false,
    );
  }
  
  // Convert ConsumptionLogModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialId': materialId,
      'materialName': materialName,
      'quantity': quantity,
      'unit': unit,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'productId': productId,
      'productName': productName,
      'batchNumber': batchNumber,
      'consumedAt': consumedAt,
      'consumedBy': consumedBy,
      'consumedByName': consumedByName,
      'notes': notes,
      'syncedWithServer': syncedWithServer,
    };
  }
  
  // Create a copy of ConsumptionLogModel with some fields replaced
  ConsumptionLogModel copyWith({
    String? id,
    String? materialId,
    String? materialName,
    double? quantity,
    String? unit,
    double? unitCost,
    double? totalCost,
    String? productId,
    String? productName,
    String? batchNumber,
    DateTime? consumedAt,
    String? consumedBy,
    String? consumedByName,
    String? notes,
    bool? syncedWithServer,
  }) {
    return ConsumptionLogModel(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitCost: unitCost ?? this.unitCost,
      totalCost: totalCost ?? this.totalCost,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      batchNumber: batchNumber ?? this.batchNumber,
      consumedAt: consumedAt ?? this.consumedAt,
      consumedBy: consumedBy ?? this.consumedBy,
      consumedByName: consumedByName ?? this.consumedByName,
      notes: notes ?? this.notes,
      syncedWithServer: syncedWithServer ?? this.syncedWithServer,
    );
  }
  
  // Mark as synced with server
  ConsumptionLogModel markAsSynced() {
    return copyWith(syncedWithServer: true);
  }
  
  @override
  List<Object?> get props => [
    id,
    materialId,
    materialName,
    quantity,
    unit,
    unitCost,
    totalCost,
    productId,
    productName,
    batchNumber,
    consumedAt,
    consumedBy,
    consumedByName,
    notes,
    syncedWithServer,
  ];
} 