import '../../../domain/model/catalog_status.dart';
import '../../../domain/model/course_ref.dart';
import '../../../domain/model/eligibility.dart';
import '../../../domain/model/eligibility_item.dart';
import 'course_ref_dto.dart';
import 'eligibility_reason_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eligibility_item_dto.g.dart';

@JsonSerializable()
class EligibilityItemDto {
  const EligibilityItemDto({
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
  });

  factory EligibilityItemDto.fromJson(Map<String, dynamic> json) =>
      _$EligibilityItemDtoFromJson(json);

  final String itemId;
  final CourseRefDto course;
  final String credits;
  final String catalogStatus;
  final int plannedSemester;
  final bool completed;
  final String? eligibility;
  final String statusText;
  final List<EligibilityReasonDto> reasons;
  final List<CourseRefDto> requiredConcurrentCourses;

  Map<String, dynamic> toJson() => _$EligibilityItemDtoToJson(this);

  CourseRef? get equivalentCourse => reasons
      .where((reason) => reason.code == 'EQUIVALENT_COMPLETED')
      .map((reason) => reason.evidenceCourse?.toDomain())
      .whereType<CourseRef>()
      .firstOrNull;

  EligibilityItem toDomain() => EligibilityItem(
    itemId: itemId,
    course: course.toDomain(),
    credits: credits,
    catalogStatus: CatalogStatus.parse(catalogStatus),
    plannedSemester: plannedSemester,
    completed: completed,
    eligibility: eligibility == null ? null : Eligibility.parse(eligibility!),
    statusText: statusText,
    equivalentCourse: equivalentCourse,
    reasons: List.unmodifiable(reasons.map((item) => item.message)),
    requiredConcurrentCourses: List.unmodifiable(
      requiredConcurrentCourses.map((item) => item.toDomain()),
    ),
  );
}
