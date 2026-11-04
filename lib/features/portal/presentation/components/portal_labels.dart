import 'package:flutter/material.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../common/theme/app_colors.dart';
import '../../domain/model/course_state.dart';
import '../../domain/model/enrollment_type.dart';
import '../../domain/model/eligibility.dart';
import '../../domain/model/graduation_conclusion.dart';
import '../../domain/model/material_kind.dart';
import '../../domain/model/result_status.dart';
import '../../domain/model/shortfall_category.dart';
import '../../domain/model/student_status.dart';

extension CourseStatePresentation on CourseState {
  ({String label, Color color}) tag(AppLocalizations strings) => switch (this) {
    CourseState.passed => (
      label: strings.statePassed,
      color: AppColors.statePassed,
    ),
    CourseState.passedEquivalent => (
      label: strings.statePassedEquivalent,
      color: AppColors.statePassed,
    ),
    CourseState.inProgress => (
      label: strings.stateInProgress,
      color: AppColors.stateInProgress,
    ),
    CourseState.failed => (
      label: strings.stateFailed,
      color: AppColors.stateFailed,
    ),
    CourseState.notTaken => (
      label: strings.stateNotTaken,
      color: AppColors.stateNeutral,
    ),
  };
}

extension StudentStatusPresentation on StudentStatus {
  String label(AppLocalizations strings) => switch (this) {
    StudentStatus.studying => strings.studentStudying,
    StudentStatus.onLeave => strings.studentOnLeave,
    StudentStatus.withdrawn => strings.studentWithdrawn,
    StudentStatus.graduated => strings.studentGraduated,
  };
}

extension EnrollmentPresentation on EnrollmentType {
  String label(AppLocalizations strings) => switch (this) {
    EnrollmentType.primary => strings.primaryMajor,
    EnrollmentType.secondMajor => strings.secondMajor,
  };
}

extension MaterialPresentation on MaterialKind {
  String label(AppLocalizations strings) => switch (this) {
    MaterialKind.signedSyllabus => strings.signedSyllabus,
    MaterialKind.textbook => strings.textbook,
    MaterialKind.lectureSlides => strings.lectureSlides,
    MaterialKind.other => strings.otherMaterial,
  };
}

extension ResultPresentation on ResultStatus {
  ({String label, Color color}) tag(AppLocalizations strings) => switch (this) {
    ResultStatus.passed => (
      label: strings.statePassed,
      color: AppColors.statePassed,
    ),
    ResultStatus.failed => (
      label: strings.stateFailed,
      color: AppColors.stateFailed,
    ),
    ResultStatus.inProgress => (
      label: strings.stateInProgress,
      color: AppColors.stateInProgress,
    ),
    ResultStatus.exempt => (
      label: strings.stateExempt,
      color: AppColors.statePassed,
    ),
  };
}

extension EligibilityPresentation on Eligibility {
  ({String label, Color color}) tag(AppLocalizations strings) => switch (this) {
    Eligibility.eligible => (
      label: strings.registrationEligible,
      color: AppColors.statePassed,
    ),
    Eligibility.conditional => (
      label: strings.conditional,
      color: AppColors.stateWarning,
    ),
    Eligibility.ineligible => (
      label: strings.registrationIneligible,
      color: AppColors.stateFailed,
    ),
  };
}

extension ConclusionPresentation on GraduationConclusion {
  ({String label, Color color}) tag(AppLocalizations strings) => switch (this) {
    GraduationConclusion.eligible => (
      label: strings.eligible,
      color: AppColors.statePassed,
    ),
    GraduationConclusion.notEligible => (
      label: strings.ineligible,
      color: AppColors.stateWarning,
    ),
  };
}

extension ShortfallPresentation on ShortfallCategory {
  String label(AppLocalizations strings) => switch (this) {
    ShortfallCategory.mandatoryCourse => strings.mandatoryCourses,
    ShortfallCategory.electiveGroup => strings.electiveGroups,
    ShortfallCategory.conditionalCourse => strings.conditionalCourses,
    ShortfallCategory.totalCredits => strings.totalCredits,
  };
}
