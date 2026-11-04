import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_state.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/curriculum_course.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/course_row.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_bar.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/course_details_panel.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';

import '../../../support/portal_widget_harness.dart';
import '../../../support/domain_samples.dart';
import 'curriculum_cubit_test.dart' show course, term, curriculumOf;

void main() {
  CurriculumCourse elective(String id, String? group, {bool syllabus = true}) =>
      CurriculumCourse(
        itemId: id,
        courseCode: id,
        courseName: 'Học phần $id',
        credits: '3.00',
        isElective: true,
        groupName: group,
        blockSymbol: null,
        state: CourseState.inProgress,
        attemptCount: 0,
        score10: null,
        score4: null,
        letterGrade: null,
        hasSyllabus: syllabus,
      );
  late MockCurriculumCubit cubit;
  Future<void> pump(
    WidgetTester tester,
    CurriculumState state, {
    double scale = portalNormalTextScale,
  }) async {
    cubit = MockCurriculumCubit();
    whenListen(
      cubit,
      const Stream<CurriculumState>.empty(),
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
        child: BlocProvider<CurriculumCubit>.value(
          value: cubit,
          child: const CurriculumScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'in-progress term starts expanded with independent syllabus and details actions',
    (tester) async {
      final data = curriculumSample();
      await pump(tester, CurriculumState(isLoading: false, data: data));
      expect(find.byType(PortalContextBar), findsOneWidget);
      expect(find.byType(CourseRow), findsOneWidget);
      final row = tester.widget<CourseRow>(find.byType(CourseRow));
      expect(row.course.itemId, data.terms.single.courses.single.itemId);
      expect(row.onDetails, isNotNull);
      expect(row.onSyllabus != null, row.course.hasSyllabus);
      expect(
        find.text(data.decisionNumber ?? 'invisible decision'),
        findsNothing,
      );
    },
  );
  testWidgets(
    'unnamed electives have only individual elective cues and unavailable syllabus',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        CurriculumState(
          isLoading: false,
          data: curriculumOf([
            term(1, [
              elective('UNNAMED', null, syllabus: false),
              elective('BLANK', '  '),
            ]),
          ]),
        ),
      );
      final strings = await loadStrings();
      expect(find.byType(CourseRow), findsNWidgets(2));
      expect(find.text(strings.elective), findsNWidgets(2));
      expect(find.text(strings.portalChooseWithinGroup), findsNothing);
      expect(find.text(strings.portalNoIssuedSyllabus), findsOneWidget);
      final unavailable = tester.widget<CourseRow>(
        find.byKey(const ValueKey('UNNAMED')),
      );
      expect(unavailable.onSyllabus, isNull);
      expect(unavailable.onDetails, isNotNull);
    },
  );
  testWidgets(
    'named elective groups retain first-seen order and supplied membership',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        CurriculumState(
          isLoading: false,
          data: curriculumOf([
            term(1, [
              elective('B1', 'Groupe B'),
              elective('A1', 'Groupe A'),
              elective('B2', 'Groupe B'),
            ]),
          ]),
        ),
      );
      expect(
        tester.getTopLeft(find.text('Groupe B')).dy,
        lessThan(tester.getTopLeft(find.text('Groupe A')).dy),
      );
      expect(
        tester
            .widgetList<CourseRow>(find.byType(CourseRow))
            .map((row) => row.course.itemId),
        ['B1', 'B2', 'A1'],
      );
      expect(
        find.text((await loadStrings()).portalChooseWithinGroup),
        findsNWidgets(2),
      );
    },
  );
  testWidgets('empty filter offers clear without hiding curriculum frame', (
    tester,
  ) async {
    final data = curriculumOf([
      term(1, [course('A', CourseState.passed)]),
    ]);
    await pump(
      tester,
      CurriculumState(isLoading: false, data: data, filter: CourseState.failed),
    );
    final strings = await loadStrings();
    expect(find.text(strings.portalNoFilterMatches), findsOneWidget);
    await tester.tap(find.text(strings.portalClearFilter));
    verify(() => cubit.setFilter(null)).called(1);
  });
  testWidgets('null scores stay unknown and evidence failure offers retry', (
    tester,
  ) async {
    final equivalent = course('EQ', CourseState.passedEquivalent);
    await pump(
      tester,
      CurriculumState(
        isLoading: false,
        data: curriculumOf([
          term(1, [equivalent]),
        ]),
        equivalentError: 'offline',
      ),
    );
    await tester.tap(find.text((await loadStrings()).semesterNumber(1)));
    await tester.pumpAndSettle();
    when(
      () => cubit.loadEquivalentCourses(force: false),
    ).thenAnswer((_) async {});
    when(
      () => cubit.loadEquivalentCourses(force: true),
    ).thenAnswer((_) async {});
    await tester.tap(find.text((await loadStrings()).statePassedEquivalent));
    await tester.pumpAndSettle();
    final strings = await loadStrings();
    expect(find.byType(CourseDetailsPanel), findsOneWidget);
    expect(find.text(strings.portalEquivalentUnavailable), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(CourseDetailsPanel),
        matching: find.text(strings.emptyValue),
      ),
      findsNWidgets(3),
    );
    await tester.ensureVisible(find.text(strings.retry));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.retry));
    verify(() => cubit.loadEquivalentCourses(force: true)).called(1);
  });
  testWidgets('request failure is inline and retry reloads curriculum', (
    tester,
  ) async {
    await pump(
      tester,
      const CurriculumState(isLoading: false, errorMessage: 'Lỗi mẫu'),
    );
    when(() => cubit.load()).thenAnswer((_) async {});
    expect(find.byType(CourseRow), findsNothing);
    await tester.tap(find.text((await loadStrings()).retry));
    verify(() => cubit.load()).called(1);
  });
  testWidgets(
    'empty curriculum is distinct from filtered empty at large scale',
    (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pump(
        tester,
        CurriculumState(isLoading: false, data: curriculumOf([])),
        scale: portalLargeTextScale,
      );
      final strings = await loadStrings();
      expect(find.text(strings.portalNoTerms), findsOneWidget);
      expect(find.text(strings.portalClearFilter), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
