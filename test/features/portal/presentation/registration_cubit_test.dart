import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_item.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_report.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockPortalUseCases portal;
  late AppLocalizations strings;
  late EligibilityReport report;
  setUpAll(() async {
    strings = await loadStrings();
  });
  setUp(() => portal = MockPortalUseCases());

  EligibilityItem item(
    String id, {
    required bool completed,
    Eligibility? eligibility,
  }) {
    final base = eligibilitySample(strings).items.first;
    return EligibilityItem(
      itemId: id,
      course: base.course,
      credits: base.credits,
      catalogStatus: base.catalogStatus,
      plannedSemester: base.plannedSemester,
      completed: completed,
      eligibility: eligibility,
      statusText: base.statusText,
      reasons: base.reasons,
      requiredConcurrentCourses: base.requiredConcurrentCourses,
    );
  }

  EligibilityReport buildReport() => EligibilityReport(
    evaluatedAtMs: 1,
    warnings: const [],
    items: [
      item('eligible', completed: false, eligibility: Eligibility.eligible),
      item(
        'conditional',
        completed: false,
        eligibility: Eligibility.conditional,
      ),
      item('blocked', completed: false, eligibility: Eligibility.ineligible),
      item('done', completed: true),
      item('unknown', completed: false),
    ],
  );

  setUpAll(() => report = buildReport());

  blocTest<RegistrationCubit, RegistrationState>(
    'load exposes the report',
    build: () {
      when(
        () => portal.eligibility(portalContext),
      ).thenAnswer((_) async => report);
      return RegistrationCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const RegistrationState(),
      RegistrationState(isLoading: false, report: report),
    ],
  );

  test(
    'registrable and blocked lists split open items and drop completed ones',
    () {
      final state = RegistrationState(isLoading: false, report: report);
      expect(state.allowed.map((i) => i.itemId), ['eligible', 'conditional']);
      expect(state.blocked.map((i) => i.itemId), ['blocked']);
      expect(state.unknown.map((item) => item.itemId), ['unknown']);
    },
  );

  test('without a report both lists are empty', () {
    const state = RegistrationState();
    expect(state.allowed, isEmpty);
    expect(state.blocked, isEmpty);
    expect(state.unknown, isEmpty);
  });

  blocTest<RegistrationCubit, RegistrationState>(
    'an unsupported contract version is reported with its message',
    build: () {
      when(
        () => portal.eligibility(portalContext),
      ).thenThrow(const ContractException('Chưa hỗ trợ phiên bản kết quả này'));
      return RegistrationCubit(portal, portalContext);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const RegistrationState(),
      const RegistrationState(
        isLoading: false,
        errorMessage: 'Chưa hỗ trợ phiên bản kết quả này',
      ),
    ],
  );
}
