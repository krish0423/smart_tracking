import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_tracking_app/core/network/network_info.dart';
import 'package:smart_tracking_app/data/datasources/local/material_local_data_source.dart';
import 'package:smart_tracking_app/data/datasources/remote/material_remote_data_source.dart';
import 'package:smart_tracking_app/data/repositories/material_repository_impl.dart';
import 'package:smart_tracking_app/domain/interfaces/material_repository.dart';
import 'package:smart_tracking_app/presentation/bloc/auth/auth_provider.dart';
import 'package:smart_tracking_app/presentation/bloc/materials/materials_provider.dart';
import 'package:smart_tracking_app/presentation/bloc/theme/theme_provider.dart';

// Simplified providers file to allow the app to compile
class AppProviders {
  static List<SingleChildWidget> get providers => [
    // Core providers
    Provider<NetworkInfo>(
      create: (_) => NetworkInfoImpl(connectivity: Connectivity()),
    ),
    
    // Firebase providers
    Provider<FirebaseFirestore>(
      create: (_) => FirebaseFirestore.instance,
    ),
    
    // Data source providers
    Provider<MaterialRemoteDataSource>(
      create: (context) => MaterialRemoteDataSourceImpl(
        firestore: context.read<FirebaseFirestore>(),
      ),
    ),
    
    // We'll initialize Hive boxes through a FutureProvider and use ProxyProvider to inject dependencies
    FutureProvider<MaterialLocalDataSourceImpl>(
      create: (_) => MaterialLocalDataSourceImpl.init(),
      initialData: null,
    ),
    
    // Repository providers
    ProxyProvider3<NetworkInfo, MaterialRemoteDataSource, MaterialLocalDataSourceImpl?,
        MaterialRepository>(
      update: (_, networkInfo, remoteDataSource, localDataSource, previous) =>
          localDataSource == null
              ? previous ?? _createMockMaterialRepository()
              : MaterialRepositoryImpl(
                  networkInfo: networkInfo,
                  remoteDataSource: remoteDataSource,
                  localDataSource: localDataSource,
                ),
    ),
    
    // Application state providers
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
    ),
    
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
    ),
    
    ChangeNotifierProvider<MaterialsProvider>(
      create: (context) => MaterialsProvider(
        repository: context.read<MaterialRepository>(),
      ),
    ),
  ];
  
  // This is a fallback for when Hive hasn't been initialized yet
  static MaterialRepository _createMockMaterialRepository() {
    throw UnimplementedError('Material repository not initialized yet');
  }
} 