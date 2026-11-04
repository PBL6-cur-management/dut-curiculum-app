import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/common/routes/route_paths.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/portal_menu_list.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_bar.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/overview/portal_overview_screen.dart';

import '../../../support/domain_samples.dart';
import '../../../support/portal_widget_harness.dart';

void main() {
  final paths = [
    RoutePaths.curriculumProgram,
    RoutePaths.plos,
    RoutePaths.progress,
    RoutePaths.registration,
    RoutePaths.graduation,
  ];
  for (final destination in paths) {
    testWidgets('launcher opens $destination on real router', (tester) async {
      final cubit = MockPortalContextCubit();
      whenListen(
        cubit,
        const Stream<PortalContextState>.empty(),
        initialState: portalContextStateSample(),
      );
      final router = GoRouter(
        initialLocation: RoutePaths.curriculum,
        routes: [
          GoRoute(
            path: RoutePaths.home,
            builder: (_, _) => const Text('Accueil'),
          ),
          GoRoute(
            path: RoutePaths.curriculum,
            builder: (_, _) => const PortalOverviewScreen(),
          ),
          for (final path in paths)
            GoRoute(path: path, builder: (_, _) => Text(path)),
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
      final menu = tester.widget<PortalMenuList>(find.byType(PortalMenuList));
      expect(menu.items.length, 5);
      expect(find.byType(PortalContextBar), findsOneWidget);
      final label = menu.items[paths.indexOf(destination)].label;
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text(destination), findsOneWidget);
    });
  }
  testWidgets('missing context hides all destinations but retains Home back', (
    tester,
  ) async {
    final cubit = MockPortalContextCubit();
    whenListen(
      cubit,
      const Stream<PortalContextState>.empty(),
      initialState: const PortalContextState(isLoading: false),
    );
    final router = GoRouter(
      initialLocation: RoutePaths.curriculum,
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (_, _) => const Text('Accueil'),
        ),
        GoRoute(
          path: RoutePaths.curriculum,
          builder: (_, _) => const PortalOverviewScreen(),
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
    expect(find.byType(PortalMenuList), findsNothing);
    expect(find.text((await loadStrings()).noStudentLinked), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Accueil'), findsOneWidget);
  });
  testWidgets('entry exposes version without duplicate identity or selectors', (
    tester,
  ) async {
    final state = portalContextStateSample();
    final cubit = MockPortalContextCubit();
    whenListen(
      cubit,
      const Stream<PortalContextState>.empty(),
      initialState: state,
    );
    await tester.pumpWidget(
      portalHarness(contextCubit: cubit, child: const PortalOverviewScreen()),
    );
    final strings = await loadStrings();
    expect(
      find.text(
        strings.fieldValue(
          strings.version,
          state.selectedProgram!.versionNumber!,
        ),
      ),
      findsOneWidget,
    );
    expect(find.byType(DropdownButton<String>), findsNothing);
    expect(find.text(state.overview!.student!.studentCode), findsNothing);
  });
}
