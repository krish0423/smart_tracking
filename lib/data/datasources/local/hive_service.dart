import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_tracking_app/core/constants/app_constants.dart';
import 'package:smart_tracking_app/data/models/material_model.dart';
import 'package:smart_tracking_app/data/models/product_model.dart';
import 'package:smart_tracking_app/data/models/consumption_log_model.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:smart_tracking_app/data/models/offline_queue_item_model.dart';

class HiveService {
  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(MaterialModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(ConsumptionLogModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(OfflineQueueItemModelAdapter());
    
    // Open boxes
    await Hive.openBox<UserModel>(AppConstants.userBox);
    await Hive.openBox<MaterialModel>(AppConstants.materialsBox);
    await Hive.openBox<ConsumptionLogModel>(AppConstants.logsBox);
    await Hive.openBox(AppConstants.settingsBox);
    await Hive.openBox<OfflineQueueItemModel>(AppConstants.offlineQueueBox);
  }
  
  // User methods
  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(AppConstants.userBox);
    await box.put('current_user', user);
  }
  
  UserModel? getUser() {
    final box = Hive.box<UserModel>(AppConstants.userBox);
    return box.get('current_user');
  }
  
  Future<void> deleteUser() async {
    final box = Hive.box<UserModel>(AppConstants.userBox);
    await box.delete('current_user');
  }
  
  // Materials methods
  Future<void> saveMaterials(List<MaterialModel> materials) async {
    final box = Hive.box<MaterialModel>(AppConstants.materialsBox);
    
    // Clear existing materials first
    await box.clear();
    
    // Save each material with its ID as the key
    for (var material in materials) {
      await box.put(material.id, material);
    }
  }
  
  Future<void> saveMaterial(MaterialModel material) async {
    final box = Hive.box<MaterialModel>(AppConstants.materialsBox);
    await box.put(material.id, material);
  }
  
  MaterialModel? getMaterial(String id) {
    final box = Hive.box<MaterialModel>(AppConstants.materialsBox);
    return box.get(id);
  }
  
  List<MaterialModel> getAllMaterials() {
    final box = Hive.box<MaterialModel>(AppConstants.materialsBox);
    return box.values.toList();
  }
  
  Future<void> deleteMaterial(String id) async {
    final box = Hive.box<MaterialModel>(AppConstants.materialsBox);
    await box.delete(id);
  }
  
  // Consumption logs methods
  Future<void> saveConsumptionLog(ConsumptionLogModel log) async {
    final box = Hive.box<ConsumptionLogModel>(AppConstants.logsBox);
    await box.put(log.id, log);
  }
  
  List<ConsumptionLogModel> getAllConsumptionLogs() {
    final box = Hive.box<ConsumptionLogModel>(AppConstants.logsBox);
    return box.values.toList();
  }
  
  // Settings methods
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(key, value);
  }
  
  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(AppConstants.settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }
  
  // Offline queue methods
  Future<void> addToOfflineQueue(OfflineQueueItemModel item) async {
    final box = Hive.box<OfflineQueueItemModel>(AppConstants.offlineQueueBox);
    await box.add(item);
  }
  
  List<OfflineQueueItemModel> getOfflineQueue() {
    final box = Hive.box<OfflineQueueItemModel>(AppConstants.offlineQueueBox);
    return box.values.toList();
  }
  
  Future<void> removeFromOfflineQueue(int index) async {
    final box = Hive.box<OfflineQueueItemModel>(AppConstants.offlineQueueBox);
    await box.deleteAt(index);
  }
  
  Future<void> clearOfflineQueue() async {
    final box = Hive.box<OfflineQueueItemModel>(AppConstants.offlineQueueBox);
    await box.clear();
  }
} 