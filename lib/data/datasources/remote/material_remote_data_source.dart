import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_tracking_app/core/errors/exceptions.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';
import 'package:uuid/uuid.dart';

abstract class MaterialRemoteDataSource {
  Future<List<MaterialModel>> getAllMaterials();
  Future<MaterialModel> getMaterialById(String id);
  Future<MaterialModel> getMaterialByQRCode(String qrCode);
  Future<MaterialModel> getMaterialByBarcode(String barcode);
  Future<MaterialModel> addMaterial(MaterialModel material);
  Future<MaterialModel> updateMaterial(MaterialModel material);
  Future<bool> deleteMaterial(String id);
  Future<void> logConsumption(ConsumptionLog log);
  Future<List<ConsumptionLog>> getConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<ConsumptionLog>> getConsumptionLogsByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<String> generateQRCode(String materialId);
}

class MaterialRemoteDataSourceImpl implements MaterialRemoteDataSource {
  final FirebaseFirestore firestore;

  MaterialRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MaterialModel>> getAllMaterials() async {
    try {
      final materialsSnapshot = await firestore.collection('materials').get();
      return materialsSnapshot.docs
          .map((doc) => MaterialModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getMaterialById(String id) async {
    try {
      final materialDoc = await firestore.collection('materials').doc(id).get();
      
      if (!materialDoc.exists) {
        throw ServerException(message: 'Material not found');
      }
      
      return MaterialModel.fromJson(materialDoc.data()!..['id'] = materialDoc.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getMaterialByQRCode(String qrCode) async {
    try {
      final materialsSnapshot = await firestore
          .collection('materials')
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();
      
      if (materialsSnapshot.docs.isEmpty) {
        throw ServerException(message: 'Material not found by QR code');
      }
      
      final doc = materialsSnapshot.docs.first;
      return MaterialModel.fromJson(doc.data()..['id'] = doc.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> getMaterialByBarcode(String barcode) async {
    try {
      final materialsSnapshot = await firestore
          .collection('materials')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();
      
      if (materialsSnapshot.docs.isEmpty) {
        throw ServerException(message: 'Material not found by barcode');
      }
      
      final doc = materialsSnapshot.docs.first;
      return MaterialModel.fromJson(doc.data()..['id'] = doc.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> addMaterial(MaterialModel material) async {
    try {
      final materialJson = material.toJson();
      // Remove ID from JSON since Firestore will generate one
      materialJson.remove('id');
      
      final docRef = await firestore.collection('materials').add(materialJson);
      return material.copyWith(id: docRef.id);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MaterialModel> updateMaterial(MaterialModel material) async {
    try {
      final materialJson = material.toJson();
      // Remove ID from JSON since we don't want to update the document ID
      materialJson.remove('id');
      
      await firestore.collection('materials').doc(material.id).update(materialJson);
      return material;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteMaterial(String id) async {
    try {
      await firestore.collection('materials').doc(id).delete();
      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logConsumption(ConsumptionLog log) async {
    try {
      await firestore.collection('consumption_logs').doc(log.id).set({
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
        'batchId': log.batchId,
        'locationId': log.locationId,
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ConsumptionLog>> getConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = firestore
          .collection('consumption_logs')
          .where('materialId', isEqualTo: materialId);
      
      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate.toIso8601String());
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ConsumptionLog(
          id: data['id'],
          materialId: data['materialId'],
          materialName: data['materialName'],
          quantity: data['quantity'],
          costPerUnit: data['costPerUnit'],
          totalCost: data['totalCost'],
          userId: data['userId'],
          userName: data['userName'],
          productId: data['productId'],
          productName: data['productName'],
          notes: data['notes'],
          timestamp: DateTime.parse(data['timestamp']),
          isSynced: true,
          batchId: data['batchId'],
          locationId: data['locationId'],
        );
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ConsumptionLog>> getConsumptionLogsByUser(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = firestore
          .collection('consumption_logs')
          .where('userId', isEqualTo: userId);
      
      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate.toIso8601String());
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ConsumptionLog(
          id: data['id'],
          materialId: data['materialId'],
          materialName: data['materialName'],
          quantity: data['quantity'],
          costPerUnit: data['costPerUnit'],
          totalCost: data['totalCost'],
          userId: data['userId'],
          userName: data['userName'],
          productId: data['productId'],
          productName: data['productName'],
          notes: data['notes'],
          timestamp: DateTime.parse(data['timestamp']),
          isSynced: true,
          batchId: data['batchId'],
          locationId: data['locationId'],
        );
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> generateQRCode(String materialId) async {
    try {
      // In a real app, this would generate a QR code image and possibly store it in Firebase Storage
      // For now, we'll just return a unique string representation of the material ID
      return 'MAT-${materialId}-${const Uuid().v4().substring(0, 8)}';
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
} 