import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:smart_tracking_app/core/errors/exceptions.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';
import 'package:path_provider/path_provider.dart';

abstract class MaterialLocalDataSource {
  /// Get cached materials
  Future<List<MaterialModel>> getCachedMaterials();
  
  /// Get cached material by ID
  Future<MaterialModel> getCachedMaterialById(String id);
  
  /// Get cached material by QR code
  Future<MaterialModel> getCachedMaterialByQRCode(String qrCode);
  
  /// Get cached material by barcode
  Future<MaterialModel> getCachedMaterialByBarcode(String barcode);
  
  /// Cache a list of materials
  Future<void> cacheMaterials(List<MaterialModel> materials);
  
  /// Cache a single material
  Future<void> cacheMaterial(MaterialModel material);
  
  /// Delete a cached material
  Future<void> deleteCachedMaterial(String id);
  
  /// Cache consumption log
  Future<void> cacheConsumptionLog(ConsumptionLog log);
  
  /// Get cached consumption logs for a material
  Future<List<ConsumptionLog>> getCachedConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Get cached consumption logs by user
  Future<List<ConsumptionLog>> getCachedConsumptionLogsByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Add a log ID to pending sync
  Future<void> addPendingSync(String logId);
  
  /// Get all logs pending sync
  Future<List<ConsumptionLog>> getPendingSyncLogs();
  
  /// Mark a log as synced
  Future<void> markLogAsSynced(String logId);
}

class MaterialLocalDataSourceImpl implements MaterialLocalDataSource {
  final Box<dynamic> materialBox;
  final Box<dynamic> consumptionLogBox;
  final Box<dynamic> pendingSyncBox;

  MaterialLocalDataSourceImpl({
    required this.materialBox,
    required this.consumptionLogBox,
    required this.pendingSyncBox,
  });

  // Utility method to initialize Hive boxes
  static Future<MaterialLocalDataSourceImpl> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    
    final materialBox = await Hive.openBox('materials');
    final consumptionLogBox = await Hive.openBox('consumption_logs');
    final pendingSyncBox = await Hive.openBox('pending_syncs');
    
    return MaterialLocalDataSourceImpl(
      materialBox: materialBox,
      consumptionLogBox: consumptionLogBox,
      pendingSyncBox: pendingSyncBox,
    );
  }

  @override
  Future<List<MaterialModel>> getCachedMaterials() async {
    try {
      if (materialBox.isEmpty) {
        throw CacheException(message: 'No cached materials found');
      }
      
      final List<MaterialModel> materials = [];
      for (final key in materialBox.keys) {
        final materialJson = jsonDecode(materialBox.get(key));
        materials.add(MaterialModel.fromJson(materialJson));
      }
      
      return materials;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getCachedMaterialById(String id) async {
    try {
      final materialJson = materialBox.get(id);
      if (materialJson == null) {
        throw CacheException(message: 'Material not found in cache');
      }
      
      return MaterialModel.fromJson(jsonDecode(materialJson));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getCachedMaterialByQRCode(String qrCode) async {
    try {
      final materials = await getCachedMaterials();
      final material = materials.firstWhere(
        (m) => m.qrCode == qrCode,
        orElse: () => throw CacheException(message: 'Material not found by QR code in cache'),
      );
      
      return material;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getCachedMaterialByBarcode(String barcode) async {
    try {
      final materials = await getCachedMaterials();
      final material = materials.firstWhere(
        (m) => m.barcode == barcode,
        orElse: () => throw CacheException(message: 'Material not found by barcode in cache'),
      );
      
      return material;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheMaterials(List<MaterialModel> materials) async {
    try {
      for (final material in materials) {
        await cacheMaterial(material);
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheMaterial(MaterialModel material) async {
    try {
      await materialBox.put(
        material.id,
        jsonEncode(material.toJson()),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCachedMaterial(String id) async {
    try {
      await materialBox.delete(id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheConsumptionLog(ConsumptionLog log) async {
    try {
      final logMap = {
        'id': log.id,
        'materialId': log.materialId,
        'materialName': log.materialName,
        'quantity': log.quantity,
        'costPerUnit': log.costPerUnit,
        'totalCost': log.totalCost,
        'userId': log.userId,
        'userName': log.userName,
        'productId': log.productId,
        'productName': log.productName,
        'notes': log.notes,
        'timestamp': log.timestamp.toIso8601String(),
        'isSynced': log.isSynced,
        'batchId': log.batchId,
        'locationId': log.locationId,
      };
      
      await consumptionLogBox.put(log.id, jsonEncode(logMap));
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<ConsumptionLog>> getCachedConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final List<ConsumptionLog> logs = [];
      
      for (final key in consumptionLogBox.keys) {
        final logJson = jsonDecode(consumptionLogBox.get(key));
        
        if (logJson['materialId'] == materialId) {
          final logTimestamp = DateTime.parse(logJson['timestamp']);
          
          // Apply date filters if provided
          if (startDate != null && logTimestamp.isBefore(startDate)) {
            continue;
          }
          
          if (endDate != null && logTimestamp.isAfter(endDate)) {
            continue;
          }
          
          logs.add(ConsumptionLog(
            id: logJson['id'],
            materialId: logJson['materialId'],
            materialName: logJson['materialName'],
            quantity: logJson['quantity'],
            costPerUnit: logJson['costPerUnit'],
            totalCost: logJson['totalCost'],
            userId: logJson['userId'],
            userName: logJson['userName'],
            productId: logJson['productId'],
            productName: logJson['productName'],
            notes: logJson['notes'],
            timestamp: logTimestamp,
            isSynced: logJson['isSynced'] ?? false,
            batchId: logJson['batchId'],
            locationId: logJson['locationId'],
          ));
        }
      }
      
      return logs;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<ConsumptionLog>> getCachedConsumptionLogsByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final List<ConsumptionLog> logs = [];
      
      for (final key in consumptionLogBox.keys) {
        final logJson = jsonDecode(consumptionLogBox.get(key));
        
        if (logJson['userId'] == userId) {
          final logTimestamp = DateTime.parse(logJson['timestamp']);
          
          // Apply date filters if provided
          if (startDate != null && logTimestamp.isBefore(startDate)) {
            continue;
          }
          
          if (endDate != null && logTimestamp.isAfter(endDate)) {
            continue;
          }
          
          logs.add(ConsumptionLog(
            id: logJson['id'],
            materialId: logJson['materialId'],
            materialName: logJson['materialName'],
            quantity: logJson['quantity'],
            costPerUnit: logJson['costPerUnit'],
            totalCost: logJson['totalCost'],
            userId: logJson['userId'],
            userName: logJson['userName'],
            productId: logJson['productId'],
            productName: logJson['productName'],
            notes: logJson['notes'],
            timestamp: logTimestamp,
            isSynced: logJson['isSynced'] ?? false,
            batchId: logJson['batchId'],
            locationId: logJson['locationId'],
          ));
        }
      }
      
      return logs;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> addPendingSync(String logId) async {
    try {
      await pendingSyncBox.put(logId, true);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<ConsumptionLog>> getPendingSyncLogs() async {
    try {
      final List<ConsumptionLog> pendingLogs = [];
      
      for (final logId in pendingSyncBox.keys) {
        final logJson = consumptionLogBox.get(logId);
        if (logJson != null) {
          final log = jsonDecode(logJson);
          
          pendingLogs.add(ConsumptionLog(
            id: log['id'],
            materialId: log['materialId'],
            materialName: log['materialName'],
            quantity: log['quantity'],
            costPerUnit: log['costPerUnit'],
            totalCost: log['totalCost'],
            userId: log['userId'],
            userName: log['userName'],
            productId: log['productId'],
            productName: log['productName'],
            notes: log['notes'],
            timestamp: DateTime.parse(log['timestamp']),
            isSynced: false,
            batchId: log['batchId'],
            locationId: log['locationId'],
          ));
        }
      }
      
      return pendingLogs;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> markLogAsSynced(String logId) async {
    try {
      // Remove from pending syncs
      await pendingSyncBox.delete(logId);
      
      // Update the log's sync status
      final logJson = consumptionLogBox.get(logId);
      if (logJson != null) {
        final log = jsonDecode(logJson);
        log['isSynced'] = true;
        
        await consumptionLogBox.put(logId, jsonEncode(log));
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
} 