// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_student_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalStudentDto _$PortalStudentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalStudentDto', json, ($checkedConvert) {
      final val = PortalStudentDto(
        id: $checkedConvert('id', (v) => v as String),
        studentCode: $checkedConvert('studentCode', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        cohortCode: $checkedConvert('cohortCode', (v) => v as String),
        major: $checkedConvert('major', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PortalStudentDtoToJson(PortalStudentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentCode': instance.studentCode,
      'fullName': instance.fullName,
      'cohortCode': instance.cohortCode,
      'major': instance.major,
      'status': instance.status,
    };
