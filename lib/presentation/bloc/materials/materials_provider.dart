import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/consumption_log_model.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/domain/interfaces/materials_repository.dart';
import 'package:uuid/uuid.dart';

class MaterialsProvider extends ChangeNotifier {
  final MaterialsRepository _materialsRepository;
  
  List<MaterialModel> _materials = [];
  List<MaterialModel> _lowStockMaterials = [];
  List<ConsumptionLogModel> _consumptionLogs = [];
  List<String> _categories = [];
  
  MaterialModel? _selectedMaterial;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isSyncing = false;
  
  // Getters
  List<MaterialModel> get materials => _materials;
  List<MaterialModel> get lowStockMaterials => _lowStockMaterials;
  List<ConsumptionLogModel> get consumptionLogs => _consumptionLogs;
  List<String> get categories => _categories;
  MaterialModel? get selectedMaterial => _selectedMaterial;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  
  MaterialsProvider({required MaterialsRepository materialsRepository}) 
      : _materialsRepository = materialsRepository;
  
  // Update with new materials repository (for provider proxy)
  void update(MaterialsRepository materialsRepository) {
    // Nothing to do here as we already have the repository
  }
  
  // Fetch all materials
  Future<void> fetchAllMaterials() async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getAllMaterials();
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (materials) {
        _materials = materials;
      },
    );
    
    _setLoading(false);
  }
  
  // Fetch low stock materials
  Future<void> fetchLowStockMaterials() async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getLowStockMaterials();
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (materials) {
        _lowStockMaterials = materials;
      },
    );
    
    _setLoading(false);
  }
  
  // Fetch materials by category
  Future<void> fetchMaterialsByCategory(String category) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getMaterialsByCategory(category);
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (materials) {
        _materials = materials;
      },
    );
    
    _setLoading(false);
  }
  
  // Fetch material categories
  Future<void> fetchMaterialCategories() async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getMaterialCategories();
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (categories) {
        _categories = categories;
      },
    );
    
    _setLoading(false);
  }
  
  // Get material by ID
  Future<void> getMaterialById(String id) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getMaterialById(id);
    
    result.fold(
      (failure) {
        _setError(failure.message);
        _selectedMaterial = null;
      },
      (material) {
        _selectedMaterial = material;
      },
    );
    
    _setLoading(false);
  }
  
  // Get material by barcode
  Future<void> getMaterialByBarcode(String barcode) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getMaterialByBarcode(barcode);
    
    result.fold(
      (failure) {
        _setError(failure.message);
        _selectedMaterial = null;
      },
      (material) {
        _selectedMaterial = material;
      },
    );
    
    _setLoading(false);
  }
  
  // Get material by QR code
  Future<void> getMaterialByQRCode(String qrCode) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getMaterialByQRCode(qrCode);
    
    result.fold(
      (failure) {
        _setError(failure.message);
        _selectedMaterial = null;
      },
      (material) {
        _selectedMaterial = material;
      },
    );
    
    _setLoading(false);
  }
  
  // Add new material
  Future<bool> addMaterial(MaterialModel material) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.addMaterial(material);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (addedMaterial) {
        _materials.add(addedMaterial);
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Update material
  Future<bool> updateMaterial(MaterialModel material) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.updateMaterial(material);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (updatedMaterial) {
        final index = _materials.indexWhere((m) => m.id == updatedMaterial.id);
        if (index != -1) {
          _materials[index] = updatedMaterial;
        }
        if (_selectedMaterial?.id == updatedMaterial.id) {
          _selectedMaterial = updatedMaterial;
        }
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Delete material
  Future<bool> deleteMaterial(String id) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.deleteMaterial(id);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _materials.removeWhere((m) => m.id == id);
        if (_selectedMaterial?.id == id) {
          _selectedMaterial = null;
        }
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Log material consumption
  Future<bool> logConsumption(String materialId, double quantity, String userId, String userName,
      {String? productId, String? productName, String? batchNumber, String? notes}) async {
    _setLoading(true);
    _clearError();
    
    final material = _materials.firstWhere(
      (m) => m.id == materialId,
      orElse: () => throw Exception('Material not found'),
    );
    
    final totalCost = material.unitCost * quantity;
    
    final consumptionLog = ConsumptionLogModel(
      id: const Uuid().v4(),
      materialId: materialId,
      materialName: material.name,
      quantity: quantity,
      unit: material.unit,
      unitCost: material.unitCost,
      totalCost: totalCost,
      productId: productId,
      productName: productName,
      batchNumber: batchNumber,
      consumedAt: DateTime.now(),
      consumedBy: userId,
      consumedByName: userName,
      notes: notes,
    );
    
    final result = await _materialsRepository.logConsumption(consumptionLog);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (log) {
        _consumptionLogs.add(log);
        
        // Also update the material stock
        final updatedMaterial = material.consumeStock(quantity, updatedByUserId: userId);
        final materialIndex = _materials.indexWhere((m) => m.id == materialId);
        if (materialIndex != -1) {
          _materials[materialIndex] = updatedMaterial;
        }
        
        if (_selectedMaterial?.id == materialId) {
          _selectedMaterial = updatedMaterial;
        }
        
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Get consumption logs for a material
  Future<void> fetchConsumptionLogs(String materialId) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getConsumptionLogs(materialId);
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (logs) {
        _consumptionLogs = logs;
      },
    );
    
    _setLoading(false);
  }
  
  // Get all consumption logs
  Future<void> fetchAllConsumptionLogs() async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.getAllConsumptionLogs();
    
    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (logs) {
        _consumptionLogs = logs;
      },
    );
    
    _setLoading(false);
  }
  
  // Restock material
  Future<bool> restockMaterial(String materialId, double quantity, String userId) async {
    _setLoading(true);
    _clearError();
    
    final result = await _materialsRepository.restockMaterial(materialId, quantity, userId);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (updatedMaterial) {
        final index = _materials.indexWhere((m) => m.id == materialId);
        if (index != -1) {
          _materials[index] = updatedMaterial;
        }
        
        if (_selectedMaterial?.id == materialId) {
          _selectedMaterial = updatedMaterial;
        }
        
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Sync offline consumption logs
  Future<bool> syncOfflineConsumptionLogs() async {
    if (_isSyncing) return false;
    
    _isSyncing = true;
    _clearError();
    notifyListeners();
    
    final result = await _materialsRepository.syncOfflineConsumptionLogs();
    
    _isSyncing = false;
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        notifyListeners();
        return false;
      },
      (count) {
        if (count > 0) {
          // If logs were synced, refresh data
          fetchAllMaterials();
          fetchAllConsumptionLogs();
        }
        notifyListeners();
        return true;
      },
    );
  }
  
  // Set selected material
  void selectMaterial(MaterialModel material) {
    _selectedMaterial = material;
    notifyListeners();
  }
  
  // Clear selected material
  void clearSelectedMaterial() {
    _selectedMaterial = null;
    notifyListeners();
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
} 