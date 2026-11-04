import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/academic_result.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/graduation_outcome_dto.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/elective_group_row.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/knowledge_block_row.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/conclusion_banner.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/credit_progress_card.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/result_row.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/credit_breakdown.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/portal_widget_harness.dart';
import '../../../support/fixtures.dart';

void main() {
  late MockProgressCubit cubit;
  Future<void> pump(
    WidgetTester tester,
    ProgressState state, {
    double scale = portalNormalTextScale,
  }) async {
    cubit = MockProgressCubit();
    whenListen(cubit, const Stream<ProgressState>.empty(), initialState: state);
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
        child: BlocProvider<ProgressCubit>.value(
          value: cubit,
          child: const ProgressScreen(),
        ),
      ),
    );
  }

  testWidgets('reviewed credits render before independent history finishes', (
    tester,
  ) async {
    final strings = await loadStrings();
    await pump(
      tester,
      ProgressState(graduation: graduationSample(strings), fraction: 0.25),
    );
    expect(find.byType(CreditProgressCard), findsOneWidget);
    expect(find.byType(ConclusionBanner), findsNothing);
    expect(find.byType(CreditBreakdown), findsNothing);
    await tester.tap(find.text(strings.portalCreditBreakdown));
    await tester.pumpAndSettle();
    expect(find.byType(CreditBreakdown), findsOneWidget);
  });
  for (final failure in ['diagnostic', 'unsupported', 'mismatch', 'empty']) {
    testWidgets('$failure has no KPI but loaded results remain usable', (
      tester,
    ) async {
      final strings = await loadStrings();
      final outcome = switch (failure) {
        'diagnostic' => const GraduationCannotAudit('Diagnostic mẫu'),
        'unsupported' => const GraduationUnsupported(99),
        _ => null,
      };
      await pump(
        tester,
        ProgressState(
          isLoading: false,
          graduation: outcome,
          graduationError: failure == 'mismatch'
              ? 'graduation-context-mismatch'
              : null,
          resultsLoaded: true,
          results: resultsSample().items,
          total: resultsSample().items.length,
        ),
      );
      expect(find.byType(CreditProgressCard), findsNothing);
      expect(find.byType(ConclusionBanner), findsNothing);
      await tester.tap(find.text(strings.portalResultsTab));
      await tester.pumpAndSettle();
      expect(
        find.byType(ResultRow),
        findsNWidgets(resultsSample().items.length),
      );
      expect(find.text(strings.portalHistoryScope), findsOneWidget);
    });
  }
  testWidgets(
    'history can render while review still loading and each attempt has its ID key',
    (tester) async {
      final sample = resultsSample().items.first;
      final repeated = AcademicResult(
        id: 'attempt-2',
        course: sample.course,
        semester: sample.semester,
        score10: sample.score10,
        score4: sample.score4,
        letterGrade: sample.letterGrade,
        status: sample.status,
      );
      await pump(
        tester,
        ProgressState(
          resultsLoaded: true,
          results: [sample, repeated],
          total: 2,
        ),
      );
      final strings = await loadStrings();
      await tester.tap(find.text(strings.portalResultsTab));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey(sample.id)), findsOneWidget);
      expect(find.byKey(const ValueKey('attempt-2')), findsOneWidget);
      await tester.tap(find.byType(ResultRow).first);
      await tester.pumpAndSettle();
      expect(find.text(strings.scoreTenLabel), findsOneWidget);
      expect(find.text(strings.letterGradeLabel), findsOneWidget);
    },
  );
  for (final scale in ['letter', '10', '4', 'unknown']) {
    testWidgets('main grade $scale is explicit with correct numeric fallback', (
      tester,
    ) async {
      final sample = resultsSample().items.first;
      final result = AcademicResult(
        id: sample.id,
        course: sample.course,
        semester: sample.semester,
        score10: scale == '10' ? '7.50' : null,
        score4: scale == '4' ? '3.25' : null,
        letterGrade: scale == 'letter' ? 'B' : null,
        status: sample.status,
      );
      await pump(
        tester,
        ProgressState(
          isLoading: false,
          resultsLoaded: true,
          results: [result],
          total: 1,
        ),
      );
      final strings = await loadStrings();
      await tester.tap(find.text(strings.portalResultsTab));
      await tester.pumpAndSettle();
      expect(
        find.text(switch (scale) {
          'letter' => 'B',
          '10' => strings.portalScore10('7,50'),
          '4' => strings.portalScore4('3,25'),
          _ => strings.emptyValue,
        }),
        findsOneWidget,
      );
    });
  }
  testWidgets('later-page error keeps rows and retries loadMore', (
    tester,
  ) async {
    final rows = resultsSample().items;
    await pump(
      tester,
      ProgressState(
        isLoading: false,
        resultsLoaded: true,
        results: rows,
        total: rows.length + 1,
        resultsError: 'Erreur page suivante',
      ),
    );
    when(() => cubit.loadMore()).thenAnswer((_) async {});
    final strings = await loadStrings();
    await tester.tap(find.text(strings.portalResultsTab));
    await tester.pumpAndSettle();
    expect(find.byType(ResultRow), findsNWidgets(rows.length));
    await tester.ensureVisible(find.text(strings.retry));
    await tester.tap(find.text(strings.retry));
    verify(() => cubit.loadMore()).called(1);
    verifyNever(() => cubit.load());
  });
  testWidgets('first-page error retries existing joint load', (tester) async {
    await pump(
      tester,
      const ProgressState(isLoading: false, resultsError: 'Erreur historique'),
    );
    when(() => cubit.load()).thenAnswer((_) async {});
    final strings = await loadStrings();
    await tester.tap(find.text(strings.portalResultsTab));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.retry));
    verify(() => cubit.load()).called(1);
  });
  testWidgets(
    'breakdown distinguishes null targets from zero and keeps named blocks descriptive',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final strings = await loadStrings();
      final json = objectFixture('graduation');
      final result = json['result'] as Map<String, dynamic>;
      final groups = result['electiveGroups'] as List;
      groups.add({
        ...groups.first as Map<String, dynamic>,
        'groupCode': 'ZERO',
        'groupName': 'Zéro requis',
        'requiredCredits': '0.00',
        'missingCredits': '0.00',
        'requiredCourses': 0,
        'missingCourses': 0,
      });
      (result['knowledgeBlocks'] as List).add({
        'blockSymbol': 'BLOCK',
        'blockName': 'Bloc descriptif',
        'earnedCredits': '3.00',
        'compulsoryCredits': '3.00',
        'electiveCredits': '0.00',
        'catalogRequiredCredits': '9.00',
        'advisoryGap': '6.00',
      });
      await pump(
        tester,
        ProgressState(
          isLoading: false,
          graduation: GraduationOutcomeDto.fromJson(json).toDomain(strings),
        ),
      );
      await tester.tap(find.text(strings.portalCreditBreakdown));
      await tester.pumpAndSettle();
      final rows = tester
          .widgetList<ElectiveGroupRow>(find.byType(ElectiveGroupRow))
          .toList();
      expect(rows.first.requiredCredits, isNull);
      expect(rows.last.requiredCredits, '0.00');
      expect(
        find.text(
          strings.requiredEarnedMissing(
            strings.notSpecified,
            '0,00',
            strings.notSpecified,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.text(strings.requiredEarnedMissing('0,00', '0,00', '0,00')),
        findsOneWidget,
      );
      expect(find.byType(KnowledgeBlockRow), findsOneWidget);
      expect(find.text('Bloc descriptif'), findsOneWidget);
      expect(find.textContaining('6,00'), findsNothing);
      expect(find.byType(ConclusionBanner), findsNothing);
    },
  );
  testWidgets(
    'review remains useful when history fails and long credit labels wrap at large scale',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final strings = await loadStrings();
      await pump(
        tester,
        ProgressState(
          isLoading: false,
          graduation: graduationSample(strings),
          resultsError: 'Erreur indépendante',
          fraction: 0.25,
        ),
        scale: portalLargeTextScale,
      );
      expect(find.byType(CreditProgressCard), findsOneWidget);
      expect(find.text('Erreur indépendante'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(strings.portalResultsTab));
      await tester.pumpAndSettle();
      expect(find.text('Erreur indépendante'), findsOneWidget);
      await tester.tap(find.text(strings.portalProgressTab));
      await tester.pumpAndSettle();
      expect(find.byType(CreditProgressCard), findsOneWidget);
      verifyNever(() => cubit.load());
    },
  );
  for (final denominator in ['0.00', '120.00']) {
    testWidgets('KPI denominator $denominator handles zero and caps ratio', (
      tester,
    ) async {
      final contextCubit = MockPortalContextCubit();
      whenListen(
        contextCubit,
        const Stream<PortalContextState>.empty(),
        initialState: portalContextStateSample(),
      );
      await tester.pumpWidget(
        portalHarness(
          contextCubit: contextCubit,
          child: Scaffold(
            body: CreditProgressCard(
              fraction: 2,
              required: denominator,
              recognized: '150.00',
              missing: '0.00',
              compulsory: '100.00',
              elective: '50.00',
              free: '0.00',
            ),
          ),
        ),
      );
      final strings = await loadStrings();
      if (denominator == '0.00') {
        expect(find.text(strings.portalNotApplicable), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsNothing);
      } else {
        expect(find.text(strings.percentValue('100')), findsOneWidget);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator),
              )
              .value,
          1,
        );
      }
    });
  }
}
