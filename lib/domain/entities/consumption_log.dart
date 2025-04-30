import 'package:equatable/equatable.dart';

class ConsumptionLog extends Equatable {
  final String id;
  final String materialId;
  final String materialName;
  final double quantity;
  final double costPerUnit;
  final double totalCost;
  final String userId;
  final String userName;
  final String? productId;
  final String? productName;
  final String? notes;
  final DateTime timestamp;
  final bool isSynced;
  final String? batchId;
  final String? locationId;

  const ConsumptionLog({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.costPerUnit,
    required this.totalCost,
    required this.userId,
    required this.userName,
    this.productId,
    this.productName,
    this.notes,
    required this.timestamp,
    this.isSynced = false,
    this.batchId,
    this.locationId,
  });

  factory ConsumptionLog.create({
    required String id,
    required String materialId,
    required String materialName,
    required double quantity,
    required double costPerUnit,
    required String userId,
    required String userName,
    String? productId,
    String? productName,
    String? notes,
    String? batchId,
    String? locationId,
  }) {
    return ConsumptionLog(
      id: id,
      materialId: materialId,
      materialName: materialName,
      quantity: quantity,
      costPerUnit: costPerUnit,
      totalCost: quantity * costPerUnit,
      userId: userId,
      userName: userName,
      productId: productId,
      productName: productName,
      notes: notes,
      timestamp: DateTime.now(),
      isSynced: false,
      batchId: batchId,
      locationId: locationId,
    );
  }

  ConsumptionLog copyWith({
    String? id,
    String? materialId,
    String? materialName,
    double? quantity,
    double? costPerUnit,
    double? totalCost,
    String? userId,
    String? userName,
    String? productId,
    String? productName,
    String? notes,
    DateTime? timestamp,
    bool? isSynced,
    String? batchId,
    String? locationId,
  }) {
    return ConsumptionLog(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      totalCost: totalCost ?? this.totalCost,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      batchId: batchId ?? this.batchId,
      locationId: locationId ?? this.locationId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        materialId,
        materialName,
        quantity,
        costPerUnit,
        totalCost,
        userId,
        userName,
        productId,
        productName,
        notes,
        timestamp,
        isSynced,
        batchId,
        locationId,
      ];
} 