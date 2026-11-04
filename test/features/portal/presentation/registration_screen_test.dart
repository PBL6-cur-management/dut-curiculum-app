import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/common/theme/app_colors.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/catalog_status.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_ref.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_item.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_report.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_warning.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/eligibility_chip.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/eligibility_item_card.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/portal_widget_harness.dart';

EligibilityItem adviceItem(
  String id,
  Eligibility? eligibility, {
  bool completed = false,
  CatalogStatus catalog = CatalogStatus.active,
}) => EligibilityItem(
  itemId: id,
  course: CourseRef(id: id, code: id, name: 'Học phần $id'),
  credits: '3.00',
  catalogStatus: catalog,
  plannedSemester: 2,
  completed: completed,
  eligibility: eligibility,
  statusText: 'État $id',
  reasons: ['Raison $id', 'Explication complète $id'],
  requiredConcurrentCourses: eligibility == Eligibility.conditional
      ? const [CourseRef(id: 'together', code: 'CO', name: 'Học phần học cùng')]
      : const [],
);

void main() {
  late MockRegistrationCubit cubit;
  Future<void> pump(
    WidgetTester tester,
    RegistrationState state, {
    double scale = portalNormalTextScale,
  }) async {
    cubit = MockRegistrationCubit();
    whenListen(
      cubit,
      const Stream<RegistrationState>.empty(),
      initialState: state,
    );
    final contextCubit = MockPortalContextCubit();
    whenListen(
      contextCubit,
      const Stream<PortalContextState>.empty(),
      initialState: portalContextStateSample(),
    );
    await tester.pumpWidget(
      portalHarness(
        contextCubit: contextCubit,
        textScale: scale,
        child: BlocProvider<RegistrationCubit>.value(
          value: cubit,
          child: const RegistrationScreen(semesterCode: '2026-1'),
        ),
      ),
    );
  }

  EligibilityReport report(
    List<EligibilityItem> items, {
    List<EligibilityWarning> warnings = const [],
  }) => EligibilityReport(evaluatedAtMs: 0, items: items, warnings: warnings);
  testWidgets(
    'allowed and blocked counts exclude completed and unknown items',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        RegistrationState(
          isLoading: false,
          report: report([
            adviceItem('EL', Eligibility.eligible),
            adviceItem('CO', Eligibility.conditional),
            adviceItem('BL', Eligibility.ineligible),
            adviceItem('UN', null),
            adviceItem('DONE', null, completed: true),
          ]),
        ),
      );
      final strings = await loadStrings();
      expect(find.text(strings.portalEligibilityAdvice), findsOneWidget);
      expect(find.text(strings.registrationAllowed), findsOneWidget);
      expect(find.text(strings.registrationBlocked), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.byKey(const ValueKey('DONE')), findsNothing);
      expect(find.byKey(const ValueKey('BL')), findsNothing);
      await tester.ensureVisible(find.byKey(const ValueKey('UN')));
      final unknownChip = tester.widget<EligibilityChip>(
        find.descendant(
          of: find.byKey(const ValueKey('UN')),
          matching: find.byType(EligibilityChip),
        ),
      );
      expect(unknownChip.color, AppColors.stateNeutral);
      await tester.tap(find.text(strings.registrationBlocked));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('BL')), findsOneWidget);
      expect(find.byKey(const ValueKey('EL')), findsNothing);
    },
  );
  testWidgets(
    'conditional obligation and catalogue/material warnings show before details',
    (tester) async {
      final item = adviceItem(
        'CO',
        Eligibility.conditional,
        catalog: CatalogStatus.discontinued,
      );
      await pump(
        tester,
        RegistrationState(
          isLoading: false,
          report: report(
            [item],
            warnings: [
              EligibilityWarning(
                message: 'Avertissement important',
                course: item.course,
              ),
            ],
          ),
        ),
      );
      final strings = await loadStrings();
      expect(
        find.text(strings.mustStudyTogether('CO · Học phần học cùng')),
        findsOneWidget,
      );
      expect(find.text(strings.catalogDiscontinued), findsOneWidget);
      expect(find.text('Avertissement important'), findsOneWidget);
      expect(find.text('Explication complète CO'), findsNothing);
      await tester.tap(find.text('Học phần CO'));
      await tester.pumpAndSettle();
      expect(find.text(strings.portalConditions), findsOneWidget);
      expect(find.text('Explication complète CO'), findsOneWidget);
    },
  );
  for (final kind in ['empty', 'completed', 'category']) {
    testWidgets(
      '$kind has truthful empty explanation and keeps warnings reachable',
      (tester) async {
        final done = adviceItem('DONE', null, completed: true);
        await pump(
          tester,
          RegistrationState(
            isLoading: false,
            report: report(
              kind == 'empty'
                  ? []
                  : [
                      kind == 'completed'
                          ? done
                          : adviceItem('BL', Eligibility.ineligible),
                    ],
              warnings: [
                EligibilityWarning(
                  message: 'Attention hors liste',
                  course: done.course,
                ),
              ],
            ),
          ),
        );
        final strings = await loadStrings();
        expect(
          find.text(switch (kind) {
            'empty' => strings.noData,
            'completed' => strings.portalAllCompleted,
            _ => strings.portalNoCandidates,
          }),
          findsOneWidget,
        );
        await tester.tap(find.text(strings.warningCount(1)));
        await tester.pumpAndSettle();
        expect(find.textContaining('Attention hors liste'), findsOneWidget);
        expect(find.text(strings.eligible), findsNothing);
      },
    );
  }
  testWidgets(
    'conditional names and counted tabs remain readable at narrow large text',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        RegistrationState(
          isLoading: false,
          report: report([adviceItem('CO', Eligibility.conditional)]),
        ),
        scale: portalLargeTextScale,
      );
      final strings = await loadStrings();
      await tester.scrollUntilVisible(
        find.text(strings.mustStudyTogether('CO · Học phần học cùng')),
        portalTestHeight / 2,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
      expect(find.text(strings.registrationAllowed), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    },
  );
  testWidgets(
    'incomplete response is an error with retry, never an empty allowed answer',
    (tester) async {
      await pump(
        tester,
        const RegistrationState(
          isLoading: false,
          errorMessage: 'Snapshot incomplet',
        ),
      );
      when(() => cubit.load()).thenAnswer((_) async {});
      expect(find.byType(EligibilityItemCard), findsNothing);
      final strings = await loadStrings();
      expect(find.text(strings.portalNoCandidates), findsNothing);
      await tester.tap(find.text(strings.retry));
      verify(() => cubit.load()).called(1);
    },
  );
}
