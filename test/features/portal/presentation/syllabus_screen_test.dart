import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_syllabus_dto.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/assessment_table.dart';
import 'package:dut_curriculum_app/features/portal/presentation/components/attachment_tile.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_screen.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_state.dart';

import '../../../support/domain_samples.dart';
import '../../../support/fixtures.dart';
import '../../../support/portal_widget_harness.dart';

void main() {
  late MockSyllabusCubit cubit;
  Future<void> pump(
    WidgetTester tester,
    SyllabusState state, {
    double scale = portalNormalTextScale,
  }) async {
    await tester.binding.setSurfaceSize(
      const Size(portalTestWidth, portalTestHeight),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
    cubit = MockSyllabusCubit();
    whenListen(cubit, const Stream<SyllabusState>.empty(), initialState: state);
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
        child: BlocProvider<SyllabusCubit>.value(
          value: cubit,
          child: const SyllabusScreen(),
        ),
      ),
    );
  }

  testWidgets(
    'assessment leads and supplied excluded narratives never render',
    (tester) async {
      final json = objectFixture('syllabus')
        ..addAll({
          'assessmentMethods': '<p>Évaluation détaillée</p>',
          'objectives': '<p>OBJECTIF EXCLU</p>',
          'teachingMethods': '<p>MÉTHODE EXCLUE</p>',
          'references': '<p>RÉFÉRENCE EXCLUE</p>',
        });
      final data = PortalSyllabusDto.fromJson(json).toDomain();
      await pump(tester, SyllabusState(isLoading: false, data: data));
      final strings = await loadStrings();
      expect(find.byType(AssessmentTable), findsOneWidget);
      expect(find.byType(DataTable), findsNothing);
      expect(find.text(strings.percentValue('100,00')), findsOneWidget);
      expect(find.text('Évaluation détaillée'), findsNothing);
      expect(
        tester.getTopLeft(find.text(strings.assessment)).dy,
        lessThan(tester.getTopLeft(find.text(strings.assessmentMethods)).dy),
      );
      await tester.tap(find.text(strings.assessmentMethods));
      await tester.pumpAndSettle();
      expect(find.text('Évaluation détaillée'), findsOneWidget);
      await tester.tap(find.text(strings.assessmentMethods).first);
      await tester.pumpAndSettle();
      expect(find.text('Évaluation détaillée'), findsNothing);
      for (final excluded in [
        'OBJECTIF EXCLU',
        'MÉTHODE EXCLUE',
        'RÉFÉRENCE EXCLUE',
      ]) {
        expect(find.text(excluded), findsNothing);
      }
      await tester.ensureVisible(find.text(strings.attachments));
      await tester.tap(find.text(strings.attachments));
      await tester.pumpAndSettle();
      expect(find.byType(AttachmentTile), findsOneWidget);
      expect(find.textContaining('KB'), findsNothing);
      expect(find.textContaining('1024'), findsNothing);
    },
  );
  for (final section in ['clos', 'weeks', 'documents']) {
    testWidgets('$section opens empty localized content in one tap', (
      tester,
    ) async {
      final json = objectFixture('syllabus')
        ..['clos'] = <Object>[]
        ..['weeks'] = <Object>[]
        ..['attachments'] = <Object>[]
        ..['assessments'] = <Object>[];
      await pump(
        tester,
        SyllabusState(
          isLoading: false,
          data: PortalSyllabusDto.fromJson(json).toDomain(),
        ),
      );
      final strings = await loadStrings();
      final heading = switch (section) {
        'clos' => strings.clos,
        'weeks' => strings.weeklyPlan,
        _ => strings.attachments,
      };
      await tester.ensureVisible(find.text(heading));
      await tester.tap(find.text(heading));
      await tester.pumpAndSettle();
      expect(find.text(strings.noData), findsWidgets);
      expect(find.text(strings.portalAssessmentNotice), findsOneWidget);
    });
  }
  testWidgets(
    'download failure and in-flight progress preserve readable assessment',
    (tester) async {
      final data = syllabusSample();
      await pump(
        tester,
        SyllabusState(
          isLoading: false,
          data: data,
          openingAttachmentId: data.attachments.first.id,
          downloadProgress: 0.5,
          errorMessage: 'Échec du document',
        ),
      );
      final strings = await loadStrings();
      await tester.ensureVisible(find.text(strings.attachments));
      await tester.tap(find.text(strings.attachments));
      await tester.pumpAndSettle();
      final tile = tester.widget<AttachmentTile>(find.byType(AttachmentTile));
      expect(tile.isDownloading, isTrue);
      expect(tile.onOpen, isNull);
      expect(tile.progress, 0.5);
      expect(find.text('Échec du document'), findsOneWidget);
      expect(find.byType(AssessmentTable), findsOneWidget);
    },
  );
  testWidgets(
    'long assessment names and forms wrap vertically at large text with pinned revision',
    (tester) async {
      final json = objectFixture('syllabus');
      final name = List.filled(8, 'Évaluation du projet détaillée').join(' ');
      final form = List.filled(8, 'Présentation et discussion').join(' ');
      (json['assessments'] as List).first['componentName'] = name;
      (json['assessments'] as List).first['assessmentForm'] = form;
      await pump(
        tester,
        SyllabusState(
          isLoading: false,
          data: PortalSyllabusDto.fromJson(json).toDomain(),
        ),
        scale: portalLargeTextScale,
      );
      expect(find.text((await loadStrings()).revision(1)), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(form),
        portalTestHeight / 2,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('FINAL · $name'), findsOneWidget);
      expect(find.byType(DataTable), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('initial request failure retries rather than looping a loader', (
    tester,
  ) async {
    await pump(
      tester,
      const SyllabusState(isLoading: false, errorMessage: 'Échec initial'),
    );
    when(() => cubit.load()).thenAnswer((_) async {});
    expect(find.byType(AssessmentTable), findsNothing);
    await tester.tap(find.text((await loadStrings()).retry));
    verify(() => cubit.load()).called(1);
  });
}
