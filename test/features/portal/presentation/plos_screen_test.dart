import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/common/theme/app_dimens.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/plo.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_overview.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_program.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plo_description_tile.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/portal_widget_harness.dart';

void main() {
  String long(String word) => List.filled(16, word).join(' ');
  final items = [
    Plo(
      code: 'PLO1',
      description: long('première'),
      competencyGroup: 'Groupe B',
    ),
    Plo(
      code: 'PLO1',
      description: long('seconde'),
      competencyGroup: 'Groupe A',
    ),
    Plo(
      code: 'PLO3',
      description: long('troisième'),
      competencyGroup: 'Groupe B',
    ),
  ];
  late MockPlosCubit cubit;
  late MockPortalContextCubit contextCubit;
  Future<void> pump(
    WidgetTester tester,
    PlosState state, {
    Stream<PlosState> stream = const Stream<PlosState>.empty(),
    double scale = portalNormalTextScale,
  }) async {
    cubit = MockPlosCubit();
    whenListen(cubit, stream, initialState: state);
    contextCubit = MockPortalContextCubit();
    whenListen(
      contextCubit,
      const Stream<PortalContextState>.empty(),
      initialState: portalContextStateSample(),
    );
    await tester.pumpWidget(
      portalHarness(
        contextCubit: contextCubit,
        textScale: scale,
        child: BlocProvider<PlosCubit>.value(
          value: cubit,
          child: const PlosScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'first-seen groups and response order within groups remain stable',
    (tester) async {
      await pump(tester, PlosState(isLoading: false, items: items));
      final tiles = tester
          .widgetList<PloDescriptionTile>(find.byType(PloDescriptionTile))
          .toList();
      expect(tiles.map((tile) => tile.description), [
        items[0].description,
        items[2].description,
        items[1].description,
      ]);
      expect(
        tester.getTopLeft(find.text('Groupe B')).dy,
        lessThan(tester.getTopLeft(find.text('Groupe A')).dy),
      );
      final preview = tester.widget<Text>(find.text(items.first.description));
      expect(preview.maxLines, AppDimens.portalOutcomePreviewLines);
      expect(preview.overflow, TextOverflow.ellipsis);
      expect(find.textContaining('attainment'), findsNothing);
    },
  );
  testWidgets(
    'duplicate codes expand independently and collapse restores the preview',
    (tester) async {
      await pump(tester, PlosState(isLoading: false, items: items));
      final first = find.byType(PloDescriptionTile).first;
      final second = find.byType(PloDescriptionTile).at(2);
      await tester.tap(find.descendant(of: first, matching: find.text('PLO1')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(
              find.descendant(
                of: first,
                matching: find.text(items[0].description),
              ),
            )
            .maxLines,
        isNull,
      );
      expect(
        tester
            .widget<Text>(
              find.descendant(
                of: second,
                matching: find.text(items[1].description),
              ),
            )
            .maxLines,
        AppDimens.portalOutcomePreviewLines,
      );
      await tester.tap(find.descendant(of: first, matching: find.text('PLO1')));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(
              find.descendant(
                of: first,
                matching: find.text(items[0].description),
              ),
            )
            .maxLines,
        AppDimens.portalOutcomePreviewLines,
      );
    },
  );
  testWidgets(
    'same-context rebuild preserves expansion while changed context resets it',
    (tester) async {
      final stream = StreamController<PlosState>();
      addTearDown(stream.close);
      await pump(
        tester,
        PlosState(isLoading: false, items: items),
        stream: stream.stream,
      );
      await tester.tap(find.text('PLO1').first);
      await tester.pumpAndSettle();
      stream.add(PlosState(isLoading: false, items: items));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text(items.first.description)).maxLines,
        isNull,
      );
      final base = portalContextStateSample();
      final original = base.selectedProgram!;
      final replacement = PortalProgram(
        programId: 'another-program',
        programCode: original.programCode,
        programName: original.programName,
        enrollmentType: original.enrollmentType,
        versionNumber: original.versionNumber,
        decisionNumber: original.decisionNumber,
      );
      when(() => contextCubit.state).thenReturn(
        PortalContextState(
          isLoading: false,
          overview: PortalOverview(
            student: base.overview!.student,
            semester: base.overview!.semester,
            programs: [replacement],
          ),
          selectedProgramId: replacement.programId,
        ),
      );
      stream.add(PlosState(isLoading: false, items: items));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text(items.first.description)).maxLines,
        AppDimens.portalOutcomePreviewLines,
      );
    },
  );
  testWidgets('long outcome previews expand fully at narrow large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(
      const Size(portalTestWidth, portalTestHeight),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final description = List.filled(
      20,
      'Capacité détaillée à expliquer',
    ).join(' ');
    await pump(
      tester,
      PlosState(
        isLoading: false,
        items: [
          Plo(
            code: 'PLO-LONG',
            description: description,
            competencyGroup: null,
          ),
        ],
      ),
      scale: portalLargeTextScale,
    );
    expect(
      tester.widget<Text>(find.text(description)).maxLines,
      AppDimens.portalOutcomePreviewLines,
    );
    await tester.tap(find.text('PLO-LONG'));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text(description)).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
  testWidgets('outcomes within the preview show in full without expand', (
    tester,
  ) async {
    const short = 'Mô tả ngắn';
    await pump(
      tester,
      const PlosState(
        isLoading: false,
        items: [Plo(code: 'PLO1', description: short, competencyGroup: null)],
      ),
    );
    expect(
      find.descendant(
        of: find.byType(PloDescriptionTile),
        matching: find.byIcon(Icons.expand_more),
      ),
      findsNothing,
    );
    await tester.tap(find.text(short));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text(short)).maxLines,
      AppDimens.portalOutcomePreviewLines,
    );
  });
  for (final error in [false, true]) {
    testWidgets('PLO ${error ? 'error with retry' : 'empty'} stays distinct', (
      tester,
    ) async {
      await pump(
        tester,
        PlosState(isLoading: false, errorMessage: error ? 'Erreur PLO' : null),
      );
      expect(find.byType(PloDescriptionTile), findsNothing);
      final strings = await loadStrings();
      expect(find.text(error ? 'Erreur PLO' : strings.noPlos), findsOneWidget);
      if (error) {
        when(() => cubit.load()).thenAnswer((_) async {});
        await tester.tap(find.text(strings.retry));
        verify(() => cubit.load()).called(1);
      }
    });
  }
}
