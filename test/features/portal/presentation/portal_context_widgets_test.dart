import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/common/routes/app_router.dart';
import 'package:dut_curriculum_app/common/routes/go_router_refresh_stream.dart';
import 'package:dut_curriculum_app/common/routes/route_paths.dart';
import 'package:dut_curriculum_app/core/di/getit_utils.dart';
import 'package:dut_curriculum_app/core/session/session_events.dart';
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_context.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/semester.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_semester_ref.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_cubit.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_overview.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_program.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/portal_page.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_bar.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_sheet.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_route.dart';

import '../../../support/domain_samples.dart';
import '../../../support/portal_widget_harness.dart';
import '../../../support/test_doubles.dart';

void main() {
  final base = portalContextStateSample();
  group('real router context ownership', () {
    late MockPortalUseCases service;
    late SessionEvents events;
    late SessionCubit session;
    late PortalContextCubit contextCubit;
    late PortalOverview overview;
    late PortalProgram alternate;
    late GoRouter router;
    late GoRouterRefreshStream refresh;
    final created = <BlocBase<dynamic>>[];
    final requested = <PortalContext>[];
    final futureSemester = Semester(
      id: 'future',
      code: '2030-1',
      academicYear: '2030-2031',
      termInYear: 1,
      startDateMs: DateTime.utc(2030).millisecondsSinceEpoch,
    );

    setUpAll(() => registerFallbackValue(portalContext));
    setUp(() async {
      final strings = await loadStrings();
      service = MockPortalUseCases();
      final auth = MockAuthUseCases();
      events = SessionEvents();
      session = SessionCubit(auth, events);
      when(() => auth.currentUser()).thenAnswer((_) async => sessionUser());
      await session.restore();
      final first = base.selectedProgram!;
      alternate = PortalProgram(
        programId: 'alternate',
        programCode: 'ALT',
        programName: 'Chương trình thay thế',
        enrollmentType: first.enrollmentType,
        versionNumber: '2.0',
        decisionNumber: null,
      );
      overview = PortalOverview(
        student: base.overview!.student,
        semester: base.overview!.semester,
        programs: [first, alternate],
      );
      when(
        () => service.startedSemesters(),
      ).thenAnswer((_) async => [...base.semesters, futureSemester]);
      when(() => service.overview()).thenAnswer((_) async => overview);
      when(
        () => service.overview(semesterId: any(named: 'semesterId')),
      ).thenAnswer((_) async => overview);
      when(() => service.curriculum(any())).thenAnswer((call) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return curriculumSample();
      });
      when(() => service.syllabus(any(), any())).thenAnswer((call) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return syllabusSample();
      });
      when(() => service.plos(any())).thenAnswer((call) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return plosSample();
      });
      when(() => service.results(any(), page: any(named: 'page'))).thenAnswer((
        call,
      ) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return resultsSample();
      });
      when(() => service.eligibility(any())).thenAnswer((call) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return eligibilitySample(strings);
      });
      when(() => service.graduation(any())).thenAnswer((call) async {
        requested.add(call.positionalArguments.first as PortalContext);
        return graduationSample(strings);
      });
      contextCubit = PortalContextCubit(service);
      getIt.registerFactory<PortalContextCubit>(() => contextCubit);
      getIt.registerFactoryParam<CurriculumCubit, PortalContext, void>((
        context,
        _,
      ) {
        final cubit = CurriculumCubit(service, context);
        created.add(cubit);
        return cubit;
      });
      getIt.registerFactoryParam<SyllabusCubit, PortalContext, String>((
        context,
        item,
      ) {
        final cubit = SyllabusCubit(
          service,
          MockAttachmentViewer(),
          context,
          item,
        );
        created.add(cubit);
        return cubit;
      });
      getIt.registerFactoryParam<PlosCubit, PortalContext, void>((context, _) {
        final cubit = PlosCubit(service, context);
        created.add(cubit);
        return cubit;
      });
      getIt.registerFactoryParam<ProgressCubit, PortalContext, void>((
        context,
        _,
      ) {
        final cubit = ProgressCubit(service, context);
        created.add(cubit);
        return cubit;
      });
      getIt.registerFactoryParam<RegistrationCubit, PortalContext, void>((
        context,
        _,
      ) {
        final cubit = RegistrationCubit(service, context);
        created.add(cubit);
        return cubit;
      });
      getIt.registerFactoryParam<GraduationCubit, PortalContext, void>((
        context,
        _,
      ) {
        final cubit = GraduationCubit(service, context);
        created.add(cubit);
        return cubit;
      });
      refresh = GoRouterRefreshStream(session.stream);
      router = buildRouter(session, refresh: refresh);
    });
    tearDown(() async {
      router.dispose();
      refresh.dispose();
      await getIt.reset();
      await session.close();
      await events.dispose();
      created.clear();
      requested.clear();
    });
    Future<void> pumpApp(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(
        const Size(portalTestWidth, portalTestHeight),
      );
      addTearDown(() => tester.binding.setSurfaceSize(null));
      router.go(RoutePaths.curriculum);
      await tester.pumpWidget(
        BlocProvider.value(
          value: session,
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('vi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'seven destinations share one context owner and reads use that context',
      (tester) async {
        await pumpApp(tester);
        final context = contextCubit.state.context!;
        for (final path in [
          RoutePaths.curriculum,
          RoutePaths.curriculumProgram,
          RoutePaths.syllabusFor('item-1'),
          RoutePaths.plos,
          RoutePaths.progress,
          RoutePaths.registration,
          RoutePaths.graduation,
        ]) {
          router.go(path);
          await tester.pumpAndSettle();
          expect(find.byType(PortalContextBar), findsOneWidget);
          expect(
            tester
                .element(find.byType(PortalContextBar))
                .read<PortalContextCubit>(),
            same(contextCubit),
          );
          expect(contextCubit.state.context, context);
          expect(tester.takeException(), isNull);
        }
        expect(requested, isNotEmpty);
        expect(requested.every((value) => value == context), isTrue);
        verify(() => service.startedSemesters()).called(1);
        verify(() => service.overview()).called(1);
      },
    );
    testWidgets(
      'every keyed academic route disposes its old provider on programme change',
      (tester) async {
        await pumpApp(tester);
        for (final path in [
          RoutePaths.curriculumProgram,
          RoutePaths.plos,
          RoutePaths.progress,
          RoutePaths.registration,
          RoutePaths.graduation,
          RoutePaths.syllabusFor('item-1'),
        ]) {
          router.go(path);
          await tester.pumpAndSettle();
          final old = created.last;
          final target =
              contextCubit.state.selectedProgramId == alternate.programId
              ? overview.programs.first
              : alternate;
          await tester.tap(find.byType(PortalContextBar));
          await tester.pumpAndSettle();
          await tester.tap(find.text(target.programName).last);
          await tester.pumpAndSettle();
          expect(contextCubit.state.selectedProgramId, target.programId);
          expect(old.isClosed, isTrue, reason: path);
          expect(requested.last.programId, target.programId);
          expect(find.byType(PortalContextSheet), findsNothing);
          if (path == RoutePaths.syllabusFor('item-1')) {
            expect(
              router.routeInformationProvider.value.uri.path,
              RoutePaths.curriculumProgram,
            );
          }
        }
      },
    );
    testWidgets(
      'future semester selection suppresses old answer and stale rapid response',
      (tester) async {
        await pumpApp(tester);
        router.go(RoutePaths.plos);
        await tester.pumpAndSettle();
        final old = created.last;
        final lateFuture = Completer<PortalOverview>();
        final latest = Completer<PortalOverview>();
        when(
          () => service.overview(semesterId: futureSemester.id),
        ).thenAnswer((_) => lateFuture.future);
        when(
          () => service.overview(semesterId: 'latest'),
        ).thenAnswer((_) => latest.future);
        await tester.tap(find.byType(PortalContextBar));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(futureSemester.code));
        await tester.tap(find.text(futureSemester.code));
        await tester.pump();
        expect(contextCubit.state.isLoading, isTrue);
        await tester.pump(const Duration(milliseconds: 500));
        expect(old.isClosed, isTrue);
        expect(find.byType(PortalContextBar), findsOneWidget);
        expect(find.text(plosSample().first.description), findsNothing);
        final next = contextCubit.selectSemester('latest');
        latest.complete(
          PortalOverview(
            student: overview.student,
            semester: PortalSemesterRef(
              id: futureSemester.id,
              code: futureSemester.code,
            ),
            programs: [alternate, overview.programs.first],
          ),
        );
        await next;
        await tester.pumpAndSettle();
        lateFuture.complete(overview);
        await tester.pumpAndSettle();
        expect(contextCubit.state.overview!.semester?.id, futureSemester.id);
        expect(contextCubit.state.selectedProgramId, alternate.programId);
        expect(requested.last.semesterId, futureSemester.id);
        expect(find.text(base.overview!.semester!.code), findsNothing);
      },
    );
    testWidgets(
      'a curriculum read error does not leak into PLO or graduation reads',
      (tester) async {
        when(
          () => service.curriculum(any()),
        ).thenThrow(StateError('isolated-read-error'));
        await pumpApp(tester);
        router.go(RoutePaths.curriculumProgram);
        await tester.pumpAndSettle();
        expect(find.textContaining('isolated-read-error'), findsOneWidget);
        for (final path in [RoutePaths.plos, RoutePaths.graduation]) {
          router.go(path);
          await tester.pumpAndSettle();
          expect(find.textContaining('isolated-read-error'), findsNothing);
          expect(find.byType(PortalContextBar), findsOneWidget);
        }
      },
    );
  });
  testWidgets(
    'one initial summary includes applied version and no student identity',
    (tester) async {
      final cubit = MockPortalContextCubit();
      whenListen(
        cubit,
        const Stream<PortalContextState>.empty(),
        initialState: base,
      );
      await tester.pumpWidget(
        portalHarness(
          contextCubit: cubit,
          child: PortalRoute(
            builder: (_, _) =>
                const PortalPage(title: 'Mẫu', body: Text('Nội dung')),
          ),
        ),
      );
      final strings = await loadStrings();
      expect(find.byType(PortalContextBar), findsOneWidget);
      expect(
        find.text(
          strings.fieldValue(
            strings.version,
            base.selectedProgram!.versionNumber!,
          ),
        ),
        findsOneWidget,
      );
      expect(find.text(base.overview!.student!.studentCode), findsNothing);
      await tester.tap(find.byType(PortalContextBar));
      await tester.pumpAndSettle();
      expect(find.byType(PortalContextSheet), findsOneWidget);
      await tester.tap(
        find.byTooltip(
          MaterialLocalizations.of(
            tester.element(find.byType(PortalContextSheet)),
          ).closeButtonTooltip,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PortalContextSheet), findsNothing);
    },
  );
  for (final gate in [
    'loading',
    'error',
    'student',
    'semester',
    'dated-options',
    'program',
  ]) {
    testWidgets('ordered $gate gate suppresses academic answer', (
      tester,
    ) async {
      final strings = await loadStrings();
      final state = switch (gate) {
        'loading' => const PortalContextState(),
        'error' => const PortalContextState(
          isLoading: false,
          errorMessage: 'Lỗi mẫu',
        ),
        'student' => const PortalContextState(
          isLoading: false,
          overview: PortalOverview(student: null, semester: null, programs: []),
        ),
        'semester' => PortalContextState(
          isLoading: false,
          overview: PortalOverview(
            student: base.overview!.student,
            semester: null,
            programs: [],
          ),
        ),
        'dated-options' => PortalContextState(
          isLoading: false,
          overview: base.overview,
          selectedProgramId: base.selectedProgramId,
        ),
        _ => PortalContextState(
          isLoading: false,
          semesters: base.semesters,
          overview: PortalOverview(
            student: base.overview!.student,
            semester: base.overview!.semester,
            programs: [],
          ),
        ),
      };
      final cubit = MockPortalContextCubit();
      whenListen(
        cubit,
        const Stream<PortalContextState>.empty(),
        initialState: state,
      );
      await tester.pumpWidget(
        portalHarness(
          contextCubit: cubit,
          child: PortalRoute(
            builder: (_, _) => const Text('Réponse interdite'),
          ),
        ),
      );
      expect(find.text('Réponse interdite'), findsNothing);
      if (gate != 'loading') {
        expect(
          find.text(switch (gate) {
            'error' => 'Lỗi mẫu',
            'student' => strings.noStudentLinked,
            'semester' || 'dated-options' => strings.portalMissingSemester,
            _ => strings.portalNoApplicableProgram,
          }),
          findsOneWidget,
        );
      }
    });
  }
  testWidgets(
    'missing version is visible and selecting current programme only dismisses',
    (tester) async {
      final original = base.selectedProgram!;
      final program = PortalProgram(
        programId: original.programId,
        programCode: original.programCode,
        programName: original.programName,
        enrollmentType: original.enrollmentType,
        versionNumber: null,
        decisionNumber: null,
      );
      final state = PortalContextState(
        isLoading: false,
        semesters: base.semesters,
        overview: PortalOverview(
          student: base.overview!.student,
          semester: base.overview!.semester,
          programs: [program],
        ),
        selectedProgramId: program.programId,
      );
      final cubit = MockPortalContextCubit();
      whenListen(
        cubit,
        const Stream<PortalContextState>.empty(),
        initialState: state,
      );
      await tester.pumpWidget(
        portalHarness(
          contextCubit: cubit,
          child: const PortalPage(title: 'Mẫu', body: SizedBox.shrink()),
        ),
      );
      expect(find.text((await loadStrings()).noVersion), findsOneWidget);
      await tester.tap(find.byType(PortalContextBar));
      await tester.pumpAndSettle();
      await tester.tap(find.text(program.programName).last);
      await tester.pumpAndSettle();
      verifyNever(() => cubit.selectProgram(any()));
      expect(find.byType(PortalContextSheet), findsNothing);
    },
  );
  testWidgets(
    'context request error retries the shared owner without constructing an answer',
    (tester) async {
      final cubit = MockPortalContextCubit();
      whenListen(
        cubit,
        const Stream<PortalContextState>.empty(),
        initialState: const PortalContextState(
          isLoading: false,
          errorMessage: 'Erreur contexte',
        ),
      );
      when(() => cubit.load()).thenAnswer((_) async {});
      await tester.pumpWidget(
        portalHarness(
          contextCubit: cubit,
          child: PortalRoute(
            builder: (_, _) => const Text('Réponse interdite'),
          ),
        ),
      );
      await tester.tap(find.text((await loadStrings()).retry));
      verify(() => cubit.load()).called(1);
      expect(find.text('Réponse interdite'), findsNothing);
      verifyNever(() => cubit.close());
    },
  );
  testWidgets('long programme and applied version wrap at narrow large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(
      const Size(portalTestWidth, portalTestHeight),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final original = base.selectedProgram!;
    final program = PortalProgram(
      programId: original.programId,
      programCode: original.programCode,
      programName: List.filled(3, 'Chương trình có tên dài').join(' '),
      enrollmentType: original.enrollmentType,
      versionNumber: original.versionNumber,
      decisionNumber: original.decisionNumber,
    );
    final cubit = MockPortalContextCubit();
    whenListen(
      cubit,
      const Stream<PortalContextState>.empty(),
      initialState: PortalContextState(
        isLoading: false,
        semesters: base.semesters,
        selectedProgramId: program.programId,
        overview: PortalOverview(
          student: base.overview!.student,
          semester: base.overview!.semester,
          programs: [program],
        ),
      ),
    );
    await tester.pumpWidget(
      portalHarness(
        contextCubit: cubit,
        textScale: portalLargeTextScale,
        child: const PortalPage(title: 'Mẫu', body: SizedBox.shrink()),
      ),
    );
    expect(find.text(program.programName), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'context reload replaces keyed child and hides old answers before response',
    (tester) async {
      final stream = StreamController<PortalContextState>();
      addTearDown(stream.close);
      final cubit = MockPortalContextCubit();
      whenListen(cubit, stream.stream, initialState: base);
      await tester.pumpWidget(
        portalHarness(
          contextCubit: cubit,
          child: PortalRoute(
            builder: (portal, _) => PortalPage(
              key: ValueKey(portal),
              title: 'Mẫu',
              body: const Text('Réponse courante'),
            ),
          ),
        ),
      );
      expect(find.text('Réponse courante'), findsOneWidget);
      stream.add(PortalContextState(semesters: base.semesters));
      await tester.pump();
      expect(find.text('Réponse courante'), findsNothing);
      stream.add(base);
      await tester.pumpAndSettle();
      expect(find.text('Réponse courante'), findsOneWidget);
    },
  );
  testWidgets('deep link gate back resolves to area entry', (tester) async {
    final cubit = MockPortalContextCubit();
    whenListen(
      cubit,
      const Stream<PortalContextState>.empty(),
      initialState: const PortalContextState(isLoading: false),
    );
    final router = GoRouter(
      initialLocation: '/curriculum/program',
      routes: [
        GoRoute(path: '/curriculum', builder: (_, _) => const Text('Entrée')),
        GoRoute(
          path: '/curriculum/program',
          builder: (_, _) =>
              PortalRoute(builder: (_, _) => const Text('Réponse interdite')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      portalHarness(
        contextCubit: cubit,
        router: router,
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Entrée'), findsOneWidget);
  });
}
