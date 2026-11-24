import 'package:dio/dio.dart';

import '../config/env.dart';

/// One configured HTTP client for the whole app.
///
/// `Accept: application/json` matters: without it, Laravel answers some
/// errors (like validation failures) with an HTML redirect instead of JSON.
Dio createApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );
}
