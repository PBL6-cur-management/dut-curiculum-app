import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/core/session/session_events.dart';
import 'package:dut_curriculum_app/features/auth/presentation/login/login_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/login/login_screen.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_state.dart';
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
  });

  tearDown(() async {
    await session.close();
    await events.dispose();
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: session),
            BlocProvider(create: (_) => LoginCubit(auth, strings)),
          ],
          child: const LoginScreen(),
        ),
      ),
    );
  }

  Future<void> openForm(WidgetTester tester) async {
    await tester.tap(find.text(strings.loginButton));
    await tester.pumpAndSettle();
  }

  Future<void> fillAndSubmit(
    WidgetTester tester, {
    String username = '',
    String password = '',
  }) async {
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), username);
    await tester.enterText(fields.at(1), password);
    await tester.tap(find.widgetWithText(FilledButton, strings.submitLogin));
    await tester.pumpAndSettle();
  }

  testWidgets('the landing page offers the login button and no form yet', (
    tester,
  ) async {
    await pumpLogin(tester);
    expect(find.text(strings.loginWelcome), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets(
    'empty credentials show the validation message without a prefix',
    (tester) async {
      await pumpLogin(tester);
      await openForm(tester);
      await fillAndSubmit(tester);
      expect(find.text(strings.requiredCredentials), findsWidgets);
      expect(find.textContaining('FormatException'), findsNothing);
      verifyNever(() => auth.login(any(), any()));
    },
  );

  testWidgets(
    'a rejected login shows the server message and stays signed out',
    (tester) async {
      when(() => auth.login('sv', 'bad')).thenThrow(
        const ApiException(
          statusCode: 401,
          code: 'AUTH_INVALID_CREDENTIALS',
          message: 'Sai tài khoản hoặc mật khẩu.',
        ),
      );
      await pumpLogin(tester);
      await openForm(tester);
      await fillAndSubmit(tester, username: 'sv', password: 'bad');
      expect(find.text('Sai tài khoản hoặc mật khẩu.'), findsWidgets);
      expect(session.state.status, SessionStatus.unknown);
    },
  );

  testWidgets('a successful login closes the sheet and signs the session in', (
    tester,
  ) async {
    final user = sessionUser();
    when(() => auth.login('sv', 'ok')).thenAnswer((_) async => user);
    await pumpLogin(tester);
    await openForm(tester);
    await fillAndSubmit(tester, username: ' sv ', password: 'ok');
    expect(session.state.status, SessionStatus.authenticated);
    expect(session.state.user, user);
    expect(find.byType(TextField), findsNothing);
  });
}
