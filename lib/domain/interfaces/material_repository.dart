import 'package:dartz/dartz.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/domain/entities/material.dart' as entity;
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';

abstract class MaterialRepository {
  /// Get all materials
  Future<Either<Failure, List<entity.Material>>> getAllMaterials();
  
  /// Get material by ID
  Future<Either<Failure, entity.Material>> getMaterialById(String id);
  
  /// Get material by QR code
  Future<Either<Failure, entity.Material>> getMaterialByQRCode(String qrCode);
  
  /// Get material by barcode
  Future<Either<Failure, entity.Material>> getMaterialByBarcode(String barcode);
  
  /// Add new material
  Future<Either<Failure, entity.Material>> addMaterial(entity.Material material);
  
  /// Update material
  Future<Either<Failure, entity.Material>> updateMaterial(entity.Material material);
  
  /// Delete material
  Future<Either<Failure, bool>> deleteMaterial(String id);
  
  /// Log material consumption
  Future<Either<Failure, ConsumptionLog>> logConsumption(
    String materialId,
    double quantity,
    String userId,
    String userName,
    {
      String? productId,
      String? productName,
      String? notes,
      String? batchId,
      String? locationId,
    }
  );
  
  /// Get consumption logs for a material
  Future<Either<Failure, List<ConsumptionLog>>> getConsumptionLogsByMaterial(
    String materialId,
    {
      DateTime? startDate,
      DateTime? endDate,
    }
  );
  
  /// Get consumption logs by user
  Future<Either<Failure, List<ConsumptionLog>>> getConsumptionLogsByUser(
    String userId,
    {
      DateTime? startDate,
      DateTime? endDate,
    }
  );
  
  /// Get low stock materials
  Future<Either<Failure, List<entity.Material>>> getLowStockMaterials();
  
  /// Sync offline consumption logs
  Future<Either<Failure, bool>> syncOfflineConsumptionLogs();
  
  /// Generate QR code for a material
  Future<Either<Failure, String>> generateQRCode(String materialId);
} 