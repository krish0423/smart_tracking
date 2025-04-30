import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_tracking_app/core/utils/connectivity_service.dart';
import 'package:smart_tracking_app/data/datasources/local/hive_service.dart';
import 'package:smart_tracking_app/data/datasources/local/local_storage_service.dart';

// Simplified providers file to allow the app to compile
class AppProviders {
  static List<SingleChildWidget> get providers => [
    ..._independentServices,
  ];
  
  // Independent services that don't depend on other services
  static List<SingleChildWidget> get _independentServices => [
    Provider<HiveService>(
      create: (_) => HiveService(),
    ),
    Provider<LocalStorageService>(
      create: (_) => LocalStorageService(),
    ),
    Provider<ConnectivityService>(
      create: (_) => ConnectivityService(),
    ),
  ];
} 