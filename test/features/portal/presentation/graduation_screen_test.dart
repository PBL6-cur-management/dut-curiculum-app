import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/common/routes/route_paths.dart';
import 'package:dut_curriculum_app/common/utils/date_format.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/graduation_outcome_dto.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/conclusion_banner.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/credit_progress_card.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/elective_group_row.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/knowledge_block_row.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/shortfall_group.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/fixtures.dart';
import '../../../support/portal_widget_harness.dart';

void main() {
  late MockGraduationCubit cubit;
  Future<void> pump(
    WidgetTester tester,
    GraduationState state, {
    double scale = portalNormalTextScale,
  }) async {
    cubit = MockGraduationCubit();
    whenListen(
      cubit,
      const Stream<GraduationState>.empty(),
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
        child: BlocProvider<GraduationCubit>.value(
          value: cubit,
          child: const GraduationScreen(),
        ),
      ),
    );
  }

  for (final conclusion in ['ELIGIBLE', 'NOT_ELIGIBLE']) {
    testWidgets(
      '$conclusion answer leads limitation and does not duplicate accounting',
      (tester) async {
        final strings = await loadStrings();
        final json = objectFixture('graduation');
        (json['result'] as Map<String, dynamic>)['conclusion'] = conclusion;
        final outcome = GraduationOutcomeDto.fromJson(json).toDomain(strings);
        await pump(tester, GraduationState(isLoading: false, outcome: outcome));
        final banner = tester.widget<ConclusionBanner>(
          find.byType(ConclusionBanner),
        );
        expect(
          banner.label,
          conclusion == 'ELIGIBLE' ? strings.eligible : strings.ineligible,
        );
        expect(banner.lines, [strings.graduationInfo]);
        expect(
          tester.getTopLeft(find.text(banner.label)).dy,
          lessThan(tester.getTopLeft(find.text(strings.graduationInfo)).dy),
        );
        expect(find.byType(CreditProgressCard), findsNothing);
        expect(find.byType(ElectiveGroupRow), findsNothing);
        expect(find.byType(KnowledgeBlockRow), findsNothing);
        expect(find.text('SYN26'), findsNothing);
        expect(find.text('Lưu ý mẫu'), findsNothing);
        await tester.tap(find.text(strings.warningCount(1)));
        await tester.pumpAndSettle();
        expect(find.text('Lưu ý mẫu'), findsOneWidget);
      },
    );
  }
  for (final category in ['TOTAL_CREDITS', 'CONDITIONAL_COURSE', 'none']) {
    testWidgets(
      '$category controls compact totals without changing server conclusion',
      (tester) async {
        final strings = await loadStrings();
        final json = objectFixture('graduation');
        final result = json['result'] as Map<String, dynamic>;
        result['shortfalls'] = category == 'none'
            ? <Object>[]
            : [
                {
                  'category': category,
                  'code': category == 'TOTAL_CREDITS'
                      ? 'TOTAL_CREDITS_MISSING'
                      : 'CONDITIONAL_COURSE_MISSING',
                  'message': 'Condition zéro crédit encore requise',
                },
              ];
        final outcome = GraduationOutcomeDto.fromJson(json).toDomain(strings);
        await pump(tester, GraduationState(isLoading: false, outcome: outcome));
        final totals = strings.requiredEarnedMissing(
          '120,00',
          '3,00',
          '117,00',
        );
        expect(
          find.text(totals),
          category == 'TOTAL_CREDITS' ? findsOneWidget : findsNothing,
        );
        expect(find.text(strings.ineligible), findsOneWidget);
        if (category == 'none')
          expect(find.text(strings.portalNoShortfalls), findsOneWidget);
        else
          expect(
            find.text('Condition zéro crédit encore requise'),
            findsOneWidget,
          );
        if (category == 'TOTAL_CREDITS') {
          expect(
            tester.getTopLeft(find.text(totals)).dy,
            greaterThan(
              tester.getBottomLeft(find.byType(ShortfallGroup)).dy - 1,
            ),
          );
          expect(
            tester.getTopLeft(find.text(totals)).dy,
            lessThan(
              tester
                  .getTopLeft(find.byKey(const PageStorageKey('warnings')))
                  .dy,
            ),
          );
        }
      },
    );
  }
  testWidgets(
    'basis is initially collapsed and exposes actual time/version on demand',
    (tester) async {
      final strings = await loadStrings();
      final outcome = graduationSample(strings) as GraduationReviewed;
      await pump(tester, GraduationState(isLoading: false, outcome: outcome));
      final timestamp = strings.evaluatedAt(
        formatTimestamp(outcome.result.evaluatedAtMs),
      );
      expect(find.text(timestamp), findsNothing);
      await tester.ensureVisible(find.text(strings.portalEvaluationBasis));
      await tester.tap(find.text(strings.portalEvaluationBasis));
      await tester.pumpAndSettle();
      expect(find.text(timestamp), findsOneWidget);
    },
  );
  for (final branch in [
    'diagnostic',
    'unsupported',
    'error',
    'mismatch',
    'empty',
  ]) {
    testWidgets('$branch never renders a stale conclusion', (tester) async {
      final strings = await loadStrings();
      final outcome = switch (branch) {
        'diagnostic' => const GraduationCannotAudit('Chưa thể xét mẫu'),
        'unsupported' => const GraduationUnsupported(99),
        _ => null,
      };
      final message = branch == 'error'
          ? 'Lỗi mẫu'
          : branch == 'mismatch'
          ? 'graduation-context-mismatch'
          : null;
      await pump(
        tester,
        GraduationState(
          isLoading: false,
          outcome: outcome,
          errorMessage: message,
        ),
      );
      expect(find.byType(ConclusionBanner), findsNothing);
      expect(find.byType(CreditProgressCard), findsNothing);
      expect(
        find.text(switch (branch) {
          'diagnostic' => 'Chưa thể xét mẫu',
          'unsupported' => strings.unsupportedResultVersion,
          'error' => 'Lỗi mẫu',
          'mismatch' => 'graduation-context-mismatch',
          _ => strings.noData,
        }),
        findsOneWidget,
      );
      if (branch == 'error' || branch == 'diagnostic' || branch == 'mismatch') {
        when(() => cubit.load()).thenAnswer((_) async {});
        await tester.tap(find.text(strings.retry));
        verify(() => cubit.load()).called(1);
      }
    });
  }
  testWidgets(
    'compact totals and long shortfall remain readable at large text',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        GraduationState(
          isLoading: false,
          outcome: graduationSample(await loadStrings()),
        ),
        scale: portalLargeTextScale,
      );
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -portalTestHeight),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'credit breakdown action opens the existing ordinary Progress route',
    (tester) async {
      final strings = await loadStrings();
      cubit = MockGraduationCubit();
      whenListen(
        cubit,
        const Stream<GraduationState>.empty(),
        initialState: GraduationState(
          isLoading: false,
          outcome: graduationSample(strings),
        ),
      );
      final contextCubit = MockPortalContextCubit();
      whenListen(
        contextCubit,
        const Stream<PortalContextState>.empty(),
        initialState: portalContextStateSample(),
      );
      final router = GoRouter(
        initialLocation: RoutePaths.graduation,
        routes: [
          GoRoute(
            path: RoutePaths.graduation,
            builder: (_, _) => BlocProvider<GraduationCubit>.value(
              value: cubit,
              child: const GraduationScreen(),
            ),
          ),
          GoRoute(
            path: RoutePaths.progress,
            builder: (_, _) => const Text('Progress destination'),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        portalHarness(
          contextCubit: contextCubit,
          router: router,
          child: const SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(strings.portalCreditBreakdown));
      await tester.tap(find.text(strings.portalCreditBreakdown));
      await tester.pumpAndSettle();
      expect(find.text('Progress destination'), findsOneWidget);
    },
  );
}
