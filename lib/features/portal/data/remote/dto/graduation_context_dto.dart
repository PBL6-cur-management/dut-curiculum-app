import 'package:json_annotation/json_annotation.dart';

part 'graduation_context_dto.g.dart';

@JsonSerializable()
class GraduationContextDto {
  const GraduationContextDto({
    required this.programCode,
    required this.programName,
    required this.cohortCode,
    required this.versionNumber,
    required this.semesterCode,
  });

  factory GraduationContextDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationContextDtoFromJson(json);

  final String programCode;
  final String programName;
  final String cohortCode;
  final String versionNumber;
  final String semesterCode;

  Map<String, dynamic> toJson() => _$GraduationContextDtoToJson(this);
}
