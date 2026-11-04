import 'package:flutter/widgets.dart';
import 'package:dut_curriculum_app/features/auth/data/remote/dto/me_dto.dart';
import 'package:dut_curriculum_app/features/auth/domain/model/session_user.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/academic_result_page_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/graduation_outcome_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_curriculum_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_me_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_plo_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_syllabus_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/registration_eligibility_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/semester_dto.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/curriculum.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility_report.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/plo.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/portal_overview.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/result_page.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/semester.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/syllabus.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import 'fixtures.dart';

Future<AppLocalizations> loadStrings() =>
    AppLocalizations.delegate.load(const Locale('vi'));

SessionUser sessionUser({bool mustChangePassword = false}) => MeDto.fromJson(
  objectFixture('auth_me'),
).toDomain().copyWith(mustChangePassword: mustChangePassword);

PortalOverview overviewSample() =>
    PortalMeDto.fromJson(objectFixture('overview')).toDomain();

List<Semester> semestersSample() => [
  for (final json in fixture('semesters') as List)
    SemesterDto.fromJson(json as Map<String, dynamic>).toDomain(),
];

Curriculum curriculumSample() =>
    PortalCurriculumDto.fromJson(objectFixture('curriculum')).toDomain();

List<Plo> plosSample() => [
  for (final json in fixture('plos') as List)
    PortalPloDto.fromJson(json as Map<String, dynamic>).toDomain(),
];

Syllabus syllabusSample() =>
    PortalSyllabusDto.fromJson(objectFixture('syllabus')).toDomain();

ResultPage resultsSample() =>
    AcademicResultPageDto.fromJson(objectFixture('results')).toDomain();

EligibilityReport eligibilitySample(AppLocalizations strings) =>
    RegistrationEligibilityDto.fromJson(
      objectFixture('eligibility'),
    ).toDomain(strings);

GraduationOutcome graduationSample(AppLocalizations strings) =>
    GraduationOutcomeDto.fromJson(
      objectFixture('graduation'),
    ).toDomain(strings);
