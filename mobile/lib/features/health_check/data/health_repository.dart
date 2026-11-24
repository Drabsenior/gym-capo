import 'package:dio/dio.dart';

import 'health_status.dart';

/// The only place in the app that knows how the health endpoint works.
/// Screens ask the repository; they never touch Dio directly.
class HealthRepository {
  HealthRepository(this._dio);

  final Dio _dio;

  Future<HealthStatus> fetch() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/health',
      // 503 means "API up, a dependency down" — still a readable answer.
      options: Options(validateStatus: (code) => code == 200 || code == 503),
    );
    return HealthStatus.fromJson(response.data!);
  }
}
