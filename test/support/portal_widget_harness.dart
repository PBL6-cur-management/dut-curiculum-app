import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_state.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import 'domain_samples.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_state.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_cubit.dart';
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_state.dart';

const portalTestWidth = 360.0;
const portalTestHeight = 900.0;
const portalLargeTextScale = 2.0;
const portalNormalTextScale = 1.0;

class MockPortalContextCubit extends MockCubit<PortalContextState>
    implements PortalContextCubit {}

class MockCurriculumCubit extends MockCubit<CurriculumState>
    implements CurriculumCubit {}

class MockSyllabusCubit extends MockCubit<SyllabusState>
    implements SyllabusCubit {}

class MockPlosCubit extends MockCubit<PlosState> implements PlosCubit {}

class MockProgressCubit extends MockCubit<ProgressState>
    implements ProgressCubit {}

class MockRegistrationCubit extends MockCubit<RegistrationState>
    implements RegistrationCubit {}

class MockGraduationCubit extends MockCubit<GraduationState>
    implements GraduationCubit {}

PortalContextState portalContextStateSample() {
  final overview = overviewSample();
  return PortalContextState(
    isLoading: false,
    semesters: semestersSample(),
    overview: overview,
    selectedProgramId: overview.programs.first.programId,
  );
}

Widget portalHarness({
  required PortalContextCubit contextCubit,
  required Widget child,
  GoRouter? router,
  double textScale = portalNormalTextScale,
}) {
  Widget provide(BuildContext context, Widget? body) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: BlocProvider.value(value: contextCubit, child: body!),
  );
  if (router != null) {
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: provide,
    );
  }
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: provide,
    home: child,
  );
}
