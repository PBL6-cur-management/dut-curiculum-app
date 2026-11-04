import 'package:flutter_test/flutter_test.dart';
import 'package:dut_curriculum_app/core/network/contract_exception.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/catalog_status.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/course_state.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/eligibility.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/enrollment_type.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/graduation_conclusion.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/material_kind.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/result_status.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/shortfall_category.dart';
import 'package:dut_curriculum_app/features/portal/domain/model/student_status.dart';

void checkEnum<T>(String name, T Function(String) parse, Map<String, T> cases) {
  group(name, () {
    for (final entry in cases.entries) {
      test(entry.key, () => expect(parse(entry.key), entry.value));
    }
    for (final invalid in ['UNKNOWN', '', 'passed']) {
      test('rejects $invalid without fallback', () {
        expect(() => parse(invalid), throwsA(isA<ContractException>()));
      });
    }
  });
}

void main() {
  checkEnum('course', CourseState.parse, {
    'PASSED': CourseState.passed,
    'PASSED_EQUIVALENT': CourseState.passedEquivalent,
    'IN_PROGRESS': CourseState.inProgress,
    'FAILED': CourseState.failed,
    'NOT_TAKEN': CourseState.notTaken,
  });
  checkEnum('student', StudentStatus.parse, {
    'STUDYING': StudentStatus.studying,
    'ON_LEAVE': StudentStatus.onLeave,
    'WITHDRAWN': StudentStatus.withdrawn,
    'GRADUATED': StudentStatus.graduated,
  });
  checkEnum('enrollment', EnrollmentType.parse, {
    'PRIMARY': EnrollmentType.primary,
    'SECOND_MAJOR': EnrollmentType.secondMajor,
  });
  checkEnum('material', MaterialKind.parse, {
    'SIGNED_SYLLABUS': MaterialKind.signedSyllabus,
    'TEXTBOOK': MaterialKind.textbook,
    'LECTURE_SLIDES': MaterialKind.lectureSlides,
    'OTHER': MaterialKind.other,
  });
  checkEnum('result', ResultStatus.parse, {
    'PASSED': ResultStatus.passed,
    'FAILED': ResultStatus.failed,
    'IN_PROGRESS': ResultStatus.inProgress,
    'EXEMPT': ResultStatus.exempt,
  });
  checkEnum('eligibility', Eligibility.parse, {
    'ELIGIBLE': Eligibility.eligible,
    'CONDITIONAL': Eligibility.conditional,
    'INELIGIBLE': Eligibility.ineligible,
  });
  checkEnum('catalog', CatalogStatus.parse, {
    'ACTIVE': CatalogStatus.active,
    'DISCONTINUED': CatalogStatus.discontinued,
    'CANCELLED': CatalogStatus.cancelled,
  });
  checkEnum('conclusion', GraduationConclusion.parse, {
    'ELIGIBLE': GraduationConclusion.eligible,
    'NOT_ELIGIBLE': GraduationConclusion.notEligible,
  });
  checkEnum('shortfall', ShortfallCategory.parse, {
    'MANDATORY_COURSE': ShortfallCategory.mandatoryCourse,
    'ELECTIVE_GROUP': ShortfallCategory.electiveGroup,
    'CONDITIONAL_COURSE': ShortfallCategory.conditionalCourse,
    'TOTAL_CREDITS': ShortfallCategory.totalCredits,
  });
}
