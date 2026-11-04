import '../../../domain/model/syllabus_assessment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_assessment_dto.g.dart';

@JsonSerializable()
class PortalAssessmentDto {
  const PortalAssessmentDto({
    required this.componentCode,
    required this.componentName,
    required this.weight,
    required this.assessmentForm,
  });

  factory PortalAssessmentDto.fromJson(Map<String, dynamic> json) =>
      _$PortalAssessmentDtoFromJson(json);

  final String componentCode;
  final String componentName;
  final String weight;
  final String? assessmentForm;

  Map<String, dynamic> toJson() => _$PortalAssessmentDtoToJson(this);

  SyllabusAssessment toDomain() => SyllabusAssessment(
    code: componentCode,
    name: componentName,
    weight: weight,
    form: assessmentForm,
  );
}
