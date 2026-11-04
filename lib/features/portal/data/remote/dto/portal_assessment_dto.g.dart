// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_assessment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalAssessmentDto _$PortalAssessmentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalAssessmentDto', json, ($checkedConvert) {
      final val = PortalAssessmentDto(
        componentCode: $checkedConvert('componentCode', (v) => v as String),
        componentName: $checkedConvert('componentName', (v) => v as String),
        weight: $checkedConvert('weight', (v) => v as String),
        assessmentForm: $checkedConvert('assessmentForm', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PortalAssessmentDtoToJson(
  PortalAssessmentDto instance,
) => <String, dynamic>{
  'componentCode': instance.componentCode,
  'componentName': instance.componentName,
  'weight': instance.weight,
  'assessmentForm': instance.assessmentForm,
};
