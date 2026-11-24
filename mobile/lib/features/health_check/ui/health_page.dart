import 'package:flutter/material.dart';

import '../../../core/config/env.dart';
import '../data/health_repository.dart';
import '../data/health_status.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key, required this.repository});

  final HealthRepository repository;

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  late Future<HealthStatus> _status;

  @override
  void initState() {
    super.initState();
    _status = widget.repository.fetch();
  }

  void _refresh() => setState(() => _status = widget.repository.fetch());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym Capo')),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Check again',
        child: const Icon(Icons.refresh),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<HealthStatus>(
            future: _status,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return _Unreachable(error: snapshot.error!);
              }
              return _StatusView(status: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({required this.status});

  final HealthStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          status.isHealthy ? Icons.check_circle : Icons.warning_amber,
          size: 64,
          color: status.isHealthy ? Colors.green : Colors.orange,
        ),
        const SizedBox(height: 16),
        Text(
          status.isHealthy ? 'API is healthy' : 'API is degraded',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        for (final check in status.checks.entries)
          ListTile(
            dense: true,
            leading: Icon(
              check.value ? Icons.check : Icons.close,
              color: check.value ? Colors.green : Colors.red,
            ),
            title: Text(check.key),
          ),
      ],
    );
  }
}

class _Unreachable extends StatelessWidget {
  const _Unreachable({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Text("Can't reach the API",
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Tried ${Env.apiBaseUrl}/health — is `sail up` running?',
            textAlign: TextAlign.center),
      ],
    );
  }
}
