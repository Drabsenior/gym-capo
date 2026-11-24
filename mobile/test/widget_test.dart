import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_capo/app.dart';
import 'package:gym_capo/features/health_check/data/health_repository.dart';
import 'package:gym_capo/features/health_check/data/health_status.dart';

/// Answers like the real API would, without a network.
class FakeHealthRepository extends HealthRepository {
  FakeHealthRepository(this.answer) : super(Dio());

  final Future<HealthStatus> Function() answer;

  @override
  Future<HealthStatus> fetch() => answer();
}

void main() {
  testWidgets('shows healthy when every check passes', (tester) async {
    await tester.pumpWidget(GymCapoApp(
      healthRepository: FakeHealthRepository(() async => const HealthStatus(
            status: 'ok',
            app: 'Gym Capo',
            checks: {'database': true, 'redis': true},
          )),
    ));
    await tester.pumpAndSettle();

    expect(find.text('API is healthy'), findsOneWidget);
    expect(find.text('database'), findsOneWidget);
    expect(find.text('redis'), findsOneWidget);
  });

  testWidgets('shows degraded when a dependency is down', (tester) async {
    await tester.pumpWidget(GymCapoApp(
      healthRepository: FakeHealthRepository(() async => const HealthStatus(
            status: 'degraded',
            app: 'Gym Capo',
            checks: {'database': true, 'redis': false},
          )),
    ));
    await tester.pumpAndSettle();

    expect(find.text('API is degraded'), findsOneWidget);
  });

  testWidgets('explains when the API cannot be reached', (tester) async {
    await tester.pumpWidget(GymCapoApp(
      healthRepository:
          FakeHealthRepository(() async => throw Exception('no network')),
    ));
    await tester.pumpAndSettle();

    expect(find.text("Can't reach the API"), findsOneWidget);
  });
}
