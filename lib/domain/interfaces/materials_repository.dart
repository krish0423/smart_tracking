import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/data/models/consumption_log_model.dart';
import 'package:dartz/dartz.dart';

abstract class MaterialsRepository {
  /// Get all materials
  Future<Either<Failure, List<MaterialModel>>> getAllMaterials();
  
  /// Get materials by category
  Future<Either<Failure, List<MaterialModel>>> getMaterialsByCategory(String category);
  
  /// Get low stock materials
  Future<Either<Failure, List<MaterialModel>>> getLowStockMaterials();
  
  /// Get material by ID
  Future<Either<Failure, MaterialModel>> getMaterialById(String id);
  
  /// Get material by barcode
  Future<Either<Failure, MaterialModel>> getMaterialByBarcode(String barcode);
  
  /// Get material by QR code
  Future<Either<Failure, MaterialModel>> getMaterialByQRCode(String qrCode);
  
  /// Add new material
  Future<Either<Failure, MaterialModel>> addMaterial(MaterialModel material);
  
  /// Update material
  Future<Either<Failure, MaterialModel>> updateMaterial(MaterialModel material);
  
  /// Delete material
  Future<Either<Failure, void>> deleteMaterial(String id);
  
  /// Log material consumption
  Future<Either<Failure, ConsumptionLogModel>> logConsumption(ConsumptionLogModel log);
  
  /// Get consumption logs for a material
  Future<Either<Failure, List<ConsumptionLogModel>>> getConsumptionLogs(String materialId);
  
  /// Get all consumption logs
  Future<Either<Failure, List<ConsumptionLogModel>>> getAllConsumptionLogs();
  
  /// Get consumption logs for a date range
  Future<Either<Failure, List<ConsumptionLogModel>>> getConsumptionLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Restock material
  Future<Either<Failure, MaterialModel>> restockMaterial(
    String materialId,
    double quantity,
    String updatedBy,
  );
  
  /// Get material categories
  Future<Either<Failure, List<String>>> getMaterialCategories();
  
  /// Synchronize offline consumption logs with the server
  Future<Either<Failure, int>> syncOfflineConsumptionLogs();
} 