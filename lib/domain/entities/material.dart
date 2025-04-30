import 'package:equatable/equatable.dart';

enum MaterialUnit {
  kg,
  grams,
  liters,
  meters,
  pieces,
  sheets,
  rolls,
  other,
}

class Material extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? barcode;
  final String? qrCode;
  final String? sku;
  final MaterialUnit unit;
  final double costPerUnit;
  final double currentStock;
  final double reorderLevel;
  final double criticalLevel;
  final String? supplier;
  final String? supplierContact;
  final String? imageUrl;
  final String? location;
  final Map<String, dynamic>? additionalProperties;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Material({
    required this.id,
    required this.name,
    required this.description,
    this.barcode,
    this.qrCode,
    this.sku,
    required this.unit,
    required this.costPerUnit,
    required this.currentStock,
    required this.reorderLevel,
    required this.criticalLevel,
    this.supplier,
    this.supplierContact,
    this.imageUrl,
    this.location,
    this.additionalProperties,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  bool get isLowStock => currentStock <= reorderLevel;
  bool get isCriticalStock => currentStock <= criticalLevel;
  
  double get totalValue => currentStock * costPerUnit;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        barcode,
        qrCode,
        sku,
        unit,
        costPerUnit,
        currentStock,
        reorderLevel,
        criticalLevel,
        supplier,
        supplierContact,
        imageUrl,
        location,
        additionalProperties,
        createdAt,
        updatedAt,
        createdBy,
      ];
} 