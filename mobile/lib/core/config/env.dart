import 'dart:io' show Platform;

/// Where the app finds the API.
///
/// Override on any build with:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8000/api
/// (needed on a physical phone, which can't reach your Mac's "localhost").
class Env {
  const Env._();

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    // The Android emulator sees the host machine as 10.0.2.2, not localhost.
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
    return 'http://localhost:8000/api';
  }
}
