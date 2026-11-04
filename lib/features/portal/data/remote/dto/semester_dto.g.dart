// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SemesterDto _$SemesterDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SemesterDto', json, ($checkedConvert) {
      final val = SemesterDto(
        id: $checkedConvert('id', (v) => v as String),
        semesterCode: $checkedConvert('semesterCode', (v) => v as String),
        academicYear: $checkedConvert('academicYear', (v) => v as String),
        termInYear: $checkedConvert('termInYear', (v) => (v as num).toInt()),
        startDate: $checkedConvert('startDate', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SemesterDtoToJson(SemesterDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'semesterCode': instance.semesterCode,
      'academicYear': instance.academicYear,
      'termInYear': instance.termInYear,
      'startDate': instance.startDate,
    };
