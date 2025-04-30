import 'package:equatable/equatable.dart';

class MaterialRequirement {
  final String materialId;
  final String materialName;
  final double requiredQuantity;
  
  const MaterialRequirement({
    required this.materialId,
    required this.materialName,
    required this.requiredQuantity,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'materialName': materialName,
      'requiredQuantity': requiredQuantity,
    };
  }
  
  factory MaterialRequirement.fromMap(Map<String, dynamic> map) {
    return MaterialRequirement(
      materialId: map['materialId'],
      materialName: map['materialName'],
      requiredQuantity: map['requiredQuantity'].toDouble(),
    );
  }
}

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? sku;
  final List<MaterialRequirement> materials;
  final double laborCostPerUnit;
  final double overheadCostPerUnit;
  final double suggestedPrice;
  final double profitMargin;
  final String? imageUrl;
  final Map<String, dynamic>? additionalProperties;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.sku,
    required this.materials,
    required this.laborCostPerUnit,
    required this.overheadCostPerUnit,
    required this.suggestedPrice,
    required this.profitMargin,
    this.imageUrl,
    this.additionalProperties,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  double get materialCost {
    // This would normally calculate based on current material prices
    // For now, leaving this as a placeholder
    return 0.0;
  }
  
  double get totalCostPerUnit => 
      materialCost + laborCostPerUnit + overheadCostPerUnit;
  
  double get calculatedProfit => suggestedPrice - totalCostPerUnit;
  
  double get calculatedProfitMargin => 
      totalCostPerUnit > 0 ? (calculatedProfit / totalCostPerUnit) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        sku,
        materials,
        laborCostPerUnit,
        overheadCostPerUnit,
        suggestedPrice,
        profitMargin,
        imageUrl,
        additionalProperties,
        createdAt,
        updatedAt,
        createdBy,
      ];
} 