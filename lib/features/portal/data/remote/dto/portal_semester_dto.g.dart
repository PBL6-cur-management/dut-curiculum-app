// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_semester_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalSemesterDto _$PortalSemesterDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalSemesterDto', json, ($checkedConvert) {
      final val = PortalSemesterDto(
        id: $checkedConvert('id', (v) => v as String),
        semesterCode: $checkedConvert('semesterCode', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PortalSemesterDtoToJson(PortalSemesterDto instance) =>
    <String, dynamic>{'id': instance.id, 'semesterCode': instance.semesterCode};
