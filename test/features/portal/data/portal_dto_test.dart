import 'package:flutter/widgets.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/eligibility_item_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/academic_result_page_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/graduation_outcome_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_curriculum_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_me_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_plo_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/portal_syllabus_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/registration_eligibility_dto.dart';
import 'package:dut_curriculum_app/features/portal/data/remote/dto/semester_dto.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_state.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_outcome.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/material_kind.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/result_status.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../support/fixtures.dart';

void main() {
  group('equivalent completion evidence', () {
    Map<String, dynamic> itemJson(List<Map<String, dynamic>> reasons) => {
      'itemId': 'item',
      'course': {'id': 'course', 'courseCode': 'SYN', 'courseName': 'Mẫu'},
      'credits': '3.00',
      'catalogStatus': 'ACTIVE',
      'plannedSemester': 1,
      'completed': true,
      'eligibility': null,
      'statusText': 'Đã đạt',
      'reasons': reasons,
      'requiredConcurrentCourses': <Object>[],
    };
    final source = {
      'id': 'source',
      'courseCode': 'SRC',
      'courseName': 'Nguồn mẫu',
    };
    test(
      'first non-null matching equivalent identity survives mapping and equality',
      () {
        final json = itemJson([
          {'code': 'EQUIVALENT_COMPLETED', 'message': 'Thiếu nguồn'},
          {
            'code': 'EQUIVALENT_COMPLETED',
            'message': 'Công nhận',
            'evidenceCourse': source,
          },
        ]);
        final item = EligibilityItemDto.fromJson(json).toDomain();
        expect(item.equivalentCourse?.id, 'source');
        expect(item.reasons, ['Thiếu nguồn', 'Công nhận']);
        expect(item.requiredConcurrentCourses, isEmpty);
        expect(item, EligibilityItemDto.fromJson(json).toDomain());
        expect(
          item,
          isNot(EligibilityItemDto.fromJson(itemJson([])).toDomain()),
        );
      },
    );
    for (final code in [
      null,
      'COURSE_COMPLETED',
      'FUTURE_CODE',
      'EQUIVALENT_COMPLETED',
    ]) {
      test('optional absent or irrelevant evidence stays null for $code', () {
        final item = EligibilityItemDto.fromJson(
          itemJson([
            {
              'code': code,
              'message': 'Giữ nguyên',
              'evidenceCourse': code == 'EQUIVALENT_COMPLETED' ? null : source,
            },
          ]),
        ).toDomain();
        expect(item.equivalentCourse, isNull);
        expect(item.reasons, ['Giữ nguyên']);
      });
    }
  });
  late AppLocalizations strings;
  setUpAll(() async {
    strings = await AppLocalizations.delegate.load(const Locale('vi'));
  });

  test('semesters map date-only UTC epochs and preserve unstarted null', () {
    final semesters = (fixture('semesters') as List)
        .map(
          (json) =>
              SemesterDto.fromJson(json as Map<String, dynamic>).toDomain(),
        )
        .toList();
    expect(semesters.first.startDateMs, 1785542400000);
    expect(semesters.last.startDateMs, isNull);
    expect(semesters.first.code, '2026-1');
  });

  test('overview maps student, semester and nullable decision', () {
    final overview = PortalMeDto.fromJson(objectFixture('overview')).toDomain();
    expect(overview.student!.studentCode, 'SYN001');
    expect(overview.semester!.code, '2026-1');
    expect(overview.programs.single.versionNumber, '1.0');
    expect(overview.programs.single.decisionNumber, isNull);
    expect(() => overview.programs.clear(), throwsUnsupportedError);
  });

  test('unlinked overview does not invent a student', () {
    final overview = PortalMeDto.fromJson({
      'student': null,
      'semester': null,
      'programs': <Object>[],
    }).toDomain();
    expect(overview.student, isNull);
    expect(overview.semester, isNull);
    expect(overview.programs, isEmpty);
  });

  test('curriculum keeps decimal precision, states and attempts', () {
    final curriculum = PortalCurriculumDto.fromJson(
      objectFixture('curriculum'),
    ).toDomain();
    final course = curriculum.terms.single.courses.single;
    expect(curriculum.totalCredits, '120.00');
    expect(course.credits, '3.00');
    expect(course.score10, '7.50');
    expect(course.attemptCount, 2);
    expect(course.state, CourseState.inProgress);
    expect(course.groupName, isNull);
  });

  test('PLO retains null competency group', () {
    final json = (fixture('plos') as List).single as Map<String, dynamic>;
    final plo = PortalPloDto.fromJson(json).toDomain();
    expect(plo.code, 'PLO1');
    expect(plo.competencyGroup, isNull);
  });

  test('syllabus maps HTML, timestamp, sections and attachments', () {
    final syllabus = PortalSyllabusDto.fromJson(
      objectFixture('syllabus'),
    ).toDomain();
    expect(syllabus.publishedAtMs, 1785542400000);
    expect(syllabus.courseDescription, '<p>Mô tả mẫu</p>');
    expect(syllabus.objectives, isNull);
    expect(syllabus.clos.single.code, 'CLO1');
    expect(syllabus.weeks.single.label, '1');
    expect(syllabus.assessments.single.weight, '100.00');
    expect(syllabus.attachments.single.kind, MaterialKind.signedSyllabus);
    expect(syllabus.attachments.single.sizeBytes, 1024);
  });

  test('results preserve scores and paging metadata', () {
    final page = AcademicResultPageDto.fromJson(
      objectFixture('results'),
    ).toDomain();
    expect(page.total, 1);
    expect(page.pageSize, 50);
    expect(page.items.single.course.code, 'SYN101');
    expect(page.items.single.score4, '3.00');
    expect(page.items.single.status, ResultStatus.passed);
  });

  test('eligibility retains reasons, concurrency and completed records', () {
    final json = objectFixture('eligibility');
    final items = json['items'] as List;
    items.add({
      ...(items.first as Map<String, dynamic>),
      'completed': true,
      'eligibility': null,
    });
    final report = RegistrationEligibilityDto.fromJson(json).toDomain(strings);
    expect(report.evaluatedAtMs, 1785542400000);
    expect(report.items.first.eligibility, Eligibility.conditional);
    expect(report.items.first.reasons, ['Học cùng học phần mẫu']);
    expect(report.items.first.requiredConcurrentCourses.single.code, 'SYN101');
    expect(report.items.last.completed, isTrue);
    expect(report.items.last.eligibility, isNull);
    expect(report.warnings.single.course.code, 'SYN101');
  });

  test('unsupported eligibility contract throws explicit contract error', () {
    final json = objectFixture('eligibility')..['contractVersion'] = 2;
    expect(
      () => RegistrationEligibilityDto.fromJson(json).toDomain(strings),
      throwsA(isA<ContractException>()),
    );
  });

  test('graduation maps null requirements and localized shortfall', () {
    final outcome =
        GraduationOutcomeDto.fromJson(
              objectFixture('graduation'),
            ).toDomain(strings)
            as GraduationReviewed;
    expect(outcome.result.credits.missingTotal, '117.00');
    expect(outcome.result.shortfalls.single.title, strings.totalCreditsMissing);
    expect(outcome.result.electiveGroups.single.requiredCourses, isNull);
    expect(outcome.result.knowledgeBlocks.single.advisoryGap, isNull);
    expect(outcome.result.evaluatedAtMs, 1785542400000);
  });

  test('staff-facing warning codes never reach the student', () {
    final graduation = objectFixture('graduation');
    ((graduation['result'] as Map<String, dynamic>)['warnings'] as List).addAll(
      [
        {'code': 'UNKNOWN_KNOWLEDGE_BLOCK', 'message': 'Khối chưa xác định'},
        {
          'code': 'CURRENT_CATALOG_CREDIT_BASIS',
          'message': 'Danh mục hiện tại',
        },
      ],
    );
    final outcome =
        GraduationOutcomeDto.fromJson(graduation).toDomain(strings)
            as GraduationReviewed;
    expect(outcome.result.warnings.map((w) => w.code), [
      'EQUIVALENT_CREDIT_GAP',
    ]);

    final eligibility = objectFixture('eligibility');
    final warnings = eligibility['warnings'] as List;
    for (final code in [
      'REPLACEMENT_UNAVAILABLE',
      'EXTERNAL_REQUISITE',
      'EXTERNAL_COREQUISITE_RULES_UNAVAILABLE',
    ]) {
      warnings.add({...(warnings.first as Map<String, dynamic>), 'code': code});
    }
    final report = RegistrationEligibilityDto.fromJson(
      eligibility,
    ).toDomain(strings);
    expect(report.warnings, hasLength(1));
  });

  test('CANNOT_AUDIT preserves diagnostic verbatim', () {
    final outcome = GraduationOutcomeDto.fromJson({
      'status': 'CANNOT_AUDIT',
      'result': null,
      'error': {'message': 'Thiếu cấu hình khoa'},
    }).toDomain(strings);
    expect(outcome, const GraduationCannotAudit('Thiếu cấu hình khoa'));
  });

  test('future schema gates before current-schema decoding', () {
    final outcome = GraduationOutcomeDto.fromJson({
      'status': 'REVIEWED',
      'result': {'schemaVersion': 2},
      'error': null,
    }).toDomain(strings);
    expect(outcome, const GraduationUnsupported(2));
  });

  test('invalid exclusivity and unknown outcome status fail', () {
    for (final json in [
      {'status': 'REVIEWED', 'result': null, 'error': null},
      {
        'status': 'CANNOT_AUDIT',
        'result': <String, dynamic>{},
        'error': {'message': 'diagnostic'},
      },
      {'status': 'FUTURE', 'result': null, 'error': null},
    ]) {
      expect(
        () => GraduationOutcomeDto.fromJson(json).toDomain(strings),
        throwsA(isA<ContractException>()),
      );
    }
  });

  test('checked decoding rejects absent and mistyped required fields', () {
    expect(
      () => PortalCurriculumDto.fromJson({}),
      throwsA(isA<CheckedFromJsonException>()),
    );
    final json = objectFixture('curriculum')..['totalCredits'] = 120;
    expect(
      () => PortalCurriculumDto.fromJson(json),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });
}
