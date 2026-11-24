import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'features/health_check/data/health_repository.dart';
import 'features/health_check/ui/health_page.dart';

class GymCapoApp extends StatelessWidget {
  const GymCapoApp({super.key, this.healthRepository});

  /// Injected in tests; built from the real API client otherwise.
  final HealthRepository? healthRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Capo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE8572A)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8572A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HealthPage(
        repository: healthRepository ?? HealthRepository(createApiClient()),
      ),
    );
  }
}
