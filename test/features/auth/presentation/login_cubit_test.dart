import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/auth/presentation/login/login_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/login/login_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockAuthUseCases auth;
  late AppLocalizations strings;
  final user = sessionUser();

  setUpAll(() async => strings = await loadStrings());
  setUp(() => auth = MockAuthUseCases());

  blocTest<LoginCubit, LoginState>(
    'valid credentials sign in; the username is trimmed, the password is not',
    build: () {
      when(() => auth.login(any(), any())).thenAnswer((_) async => user);
      return LoginCubit(auth, strings);
    },
    act: (cubit) => cubit.submit('  demo.sinhvien ', ' pass word '),
    expect: () => [
      const LoginState(isSubmitting: true),
      LoginState(user: user),
    ],
    verify: (_) =>
        verify(() => auth.login('demo.sinhvien', ' pass word ')).called(1),
  );

  blocTest<LoginCubit, LoginState>(
    'blank username is rejected locally without calling the server',
    build: () => LoginCubit(auth, strings),
    act: (cubit) => cubit.submit('   ', 'x'),
    expect: () => [
      const LoginState(isSubmitting: true),
      LoginState(errorMessage: strings.requiredCredentials),
    ],
    verify: (_) => verifyNever(() => auth.login(any(), any())),
  );

  blocTest<LoginCubit, LoginState>(
    'empty password is rejected locally without calling the server',
    build: () => LoginCubit(auth, strings),
    act: (cubit) => cubit.submit('demo', ''),
    expect: () => [
      const LoginState(isSubmitting: true),
      LoginState(errorMessage: strings.requiredCredentials),
    ],
    verify: (_) => verifyNever(() => auth.login(any(), any())),
  );

  blocTest<LoginCubit, LoginState>(
    'server rejection surfaces the server message verbatim',
    build: () {
      when(() => auth.login(any(), any())).thenThrow(
        const ApiException(
          statusCode: 401,
          code: 'INVALID_CREDENTIALS',
          message: 'Tên đăng nhập hoặc mật khẩu không đúng.',
        ),
      );
      return LoginCubit(auth, strings);
    },
    act: (cubit) => cubit.submit('demo', 'wrong'),
    expect: () => [
      const LoginState(isSubmitting: true),
      const LoginState(errorMessage: 'Tên đăng nhập hoặc mật khẩu không đúng.'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'a submit while another is in flight is ignored',
    build: () => LoginCubit(auth, strings),
    seed: () => const LoginState(isSubmitting: true),
    act: (cubit) => cubit.submit('demo', 'x'),
    expect: () => <LoginState>[],
    verify: (_) => verifyNever(() => auth.login(any(), any())),
  );
}
