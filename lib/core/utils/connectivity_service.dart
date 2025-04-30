import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _controller = StreamController<NetworkStatus>.broadcast();
  
  Stream<NetworkStatus> get status => _controller.stream;
  
  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _controller.add(_getStatus(result));
    });
    
    // Check initial connectivity
    checkConnectivity();
  }
  
  // Check current connectivity
  Future<NetworkStatus> checkConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    final status = _getStatus(result);
    _controller.add(status);
    return status;
  }
  
  // Convert connectivity result to NetworkStatus enum
  NetworkStatus _getStatus(ConnectivityResult result) {
    return result == ConnectivityResult.none 
        ? NetworkStatus.offline 
        : NetworkStatus.online;
  }
  
  // Close stream controller
  void dispose() {
    _controller.close();
  }
} 