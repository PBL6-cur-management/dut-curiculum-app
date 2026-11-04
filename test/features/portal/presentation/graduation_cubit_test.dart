import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockPortalUseCases portal;
  late AppLocalizations strings;
  setUpAll(() async => strings = await loadStrings());
  setUp(() => portal = MockPortalUseCases());

  GraduationCubit build(GraduationOutcome outcome) {
    when(
      () => portal.graduation(portalContext),
    ).thenAnswer((_) async => outcome);
    return GraduationCubit(portal, portalContext);
  }

  blocTest<GraduationCubit, GraduationState>(
    'reviewed outcome carries the credit fraction',
    build: () => build(graduationSample(strings)),
    act: (cubit) => cubit.load(),
    expect: () => [
      const GraduationState(),
      GraduationState(
        isLoading: false,
        outcome: graduationSample(strings),
        fraction: 3 / 120,
      ),
    ],
  );

  blocTest<GraduationCubit, GraduationState>(
    'cannot-audit keeps the server diagnostic and a zero fraction',
    build: () => build(const GraduationCannotAudit('Thiếu cấu hình khoa')),
    act: (cubit) => cubit.load(),
    expect: () => [
      const GraduationState(),
      const GraduationState(
        isLoading: false,
        outcome: GraduationCannotAudit('Thiếu cấu hình khoa'),
      ),
    ],
  );

  blocTest<GraduationCubit, GraduationState>(
    'an unsupported schema is passed through, not treated as an error',
    build: () => build(const GraduationUnsupported(2)),
    act: (cubit) => cubit.load(),
    expect: () => [
      const GraduationState(),
      const GraduationState(
        isLoading: false,
        outcome: GraduationUnsupported(2),
      ),
    ],
  );

  blocTest<GraduationCubit, GraduationState>(
    'failure carries the thrown message',
    build: () {
      when(() => portal.graduation(portalContext)).thenThrow(
        const ApiException(
          statusCode: 500,
          code: 'HTTP',
          message: 'Lỗi tính toán',
        ),
      );
      return GraduationCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const GraduationState(),
      const GraduationState(isLoading: false, errorMessage: 'Lỗi tính toán'),
    ],
  );
}
