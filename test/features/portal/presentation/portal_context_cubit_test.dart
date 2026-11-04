import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/core/network/api_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/enrollment_type.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_overview.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_program.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_context.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/test_doubles.dart';

void main() {
  late MockPortalUseCases portal;
  final semesters = semestersSample();
  final overview = overviewSample();
  const secondProgram = PortalProgram(
    programId: 'program-2',
    programCode: 'SYN2',
    programName: 'Chương trình thứ hai',
    enrollmentType: EnrollmentType.secondMajor,
    versionNumber: null,
    decisionNumber: null,
  );
  final twoPrograms = PortalOverview(
    student: overview.student,
    semester: overview.semester,
    programs: [secondProgram, ...overview.programs],
  );

  setUp(() => portal = MockPortalUseCases());

  PortalContextState loaded(PortalOverview value, {String? program}) =>
      PortalContextState(
        isLoading: false,
        semesters: semesters,
        overview: value,
        selectedProgramId: program ?? value.programs.first.programId,
      );

  blocTest<PortalContextCubit, PortalContextState>(
    'load selects the first program and exposes a complete context',
    build: () {
      when(() => portal.startedSemesters()).thenAnswer((_) async => semesters);
      when(() => portal.overview()).thenAnswer((_) async => overview);
      return PortalContextCubit(portal);
    },
    act: (cubit) => cubit.load(),
    expect: () => [const PortalContextState(), loaded(overview)],
    verify: (cubit) => expect(cubit.state.context, portalContext),
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'an unlinked account loads but has no context',
    build: () {
      when(() => portal.startedSemesters()).thenAnswer((_) async => semesters);
      when(() => portal.overview()).thenAnswer(
        (_) async =>
            const PortalOverview(student: null, semester: null, programs: []),
      );
      return PortalContextCubit(portal);
    },
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.context, isNull);
    },
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'a student with a semester but no program has no context',
    build: () {
      when(() => portal.startedSemesters()).thenAnswer((_) async => semesters);
      when(() => portal.overview()).thenAnswer(
        (_) async => PortalOverview(
          student: overview.student,
          semester: overview.semester,
          programs: const [],
        ),
      );
      return PortalContextCubit(portal);
    },
    act: (cubit) => cubit.load(),
    verify: (cubit) => expect(cubit.state.context, isNull),
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'load failure surfaces the overview error message',
    build: () {
      when(() => portal.startedSemesters()).thenAnswer((_) async => semesters);
      when(() => portal.overview()).thenThrow(
        const ApiException(
          statusCode: 500,
          code: 'HTTP',
          message: 'Lỗi tổng quan',
        ),
      );
      return PortalContextCubit(portal);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const PortalContextState(),
      const PortalContextState(isLoading: false, errorMessage: 'Lỗi tổng quan'),
    ],
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'a failing semester list is not hidden by a successful overview',
    build: () {
      when(() => portal.startedSemesters()).thenThrow(
        const ApiException(
          statusCode: 500,
          code: 'HTTP',
          message: 'Lỗi học kỳ',
        ),
      );
      when(() => portal.overview()).thenAnswer((_) async => overview);
      return PortalContextCubit(portal);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const PortalContextState(),
      const PortalContextState(isLoading: false, errorMessage: 'Lỗi học kỳ'),
    ],
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'changing semester refetches and resets the program to the first one',
    build: () {
      when(
        () => portal.overview(semesterId: 'semester-9'),
      ).thenAnswer((_) async => twoPrograms);
      return PortalContextCubit(portal);
    },
    seed: () => loaded(twoPrograms, program: 'program-1'),
    act: (cubit) => cubit.selectSemester('semester-9'),
    expect: () => [
      PortalContextState(semesters: semesters),
      loaded(twoPrograms, program: 'program-2'),
    ],
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'semester change failure keeps the semester list and reports the message',
    build: () {
      when(
        () => portal.overview(semesterId: any(named: 'semesterId')),
      ).thenThrow(
        const ApiException(
          statusCode: 500,
          code: 'HTTP',
          message: 'Không đổi được',
        ),
      );
      return PortalContextCubit(portal);
    },
    seed: () => loaded(overview),
    act: (cubit) => cubit.selectSemester('semester-9'),
    expect: () => [
      PortalContextState(semesters: semesters),
      PortalContextState(
        isLoading: false,
        semesters: semesters,
        errorMessage: 'Không đổi được',
      ),
    ],
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'selecting the second major changes the context program',
    build: () => PortalContextCubit(portal),
    seed: () => loaded(twoPrograms, program: 'program-2'),
    act: (cubit) => cubit.selectProgram('program-1'),
    expect: () => [loaded(twoPrograms, program: 'program-1')],
    verify: (cubit) => expect(
      cubit.state.context,
      const PortalContext(
        studentId: 'student-1',
        programId: 'program-1',
        semesterId: 'semester-1',
      ),
    ),
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'selecting an unknown program keeps the old selection and reports',
    build: () => PortalContextCubit(portal),
    seed: () => loaded(overview),
    act: (cubit) => cubit.selectProgram('missing'),
    verify: (cubit) {
      expect(cubit.state.selectedProgramId, 'program-1');
      expect(cubit.state.errorMessage, isNotNull);
    },
  );

  blocTest<PortalContextCubit, PortalContextState>(
    'selectProgram is ignored before the overview has loaded',
    build: () => PortalContextCubit(portal),
    act: (cubit) => cubit.selectProgram('program-1'),
    expect: () => <PortalContextState>[],
  );
}
