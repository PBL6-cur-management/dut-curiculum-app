// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_program_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalProgramDto _$PortalProgramDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalProgramDto', json, ($checkedConvert) {
      final val = PortalProgramDto(
        programId: $checkedConvert('programId', (v) => v as String),
        programCode: $checkedConvert('programCode', (v) => v as String),
        programName: $checkedConvert('programName', (v) => v as String),
        enrollmentType: $checkedConvert('enrollmentType', (v) => v as String),
        versionNumber: $checkedConvert('versionNumber', (v) => v as String?),
        decisionNumber: $checkedConvert('decisionNumber', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PortalProgramDtoToJson(PortalProgramDto instance) =>
    <String, dynamic>{
      'programId': instance.programId,
      'programCode': instance.programCode,
      'programName': instance.programName,
      'enrollmentType': instance.enrollmentType,
      'versionNumber': instance.versionNumber,
      'decisionNumber': instance.decisionNumber,
    };
