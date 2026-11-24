/// What `GET /api/health` returns.
class HealthStatus {
  const HealthStatus({
    required this.status,
    required this.app,
    required this.checks,
  });

  final String status;
  final String app;
  final Map<String, bool> checks;

  bool get isHealthy => status == 'ok';

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    final rawChecks = json['checks'] as Map<String, dynamic>? ?? const {};
    return HealthStatus(
      status: json['status'] as String,
      app: json['app'] as String,
      checks: rawChecks.map((name, ok) => MapEntry(name, ok == true)),
    );
  }
}
