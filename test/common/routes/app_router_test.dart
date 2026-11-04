import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/common/routes/app_router.dart';
import 'package:dut_curriculum_app/common/routes/go_router_refresh_stream.dart';
import 'package:dut_curriculum_app/common/routes/route_paths.dart';
import 'package:dut_curriculum_app/core/di/getit_utils.dart';
import 'package:dut_curriculum_app/core/session/session_events.dart';
import 'package:dut_curriculum_app/features/auth/presentation/change_password/change_password_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/login/login_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart';
import 'package:dut_curriculum_app/features/shell/domain/model/home_tile.dart';
import 'package:dut_curriculum_app/features/shell/presentation/components/home_tile_presentation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../support/domain_samples.dart';
import '../../support/test_doubles.dart';

void main() {
  late MockAuthUseCases auth;
  late SessionEvents events;
  late SessionCubit session;
  late AppLocalizations strings;

  setUpAll(() async => strings = await loadStrings());

  setUp(() {
    auth = MockAuthUseCases();
    events = SessionEvents();
    session = SessionCubit(auth, events);
    getIt.registerFactory<LoginCubit>(() => LoginCubit(auth, strings));
    getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(auth, strings),
    );
  });

  tearDown(() async {
    await getIt.reset();
    await session.close();
    await events.dispose();
  });

  Future<GoRouter> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final refresh = GoRouterRefreshStream(session.stream);
    final router = buildRouter(session, refresh: refresh);
    addTearDown(() {
      router.dispose();
      refresh.dispose();
    });
    await tester.pumpWidget(
      BlocProvider.value(
        value: session,
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
    return router;
  }

  String location(GoRouter router) =>
      router.routeInformationProvider.value.uri.path;

  Future<void> restoreAs(WidgetTester tester, {bool signedIn = true}) async {
    when(
      () => auth.currentUser(),
    ).thenAnswer((_) async => signedIn ? sessionUser() : null);
    await session.restore();
    await tester.pumpAndSettle();
  }

  testWidgets('while the session is unknown the app stays on the splash', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    expect(location(router), RoutePaths.splash);
  });

  testWidgets('an anonymous visitor lands on the login page', (tester) async {
    final router = await pumpApp(tester);
    await restoreAs(tester, signedIn: false);
    expect(location(router), RoutePaths.login);
    expect(find.text(strings.loginWelcome), findsOneWidget);
  });

  testWidgets('a deep link while signed out is redirected to login', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    await restoreAs(tester, signedIn: false);
    router.go(RoutePaths.curriculumProgram);
    await tester.pumpAndSettle();
    expect(location(router), RoutePaths.login);
  });

  testWidgets('a signed-in student leaves splash for the home page', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    await restoreAs(tester);
    expect(location(router), RoutePaths.home);
    expect(find.text(HomeTile.curriculum.label(strings)), findsOneWidget);
  });

  testWidgets('a signed-in student cannot go back to the login page', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    await restoreAs(tester);
    router.go(RoutePaths.login);
    await tester.pumpAndSettle();
    expect(location(router), RoutePaths.home);
  });

  testWidgets('a forced password change blocks every other page', (
    tester,
  ) async {
    when(
      () => auth.currentUser(),
    ).thenAnswer((_) async => sessionUser(mustChangePassword: true));
    final router = await pumpApp(tester);
    await session.restore();
    await tester.pumpAndSettle();
    expect(location(router), RoutePaths.changePassword);
    router.go(RoutePaths.home);
    await tester.pumpAndSettle();
    expect(location(router), RoutePaths.changePassword);
  });

  testWidgets('finishing the password change releases the student to home', (
    tester,
  ) async {
    when(
      () => auth.currentUser(),
    ).thenAnswer((_) async => sessionUser(mustChangePassword: true));
    final router = await pumpApp(tester);
    await session.restore();
    await tester.pumpAndSettle();
    session.passwordChanged();
    router.go(RoutePaths.home);
    await tester.pumpAndSettle();
    expect(location(router), RoutePaths.home);
  });

  testWidgets('an unknown placeholder tile shows the unknown-tile message', (
    tester,
  ) async {
    final router = await pumpApp(tester);
    await restoreAs(tester);
    router.go(RoutePaths.placeholderFor('does-not-exist'));
    await tester.pumpAndSettle();
    expect(find.text(strings.unknownTile), findsOneWidget);
  });
}
