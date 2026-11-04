// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_term_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalTermDto _$PortalTermDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalTermDto', json, ($checkedConvert) {
      final val = PortalTermDto(
        plannedSemester: $checkedConvert(
          'plannedSemester',
          (v) => (v as num).toInt(),
        ),
        credits: $checkedConvert('credits', (v) => v as String),
        courses: $checkedConvert(
          'courses',
          (v) => (v as List<dynamic>)
              .map((e) => PortalCourseDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PortalTermDtoToJson(PortalTermDto instance) =>
    <String, dynamic>{
      'plannedSemester': instance.plannedSemester,
      'credits': instance.credits,
      'courses': instance.courses.map((e) => e.toJson()).toList(),
    };
