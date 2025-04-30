import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/consumption_log_model.dart';
import 'package:dartz/dartz.dart';

abstract class ReportsRepository {
  /// Get consumption by material for a date range
  Future<Either<Failure, Map<String, double>>> getConsumptionByMaterial(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Get consumption by product for a date range
  Future<Either<Failure, Map<String, double>>> getConsumptionByProduct(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Get consumption by user for a date range
  Future<Either<Failure, Map<String, double>>> getConsumptionByUser(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Get consumption by category for a date range
  Future<Either<Failure, Map<String, double>>> getConsumptionByCategory(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Get consumption trends for a material
  Future<Either<Failure, List<ConsumptionTrend>>> getMaterialConsumptionTrend(
    String materialId,
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Generate cost breakdown report for a product
  Future<Either<Failure, ProductCostBreakdown>> getProductCostBreakdown(String productId);
  
  /// Generate PDF report of material consumption
  Future<Either<Failure, String>> generateMaterialConsumptionPDF(
    DateTime startDate,
    DateTime endDate,
    String? materialId,
  );
  
  /// Generate CSV report of material consumption
  Future<Either<Failure, String>> generateMaterialConsumptionCSV(
    DateTime startDate,
    DateTime endDate,
    String? materialId,
  );
  
  /// Generate PDF report of product cost breakdown
  Future<Either<Failure, String>> generateProductCostBreakdownPDF(String productId);
  
  /// Generate CSV report of product cost breakdown
  Future<Either<Failure, String>> generateProductCostBreakdownCSV(String productId);
  
  /// Get low stock alerts
  Future<Either<Failure, List<LowStockAlert>>> getLowStockAlerts();
}

/// Product cost breakdown model
class ProductCostBreakdown {
  final String productId;
  final String productName;
  final double rawMaterialCost;
  final double laborCost;
  final double overheadCost;
  final double totalCost;
  final double suggestedPrice;
  final double actualPrice;
  final double profitMargin;
  final List<MaterialCostItem> materials;
  final List<ProcessCostItem> processes;

  ProductCostBreakdown({
    required this.productId,
    required this.productName,
    required this.rawMaterialCost,
    required this.laborCost,
    required this.overheadCost,
    required this.totalCost,
    required this.suggestedPrice,
    required this.actualPrice,
    required this.profitMargin,
    required this.materials,
    required this.processes,
  });
}

/// Material cost item for cost breakdown
class MaterialCostItem {
  final String materialId;
  final String materialName;
  final double quantity;
  final String unit;
  final double unitCost;
  final double totalCost;
  final double percentageOfTotal;

  MaterialCostItem({
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.unitCost,
    required this.totalCost,
    required this.percentageOfTotal,
  });
}

/// Process cost item for cost breakdown
class ProcessCostItem {
  final String processId;
  final String processName;
  final double duration;
  final double laborCost;
  final double overheadCost;
  final double totalCost;
  final double percentageOfTotal;

  ProcessCostItem({
    required this.processId,
    required this.processName,
    required this.duration,
    required this.laborCost,
    required this.overheadCost,
    required this.totalCost,
    required this.percentageOfTotal,
  });
}

/// Consumption trend for a material over time
class ConsumptionTrend {
  final DateTime date;
  final double quantity;
  final double cost;

  ConsumptionTrend({
    required this.date,
    required this.quantity,
    required this.cost,
  });
}

/// Low stock alert model
class LowStockAlert {
  final String materialId;
  final String materialName;
  final double currentStock;
  final double minStock;
  final double stockPercentage;
  final String unit;
  final DateTime lastRestockDate;

  LowStockAlert({
    required this.materialId,
    required this.materialName,
    required this.currentStock,
    required this.minStock,
    required this.stockPercentage,
    required this.unit,
    required this.lastRestockDate,
  });
} 