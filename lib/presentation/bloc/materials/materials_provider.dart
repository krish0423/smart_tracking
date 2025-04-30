import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/consumption_log_model.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/domain/entities/consumption_log.dart';
import 'package:smart_tracking_app/domain/entities/material.dart' as entity;
import 'package:smart_tracking_app/domain/interfaces/material_repository.dart';
import 'package:uuid/uuid.dart';

class MaterialsProvider extends ChangeNotifier {
  final MaterialRepository repository;
  
  List<MaterialModel> _materials = [];
  List<MaterialModel> _lowStockMaterials = [];
  List<ConsumptionLog> _consumptionLogs = [];
  List<String> _categories = [];
  
  MaterialModel? _selectedMaterial;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isSyncing = false;
  
  // Getters
  List<MaterialModel> get materials => _materials;
  List<MaterialModel> get lowStockMaterials => _lowStockMaterials;
  List<ConsumptionLog> get consumptionLogs => _consumptionLogs;
  List<String> get categories => _categories;
  MaterialModel? get selectedMaterial => _selectedMaterial;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  
  MaterialsProvider({required this.repository});
  
  // Methods
  Future<void> getAllMaterials() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getAllMaterials();
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (materials) {
        _materials = materials.map((m) => MaterialModel.fromEntity(m)).toList();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<void> getMaterialById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getMaterialById(id);
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (material) {
        _selectedMaterial = MaterialModel.fromEntity(material);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<void> getMaterialByQRCode(String qrCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getMaterialByQRCode(qrCode);
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _selectedMaterial = null;
        _isLoading = false;
        notifyListeners();
      },
      (material) {
        _selectedMaterial = MaterialModel.fromEntity(material);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<void> getMaterialByBarcode(String barcode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getMaterialByBarcode(barcode);
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _selectedMaterial = null;
        _isLoading = false;
        notifyListeners();
      },
      (material) {
        _selectedMaterial = MaterialModel.fromEntity(material);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<bool> addMaterial(MaterialModel material) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.addMaterial(material);
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (addedMaterial) {
        _materials.add(MaterialModel.fromEntity(addedMaterial));
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  Future<bool> updateMaterial(MaterialModel material) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.updateMaterial(material);
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (updatedMaterial) {
        final index = _materials.indexWhere((m) => m.id == material.id);
        if (index != -1) {
          _materials[index] = MaterialModel.fromEntity(updatedMaterial);
        }
        
        if (_selectedMaterial?.id == material.id) {
          _selectedMaterial = MaterialModel.fromEntity(updatedMaterial);
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  Future<bool> deleteMaterial(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.deleteMaterial(id);
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (success) {
        if (success) {
          _materials.removeWhere((m) => m.id == id);
          
          if (_selectedMaterial?.id == id) {
            _selectedMaterial = null;
          }
        }
        
        _isLoading = false;
        notifyListeners();
        return success;
      },
    );
  }
  
  Future<bool> logConsumption(
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.logConsumption(
      materialId,
      quantity,
      userId,
      userName,
      productId: productId,
      productName: productName,
      notes: notes,
      batchId: batchId,
      locationId: locationId,
    );
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (log) {
        // Update the material's stock in the local list
        final materialIndex = _materials.indexWhere((m) => m.id == materialId);
        if (materialIndex != -1) {
          final material = _materials[materialIndex];
          _materials[materialIndex] = material.copyWith(
            currentStock: material.currentStock - quantity,
          );
        }
        
        // If the selected material was updated, update it too
        if (_selectedMaterial?.id == materialId) {
          _selectedMaterial = _selectedMaterial!.copyWith(
            currentStock: _selectedMaterial!.currentStock - quantity,
          );
        }
        
        _consumptionLogs.add(log);
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  Future<void> getConsumptionLogsByMaterial(
    String materialId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getConsumptionLogsByMaterial(
      materialId,
      startDate: startDate,
      endDate: endDate,
    );
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (logs) {
        _consumptionLogs = logs;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<void> getLowStockMaterials() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.getLowStockMaterials();
    
    result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (materials) {
        _lowStockMaterials = materials.map((m) => MaterialModel.fromEntity(m)).toList();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  Future<bool> syncOfflineConsumptionLogs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.syncOfflineConsumptionLogs();
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (success) {
        _isLoading = false;
        notifyListeners();
        return success;
      },
    );
  }
  
  Future<String?> generateQRCode(String materialId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await repository.generateQRCode(materialId);
    
    return result.fold(
      (failure) {
        _errorMessage = failure.toString();
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (qrCode) {
        // Update the material's QR code in the local list
        final materialIndex = _materials.indexWhere((m) => m.id == materialId);
        if (materialIndex != -1) {
          final material = _materials[materialIndex];
          _materials[materialIndex] = material.copyWith(qrCode: qrCode);
        }
        
        // If the selected material was updated, update it too
        if (_selectedMaterial?.id == materialId) {
          _selectedMaterial = _selectedMaterial!.copyWith(qrCode: qrCode);
        }
        
        _isLoading = false;
        notifyListeners();
        return qrCode;
      },
    );
  }
  
  void setSelectedMaterial(MaterialModel? material) {
    _selectedMaterial = material;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 