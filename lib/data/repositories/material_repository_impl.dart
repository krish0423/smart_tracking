import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_tracking_app/core/errors/exceptions.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/core/network/network_info.dart';
import 'package:smart_tracking_app/data/datasources/local/material_local_data_source.dart';
import 'package:smart_tracking_app/data/datasources/remote/material_remote_data_source.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/domain/entities/material.dart' as entity;
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';
import 'package:smart_tracking_app/domain/interfaces/material_repository.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  final MaterialRemoteDataSource remoteDataSource;
  final MaterialLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MaterialRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<entity.Material>>> getAllMaterials() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMaterials = await remoteDataSource.getAllMaterials();
        await localDataSource.cacheMaterials(remoteMaterials);
        return Right(remoteMaterials);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMaterials = await localDataSource.getCachedMaterials();
        return Right(localMaterials);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, entity.Material>> getMaterialById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMaterial = await remoteDataSource.getMaterialById(id);
        await localDataSource.cacheMaterial(remoteMaterial);
        return Right(remoteMaterial);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMaterial = await localDataSource.getCachedMaterialById(id);
        return Right(localMaterial);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, entity.Material>> getMaterialByQRCode(String qrCode) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMaterial = await remoteDataSource.getMaterialByQRCode(qrCode);
        await localDataSource.cacheMaterial(remoteMaterial);
        return Right(remoteMaterial);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMaterial = await localDataSource.getCachedMaterialByQRCode(qrCode);
        return Right(localMaterial);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, entity.Material>> getMaterialByBarcode(String barcode) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMaterial = await remoteDataSource.getMaterialByBarcode(barcode);
        await localDataSource.cacheMaterial(remoteMaterial);
        return Right(remoteMaterial);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMaterial = await localDataSource.getCachedMaterialByBarcode(barcode);
        return Right(localMaterial);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, entity.Material>> addMaterial(entity.Material material) async {
    if (await networkInfo.isConnected) {
      try {
        final materialModel = MaterialModel.fromEntity(material);
        final remoteMaterial = await remoteDataSource.addMaterial(materialModel);
        await localDataSource.cacheMaterial(remoteMaterial);
        return Right(remoteMaterial);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, entity.Material>> updateMaterial(entity.Material material) async {
    if (await networkInfo.isConnected) {
      try {
        final materialModel = MaterialModel.fromEntity(material);
        final remoteMaterial = await remoteDataSource.updateMaterial(materialModel);
        await localDataSource.cacheMaterial(remoteMaterial);
        return Right(remoteMaterial);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMaterial(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteMaterial(id);
        if (result) {
          await localDataSource.deleteCachedMaterial(id);
        }
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ConsumptionLog>> logConsumption(
    String materialId,
    double quantity,
    String userId,
    String userName, {
    String? productId,
    String? productName,
    String? notes,
    String? batchId,
    String? locationId,
  }) async {
    try {
      // Get the material first to have access to its current details
      final materialResult = await getMaterialById(materialId);
      
      return materialResult.fold(
        (failure) => Left(failure),
        (material) async {
          if (material.currentStock < quantity) {
            return Left(InsufficientStockFailure());
          }
          
          final logId = const Uuid().v4();
          final consumptionLog = ConsumptionLog.create(
            id: logId,
            materialId: materialId,
            materialName: material.name,
            quantity: quantity,
            costPerUnit: material.costPerUnit,
            userId: userId,
            userName: userName,
            productId: productId,
            productName: productName,
            notes: notes,
            batchId: batchId,
            locationId: locationId,
          );
          
          // Update the material's stock
          final updatedMaterial = MaterialModel.fromEntity(material).copyWith(
            currentStock: material.currentStock - quantity,
            updatedAt: DateTime.now(),
          );
          
          if (await networkInfo.isConnected) {
            try {
              // Save the log to remote
              await remoteDataSource.logConsumption(consumptionLog);
              
              // Update the material in remote
              await remoteDataSource.updateMaterial(updatedMaterial);
              
              // Cache both locally
              await localDataSource.cacheConsumptionLog(consumptionLog);
              await localDataSource.cacheMaterial(updatedMaterial);
              
              return Right(consumptionLog);
            } on ServerException {
              return Left(ServerFailure());
            }
          } else {
            // Save offline and mark for sync later
            try {
              await localDataSource.cacheConsumptionLog(consumptionLog);
              await localDataSource.cacheMaterial(updatedMaterial);
              await localDataSource.addPendingSync(logId);
              
              return Right(consumptionLog);
            } on CacheException {
              return Left(CacheFailure());
            }
          }
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ConsumptionLog>>> getConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final logs = await remoteDataSource.getConsumptionLogsByMaterial(
          materialId,
          startDate: startDate,
          endDate: endDate,
        );
        return Right(logs);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final logs = await localDataSource.getCachedConsumptionLogsByMaterial(
          materialId,
          startDate: startDate,
          endDate: endDate,
        );
        return Right(logs);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<ConsumptionLog>>> getConsumptionLogsByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final logs = await remoteDataSource.getConsumptionLogsByUser(
          userId,
          startDate: startDate,
          endDate: endDate,
        );
        return Right(logs);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final logs = await localDataSource.getCachedConsumptionLogsByUser(
          userId,
          startDate: startDate,
          endDate: endDate,
        );
        return Right(logs);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<entity.Material>>> getLowStockMaterials() async {
    try {
      final materialsResult = await getAllMaterials();
      
      return materialsResult.fold(
        (failure) => Left(failure),
        (materials) {
          final lowStockMaterials = materials.where((m) => m.isLowStock).toList();
          return Right(lowStockMaterials);
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> syncOfflineConsumptionLogs() async {
    if (await networkInfo.isConnected) {
      try {
        final pendingLogs = await localDataSource.getPendingSyncLogs();
        
        if (pendingLogs.isEmpty) {
          return const Right(true);
        }
        
        for (final log in pendingLogs) {
          await remoteDataSource.logConsumption(log);
          await localDataSource.markLogAsSynced(log.id);
        }
        
        return const Right(true);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, String>> generateQRCode(String materialId) async {
    try {
      final materialResult = await getMaterialById(materialId);
      
      return materialResult.fold(
        (failure) => Left(failure),
        (material) async {
          if (await networkInfo.isConnected) {
            try {
              final qrCode = await remoteDataSource.generateQRCode(materialId);
              
              // Update the material with the QR code
              final updatedMaterial = MaterialModel.fromEntity(material).copyWith(
                qrCode: qrCode,
                updatedAt: DateTime.now(),
              );
              
              await remoteDataSource.updateMaterial(updatedMaterial);
              await localDataSource.cacheMaterial(updatedMaterial);
              
              return Right(qrCode);
            } on ServerException {
              return Left(ServerFailure());
            }
          } else {
            return Left(InternetConnectionFailure());
          }
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
} 