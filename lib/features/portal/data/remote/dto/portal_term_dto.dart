import '../../../domain/model/curriculum_term.dart';
import 'package:json_annotation/json_annotation.dart';
import 'portal_course_dto.dart';

part 'portal_term_dto.g.dart';

@JsonSerializable()
class PortalTermDto {
  const PortalTermDto({
    required this.plannedSemester,
    required this.credits,
    required this.courses,
  });

  factory PortalTermDto.fromJson(Map<String, dynamic> json) =>
      _$PortalTermDtoFromJson(json);

  final int plannedSemester;
  final String credits;
  final List<PortalCourseDto> courses;

  Map<String, dynamic> toJson() => _$PortalTermDtoToJson(this);

  CurriculumTerm toDomain() => CurriculumTerm(
    plannedSemester: plannedSemester,
    credits: credits,
    courses: List.unmodifiable(courses.map((item) => item.toDomain())),
  );
}
