import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

enum NetworkStatus { online, offline }

final networkStatusProvider = StateProvider<NetworkStatus>((ref) {
  return NetworkStatus.online;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<NetworkStatus>.broadcast();

  Stream<NetworkStatus> get status => _controller.stream;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
    // Initialize with the current connectivity status
    _updateConnectionStatus(await _connectivity.checkConnectivity());

    // Subscribe to the connectivity changes
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _controller.add(NetworkStatus.offline);
    } else {
      _controller.add(NetworkStatus.online);
    }
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
