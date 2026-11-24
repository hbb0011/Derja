import 'package:flutter/foundation.dart';

/// ApiConfig = ONE place that knows WHERE our server lives.
/// If the address changes, we only edit this file.
class ApiConfig {
  /// json-server listens on this port (see README: `--port 3000`).
  static const int port = 3000;

  /// How long we wait for the server before giving up.
  static const Duration timeout = Duration(seconds: 10);

  /// Android EMULATOR: "localhost" would be the phone itself, so Android
  /// uses the special address 10.0.2.2 which means "my computer".
  /// REAL PHONE: replace it with your computer's Wi-Fi IP (e.g. 192.168.1.20).
  static const String androidHost = '10.0.2.2';

  static String get baseUrl {
    // Flutter Web (Chrome): the server is on the same computer.
    if (kIsWeb) {
      return 'http://localhost:$port';
    }
    // Android emulator / phone.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://$androidHost:$port';
    }
    // Windows, macOS, iOS simulator...
    return 'http://localhost:$port';
  }
}
