import 'package:json_annotation/json_annotation.dart';
import 'course_ref_dto.dart';

part 'eligibility_reason_dto.g.dart';

@JsonSerializable()
class EligibilityReasonDto {
  const EligibilityReasonDto({
    required this.message,
    this.code,
    this.evidenceCourse,
  });

  factory EligibilityReasonDto.fromJson(Map<String, dynamic> json) =>
      _$EligibilityReasonDtoFromJson(json);

  final String message;
  final String? code;
  final CourseRefDto? evidenceCourse;

  Map<String, dynamic> toJson() => _$EligibilityReasonDtoToJson(this);
}
