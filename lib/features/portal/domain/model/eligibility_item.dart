import 'package:equatable/equatable.dart';
import 'catalog_status.dart';
import 'course_ref.dart';
import 'eligibility.dart';

class EligibilityItem extends Equatable {
  const EligibilityItem({
    required this.itemId,
    required this.course,
    required this.credits,
    required this.catalogStatus,
    required this.plannedSemester,
    required this.completed,
    required this.eligibility,
    required this.statusText,
    required this.reasons,
    required this.requiredConcurrentCourses,
    this.equivalentCourse,
  });

  final String itemId;
  final CourseRef course;
  final String credits;
  final CatalogStatus catalogStatus;
  final int plannedSemester;
  final bool completed;
  final Eligibility? eligibility;
  final String statusText;
  final List<String> reasons;
  final List<CourseRef> requiredConcurrentCourses;
  final CourseRef? equivalentCourse;

  @override
  List<Object?> get props => [
    itemId,
    course,
    credits,
    catalogStatus,
    plannedSemester,
    completed,
    eligibility,
    statusText,
    reasons,
    requiredConcurrentCourses,
    equivalentCourse,
  ];
}
