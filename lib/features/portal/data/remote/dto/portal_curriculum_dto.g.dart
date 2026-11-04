// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_curriculum_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalCurriculumDto _$PortalCurriculumDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalCurriculumDto', json, ($checkedConvert) {
      final val = PortalCurriculumDto(
        programName: $checkedConvert('programName', (v) => v as String),
        versionNumber: $checkedConvert('versionNumber', (v) => v as String?),
        decisionNumber: $checkedConvert('decisionNumber', (v) => v as String?),
        totalCredits: $checkedConvert('totalCredits', (v) => v as String),
        terms: $checkedConvert(
          'terms',
          (v) => (v as List<dynamic>)
              .map((e) => PortalTermDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PortalCurriculumDtoToJson(
  PortalCurriculumDto instance,
) => <String, dynamic>{
  'programName': instance.programName,
  'versionNumber': instance.versionNumber,
  'decisionNumber': instance.decisionNumber,
  'totalCredits': instance.totalCredits,
  'terms': instance.terms.map((e) => e.toJson()).toList(),
};
