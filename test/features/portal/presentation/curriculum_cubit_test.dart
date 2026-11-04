import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/catalog_status.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_ref.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_item.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_state.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/curriculum.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/curriculum_course.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/curriculum_term.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

CurriculumCourse course(String id, CourseState state) => CurriculumCourse(
  itemId: id,
  courseCode: id,
  courseName: 'Học phần $id',
  credits: '3.00',
  isElective: false,
  groupName: null,
  blockSymbol: null,
  state: state,
  attemptCount: 1,
  score10: null,
  score4: null,
  letterGrade: null,
  hasSyllabus: true,
);

CurriculumTerm term(int number, List<CurriculumCourse> courses) =>
    CurriculumTerm(plannedSemester: number, credits: '3.00', courses: courses);

Curriculum curriculumOf(List<CurriculumTerm> terms) => Curriculum(
  programName: 'Chương trình mẫu',
  versionNumber: '1.0',
  decisionNumber: null,
  totalCredits: '120.00',
  terms: terms,
);

void main() {
  group('optional equivalent evidence', () {
    const source = CourseRef(
      id: 'source',
      code: 'SRC',
      name: 'Học phần nguồn mẫu',
    );
    EligibilityReport report({bool evidence = true}) => EligibilityReport(
      evaluatedAtMs: 0,
      warnings: const [],
      items: [
        EligibilityItem(
          itemId: 'EQ',
          course: source,
          credits: '3.00',
          catalogStatus: CatalogStatus.active,
          plannedSemester: 1,
          completed: true,
          eligibility: null,
          statusText: 'Đã đạt',
          reasons: const [],
          requiredConcurrentCourses: const [],
          equivalentCourse: evidence ? source : null,
        ),
        const EligibilityItem(
          itemId: 'NOT_EQ',
          course: source,
          credits: '3.00',
          catalogStatus: CatalogStatus.active,
          plannedSemester: 1,
          completed: true,
          eligibility: null,
          statusText: 'Đã đạt',
          reasons: [],
          requiredConcurrentCourses: [],
          equivalentCourse: source,
        ),
      ],
    );
    late MockPortalUseCases service;
    late CurriculumCubit cubit;
    setUp(() {
      service = MockPortalUseCases();
      when(() => service.curriculum(portalContext)).thenAnswer(
        (_) async => curriculumOf([
          term(1, [
            course('EQ', CourseState.passedEquivalent),
            course('NOT_EQ', CourseState.passed),
          ]),
        ]),
      );
      cubit = CurriculumCubit(service, portalContext);
    });
    tearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    test('ordinary load never requests optional evidence', () async {
      await cubit.load();
      verifyNever(() => service.eligibility(portalContext));
      expect(cubit.state.equivalentLoaded, isFalse);
    });
    test(
      'success caches source by equivalent item only and preserves filter',
      () async {
        when(
          () => service.eligibility(portalContext),
        ).thenAnswer((_) async => report());
        await cubit.load();
        cubit.setFilter(CourseState.passed);
        await cubit.loadEquivalentCourses();
        expect(cubit.state.equivalentCourses, {'EQ': source});
        expect(cubit.state.equivalentLoaded, isTrue);
        expect(cubit.state.filter, CourseState.passed);
        cubit.setFilter(null);
        expect(cubit.state.equivalentCourses, {'EQ': source});
        await cubit.loadEquivalentCourses();
        verify(() => service.eligibility(portalContext)).called(1);
        expect(
          () => cubit.state.equivalentCourses.clear(),
          throwsUnsupportedError,
        );
      },
    );
    test('successful absence is cached without repeated requests', () async {
      when(
        () => service.eligibility(portalContext),
      ).thenAnswer((_) async => report(evidence: false));
      await cubit.load();
      await cubit.loadEquivalentCourses();
      await cubit.loadEquivalentCourses();
      expect(cubit.state.equivalentCourses, isEmpty);
      expect(cubit.state.equivalentLoaded, isTrue);
      verify(() => service.eligibility(portalContext)).called(1);
    });
    test(
      'failure keeps curriculum and filter, explicit retry succeeds',
      () async {
        when(
          () => service.eligibility(portalContext),
        ).thenThrow(Exception('offline'));
        await cubit.load();
        final data = cubit.state.data;
        cubit.setFilter(CourseState.passed);
        await cubit.loadEquivalentCourses();
        expect(cubit.state.data, same(data));
        expect(cubit.state.filter, CourseState.passed);
        expect(cubit.state.equivalentError, contains('offline'));
        expect(cubit.state.errorMessage, isNull);
        when(
          () => service.eligibility(portalContext),
        ).thenAnswer((_) async => report());
        await cubit.loadEquivalentCourses(force: true);
        expect(cubit.state.equivalentError, isNull);
        expect(cubit.state.equivalentCourses, {'EQ': source});
      },
    );
    test(
      'duplicate requests are coalesced and reload invalidates late evidence',
      () async {
        final pending = Completer<EligibilityReport>();
        when(
          () => service.eligibility(portalContext),
        ).thenAnswer((_) => pending.future);
        await cubit.load();
        final request = cubit.loadEquivalentCourses();
        await cubit.loadEquivalentCourses();
        verify(() => service.eligibility(portalContext)).called(1);
        await cubit.load();
        pending.complete(report());
        await request;
        expect(cubit.state.equivalentCourses, isEmpty);
        expect(cubit.state.equivalentLoaded, isFalse);
      },
    );
    test('close suppresses a late optional response', () async {
      final pending = Completer<EligibilityReport>();
      when(
        () => service.eligibility(portalContext),
      ).thenAnswer((_) => pending.future);
      await cubit.load();
      final request = cubit.loadEquivalentCourses();
      await cubit.close();
      pending.complete(report());
      await request;
      expect(cubit.state.equivalentCourses, isEmpty);
    });
  });
  late MockPortalUseCases portal;
  setUp(() => portal = MockPortalUseCases());

  group('load', () {
    final data = curriculumSample();

    blocTest<CurriculumCubit, CurriculumState>(
      'success replaces the loading state with the curriculum',
      build: () {
        when(
          () => portal.curriculum(portalContext),
        ).thenAnswer((_) async => data);
        return CurriculumCubit(portal, portalContext);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const CurriculumState(),
        CurriculumState(isLoading: false, data: data),
      ],
    );

    blocTest<CurriculumCubit, CurriculumState>(
      'failure carries the thrown message',
      build: () {
        when(() => portal.curriculum(portalContext)).thenThrow(
          const ApiException(
            statusCode: 404,
            code: 'X',
            message: 'Không có chương trình',
          ),
        );
        return CurriculumCubit(portal, portalContext);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const CurriculumState(),
        const CurriculumState(
          isLoading: false,
          errorMessage: 'Không có chương trình',
        ),
      ],
    );
  });

  group('state filter', () {
    final data = curriculumOf([
      term(1, [
        course('A', CourseState.passed),
        course('B', CourseState.passedEquivalent),
      ]),
      term(2, [
        course('C', CourseState.inProgress),
        course('D', CourseState.failed),
      ]),
      term(3, [course('E', CourseState.notTaken)]),
    ]);

    CurriculumState filtered(CourseState? filter) =>
        CurriculumState(isLoading: false, data: data, filter: filter);

    test('no filter shows every term and course', () {
      expect(filtered(null).terms, data.terms);
    });

    test('passed filter also keeps equivalent-passed courses', () {
      final terms = filtered(CourseState.passed).terms;
      expect(terms.map((t) => t.plannedSemester), [1]);
      expect(terms.single.courses.map((c) => c.itemId), ['A', 'B']);
    });

    test('other filters drop terms without a match and keep the rest', () {
      final terms = filtered(CourseState.failed).terms;
      expect(terms.map((t) => t.plannedSemester), [2]);
      expect(terms.single.courses.map((c) => c.itemId), ['D']);
    });

    test('a filter with no matches leaves no terms', () {
      final empty = CurriculumState(
        isLoading: false,
        data: curriculumOf([
          term(1, [course('A', CourseState.passed)]),
        ]),
        filter: CourseState.failed,
      );
      expect(empty.terms, isEmpty);
    });

    blocTest<CurriculumCubit, CurriculumState>(
      'setFilter keeps the loaded data',
      build: () => CurriculumCubit(portal, portalContext),
      seed: () => CurriculumState(isLoading: false, data: data),
      act: (cubit) => cubit.setFilter(CourseState.failed),
      expect: () => [filtered(CourseState.failed)],
    );

    blocTest<CurriculumCubit, CurriculumState>(
      'setFilter(null) clears the filter',
      build: () => CurriculumCubit(portal, portalContext),
      seed: () => filtered(CourseState.failed),
      act: (cubit) => cubit.setFilter(null),
      expect: () => [filtered(null)],
    );
  });

  group('expandedTerms', () {
    Set<int> expanded(List<CurriculumTerm> terms) => CurriculumState(
      isLoading: false,
      data: curriculumOf(terms),
    ).expandedTerms;

    test(
      'expands the in-progress term and the next one with unstarted work',
      () {
        expect(
          expanded([
            term(1, [course('A', CourseState.passed)]),
            term(2, [course('B', CourseState.inProgress)]),
            term(3, [course('C', CourseState.notTaken)]),
            term(4, [course('D', CourseState.notTaken)]),
          ]),
          {2, 3},
        );
      },
    );

    test(
      'with nothing in progress it expands the first unstarted term only',
      () {
        expect(
          expanded([
            term(1, [course('A', CourseState.passed)]),
            term(2, [course('B', CourseState.notTaken)]),
            term(3, [course('C', CourseState.notTaken)]),
          ]),
          {2},
        );
      },
    );

    test('a fully passed curriculum expands nothing', () {
      expect(
        expanded([
          term(1, [course('A', CourseState.passed)]),
        ]),
        isEmpty,
      );
    });

    test('unstarted terms before the in-progress term are not expanded', () {
      expect(
        expanded([
          term(1, [course('A', CourseState.notTaken)]),
          term(2, [course('B', CourseState.inProgress)]),
        ]),
        {2},
      );
    });
  });
}
