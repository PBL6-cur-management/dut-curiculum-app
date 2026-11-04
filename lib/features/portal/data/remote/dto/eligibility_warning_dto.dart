import '../../../domain/model/eligibility_warning.dart';
import 'course_ref_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eligibility_warning_dto.g.dart';

@JsonSerializable()
class EligibilityWarningDto {
  const EligibilityWarningDto({
    required this.code,
    required this.message,
    required this.course,
  });

  factory EligibilityWarningDto.fromJson(Map<String, dynamic> json) =>
      _$EligibilityWarningDtoFromJson(json);

  final String code;
  final String message;
  final CourseRefDto course;

  Map<String, dynamic> toJson() => _$EligibilityWarningDtoToJson(this);

  EligibilityWarning toDomain() =>
      EligibilityWarning(message: message, course: course.toDomain());
}
