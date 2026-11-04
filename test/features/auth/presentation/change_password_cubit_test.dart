import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/auth/presentation/change_password/change_password_cubit.dart';
import 'package:dut_curriculum_app/features/auth/presentation/change_password/change_password_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockAuthUseCases auth;
  late AppLocalizations strings;

  setUpAll(() async => strings = await loadStrings());
  setUp(() => auth = MockAuthUseCases());

  ChangePasswordCubit build() => ChangePasswordCubit(auth, strings);

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'matching, policy-compliant passwords reach the server',
    build: () {
      when(() => auth.changePassword(any(), any())).thenAnswer((_) async {});
      return build();
    },
    act: (cubit) => cubit.submit('old-pass1', 'newpass12', 'newpass12'),
    expect: () => [
      const ChangePasswordState(isSubmitting: true),
      const ChangePasswordState(isSuccess: true),
    ],
    verify: (_) =>
        verify(() => auth.changePassword('old-pass1', 'newpass12')).called(1),
  );

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'missing current password is rejected before the server',
    build: build,
    act: (cubit) => cubit.submit('', 'newpass12', 'newpass12'),
    expect: () => [
      const ChangePasswordState(isSubmitting: true),
      ChangePasswordState(errorMessage: strings.currentPasswordRequired),
    ],
    verify: (_) => verifyNever(() => auth.changePassword(any(), any())),
  );

  final weakPasswords = {
    'too short': 'short1',
    'letters only': 'onlyletters',
    'digits only': '12345678',
    'over 128 characters': 'a1${'b' * 130}',
  };
  weakPasswords.forEach((label, weak) {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'policy violation ($label) is rejected locally',
      build: build,
      act: (cubit) => cubit.submit('old-pass1', weak, weak),
      expect: () => [
        const ChangePasswordState(isSubmitting: true),
        ChangePasswordState(errorMessage: strings.passwordPolicy),
      ],
      verify: (_) => verifyNever(() => auth.changePassword(any(), any())),
    );
  });

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'a confirmation that differs is rejected locally',
    build: build,
    act: (cubit) => cubit.submit('old-pass1', 'newpass12', 'newpass13'),
    expect: () => [
      const ChangePasswordState(isSubmitting: true),
      ChangePasswordState(errorMessage: strings.passwordMismatch),
    ],
    verify: (_) => verifyNever(() => auth.changePassword(any(), any())),
  );

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'server 400 surfaces its own message',
    build: () {
      when(() => auth.changePassword(any(), any())).thenThrow(
        const ApiException(
          statusCode: 400,
          code: 'CURRENT_PASSWORD_WRONG',
          message: 'Mật khẩu hiện tại không đúng.',
        ),
      );
      return build();
    },
    act: (cubit) => cubit.submit('bad-pass1', 'newpass12', 'newpass12'),
    expect: () => [
      const ChangePasswordState(isSubmitting: true),
      const ChangePasswordState(errorMessage: 'Mật khẩu hiện tại không đúng.'),
    ],
  );

  blocTest<ChangePasswordCubit, ChangePasswordState>(
    'a submit while another is in flight is ignored',
    build: build,
    seed: () => const ChangePasswordState(isSubmitting: true),
    act: (cubit) => cubit.submit('a', 'b', 'c'),
    expect: () => <ChangePasswordState>[],
  );
}
