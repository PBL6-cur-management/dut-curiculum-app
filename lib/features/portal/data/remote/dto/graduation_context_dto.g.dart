// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_context_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationContextDto _$GraduationContextDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationContextDto', json, ($checkedConvert) {
  final val = GraduationContextDto(
    programCode: $checkedConvert('programCode', (v) => v as String),
    programName: $checkedConvert('programName', (v) => v as String),
    cohortCode: $checkedConvert('cohortCode', (v) => v as String),
    versionNumber: $checkedConvert('versionNumber', (v) => v as String),
    semesterCode: $checkedConvert('semesterCode', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$GraduationContextDtoToJson(
  GraduationContextDto instance,
) => <String, dynamic>{
  'programCode': instance.programCode,
  'programName': instance.programName,
  'cohortCode': instance.cohortCode,
  'versionNumber': instance.versionNumber,
  'semesterCode': instance.semesterCode,
};
