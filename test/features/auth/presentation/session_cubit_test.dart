import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/core/session/session_events.dart';
import 'package:dut_curriculum_app/features/auth/domain/model/session_user.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockAuthUseCases auth;
  late SessionEvents events;
  final user = sessionUser();

  setUp(() {
    auth = MockAuthUseCases();
    events = SessionEvents();
  });

  tearDown(() => events.dispose());

  SessionCubit build() => SessionCubit(auth, events);

  blocTest<SessionCubit, SessionState>(
    'restore with a live session authenticates the user',
    build: () {
      when(() => auth.currentUser()).thenAnswer((_) async => user);
      return build();
    },
    act: (cubit) => cubit.restore(),
    expect: () => [
      SessionState(status: SessionStatus.authenticated, user: user),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'restore without a session is unauthenticated and silent',
    build: () {
      when(() => auth.currentUser()).thenAnswer((_) async => null);
      return build();
    },
    act: (cubit) => cubit.restore(),
    expect: () => [const SessionState(status: SessionStatus.unauthenticated)],
  );

  blocTest<SessionCubit, SessionState>(
    'restore failure carries the real exception message',
    build: () {
      when(() => auth.currentUser()).thenThrow(
        const ApiException(
          statusCode: null,
          code: 'NETWORK',
          message: 'Mất mạng',
        ),
      );
      return build();
    },
    act: (cubit) => cubit.restore(),
    expect: () => [
      const SessionState(
        status: SessionStatus.unauthenticated,
        notice: 'Mất mạng',
        errorMessage: 'Mất mạng',
      ),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'a stale restore never overwrites a newer sign-in',
    build: () {
      final slow = Completer<SessionUser?>();
      when(() => auth.currentUser()).thenAnswer((_) => slow.future);
      return build();
    },
    act: (cubit) {
      final pending = cubit.restore();
      cubit.signedIn(user);
      return pending.timeout(
        const Duration(milliseconds: 20),
        onTimeout: () {},
      );
    },
    expect: () => [
      SessionState(status: SessionStatus.authenticated, user: user),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'passwordChanged clears the forced-change flag when authenticated',
    build: build,
    seed: () => SessionState(
      status: SessionStatus.authenticated,
      user: sessionUser(mustChangePassword: true),
    ),
    act: (cubit) => cubit.passwordChanged(),
    expect: () => [
      SessionState(status: SessionStatus.authenticated, user: user),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'passwordChanged is ignored while unauthenticated',
    build: build,
    seed: () => const SessionState(status: SessionStatus.unauthenticated),
    act: (cubit) => cubit.passwordChanged(),
    expect: () => <SessionState>[],
  );

  blocTest<SessionCubit, SessionState>(
    'logout signs out through the server then lands unauthenticated',
    build: () {
      when(() => auth.logout()).thenAnswer((_) async {});
      return build();
    },
    seed: () => SessionState(status: SessionStatus.authenticated, user: user),
    act: (cubit) => cubit.logout(),
    expect: () => [
      SessionState(
        status: SessionStatus.authenticated,
        user: user,
        isSigningOut: true,
      ),
      const SessionState(status: SessionStatus.unauthenticated),
    ],
    verify: (_) => verify(() => auth.logout()).called(1),
  );

  blocTest<SessionCubit, SessionState>(
    'logout failure still ends the session and reports the error',
    build: () {
      when(() => auth.logout()).thenThrow(
        const ApiException(
          statusCode: 500,
          code: 'HTTP',
          message: 'Máy chủ lỗi',
        ),
      );
      return build();
    },
    seed: () => SessionState(status: SessionStatus.authenticated, user: user),
    act: (cubit) => cubit.logout(),
    expect: () => [
      SessionState(
        status: SessionStatus.authenticated,
        user: user,
        isSigningOut: true,
      ),
      const SessionState(
        status: SessionStatus.unauthenticated,
        notice: 'Máy chủ lỗi',
        errorMessage: 'Máy chủ lỗi',
      ),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'a second logout while one is running is ignored',
    build: build,
    seed: () => SessionState(
      status: SessionStatus.authenticated,
      user: user,
      isSigningOut: true,
    ),
    act: (cubit) => cubit.logout(),
    expect: () => <SessionState>[],
    verify: (_) => verifyNever(() => auth.logout()),
  );

  blocTest<SessionCubit, SessionState>(
    'expiry event signs an authenticated user out with the expiry notice',
    build: build,
    seed: () => SessionState(status: SessionStatus.authenticated, user: user),
    act: (_) async {
      events.notifyExpired();
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => [
      const SessionState(
        status: SessionStatus.unauthenticated,
        notice: SessionState.expiredNotice,
      ),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'expiry event is ignored when nobody is signed in',
    build: build,
    seed: () => const SessionState(status: SessionStatus.unauthenticated),
    act: (_) async {
      events.notifyExpired();
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => <SessionState>[],
  );

  blocTest<SessionCubit, SessionState>(
    'clearNotice drops the notice and the error together',
    build: build,
    seed: () => const SessionState(
      status: SessionStatus.unauthenticated,
      notice: 'x',
      errorMessage: 'x',
    ),
    act: (cubit) => cubit.clearNotice(),
    expect: () => [const SessionState(status: SessionStatus.unauthenticated)],
  );
}
