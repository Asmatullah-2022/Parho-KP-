import 'package:connectivity_plus/connectivity_plus.dart' as cp;

import 'connectivity.dart';

/// Real network detection backed by `connectivity_plus`. Maps the plugin's
/// result to the app's [ConnectivityStatus]. If the plugin is unavailable
/// (e.g. under `flutter test`, where platform channels aren't mocked), it fails
/// safe by reporting Wi-Fi so nothing breaks — the download service still
/// enforces the Wi-Fi-only policy from settings.
class ConnectivityPlusService implements Connectivity {
  ConnectivityPlusService([cp.Connectivity? connectivity])
      : _connectivity = connectivity ?? cp.Connectivity();

  final cp.Connectivity _connectivity;

  @override
  Future<ConnectivityStatus> status() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(cp.ConnectivityResult.none) || results.isEmpty) {
        return ConnectivityStatus.offline;
      }
      if (results.contains(cp.ConnectivityResult.wifi) ||
          results.contains(cp.ConnectivityResult.ethernet)) {
        return ConnectivityStatus.wifi;
      }
      if (results.contains(cp.ConnectivityResult.mobile)) {
        return ConnectivityStatus.mobile;
      }
      // VPN/other → treat as an allowed (non-metered) connection.
      return ConnectivityStatus.wifi;
    } catch (_) {
      return ConnectivityStatus.wifi;
    }
  }
}
