/// The device's current network state, as far as downloads care about it.
enum ConnectivityStatus { wifi, mobile, offline }

/// Abstraction over network reachability so the download rules (Wi-Fi-only,
/// "offline — installed content available") can be tested and so a real
/// implementation (e.g. `connectivity_plus`) can be dropped in later without
/// changing callers.
abstract class Connectivity {
  Future<ConnectivityStatus> status();
}

/// A manually-set connectivity source. Used as a safe default and in tests.
/// A production build would replace this with a real reachability check.
class ManualConnectivity implements Connectivity {
  ManualConnectivity([this.value = ConnectivityStatus.wifi]);
  ConnectivityStatus value;
  @override
  Future<ConnectivityStatus> status() async => value;
}
