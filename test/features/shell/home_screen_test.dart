import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/common/routes/route_paths.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_state.dart';
import 'package:dut_curriculum_app/features/shell/domain/model/home_tile.dart';
import 'package:dut_curriculum_app/features/shell/presentation/components/home_tile_presentation.dart';
import 'package:dut_curriculum_app/features/shell/presentation/home/home_screen.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../support/domain_samples.dart';

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late AppLocalizations strings;
  setUpAll(() async => strings = await loadStrings());

  Future<List<String>> pumpHome(WidgetTester tester, SessionState state) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final session = _MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: state,
    );
    final pushed = <String>[];
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => BlocProvider<SessionCubit>.value(
            value: session,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/:rest(.*)',
          builder: (context, routeState) {
            pushed.add(routeState.uri.toString());
            return const Scaffold(body: Text('destination'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pump();
    return pushed;
  }

  testWidgets('shows the signed-in student and one tile per feature', (
    tester,
  ) async {
    final user = sessionUser();
    await pumpHome(
      tester,
      SessionState(status: SessionStatus.authenticated, user: user),
    );
    expect(find.text(user.fullName), findsOneWidget);
    for (final tile in HomeTile.values) {
      expect(find.text(tile.label(strings)), findsOneWidget);
    }
  });

  testWidgets('the curriculum tile opens the curriculum route', (tester) async {
    final pushed = await pumpHome(
      tester,
      SessionState(status: SessionStatus.authenticated, user: sessionUser()),
    );
    await tester.tap(find.text(HomeTile.curriculum.label(strings)));
    await tester.pumpAndSettle();
    expect(pushed, [RoutePaths.curriculumProgram]);
  });

  testWidgets('a not-yet-built tile opens its placeholder route', (
    tester,
  ) async {
    final pushed = await pumpHome(
      tester,
      SessionState(status: SessionStatus.authenticated, user: sessionUser()),
    );
    await tester.tap(find.text(HomeTile.tuition.label(strings)));
    await tester.pumpAndSettle();
    expect(pushed, [RoutePaths.placeholderFor(HomeTile.tuition.name)]);
  });

  testWidgets('without a user the tiles are not shown', (tester) async {
    await pumpHome(tester, const SessionState());
    expect(find.text(HomeTile.curriculum.label(strings)), findsNothing);
  });
}
