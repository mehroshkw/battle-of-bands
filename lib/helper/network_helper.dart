import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static NetworkHelper? _instance;

  NetworkHelper._();

  static NetworkHelper instance() {
    _instance ??= NetworkHelper._();
    return _instance!;
  }

  final _connectivity = Connectivity();

  Stream<ConnectivityResult> get onConnectivityChanged => _connectivity.onConnectivityChanged;

  Future<bool> get isNetworkConnected async => (await _connectivity.checkConnectivity()) != ConnectivityResult.none;
}
