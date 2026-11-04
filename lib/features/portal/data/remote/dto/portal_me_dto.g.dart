// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalMeDto _$PortalMeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalMeDto', json, ($checkedConvert) {
      final val = PortalMeDto(
        student: $checkedConvert(
          'student',
          (v) => v == null
              ? null
              : PortalStudentDto.fromJson(v as Map<String, dynamic>),
        ),
        semester: $checkedConvert(
          'semester',
          (v) => v == null
              ? null
              : PortalSemesterDto.fromJson(v as Map<String, dynamic>),
        ),
        programs: $checkedConvert(
          'programs',
          (v) => (v as List<dynamic>)
              .map((e) => PortalProgramDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PortalMeDtoToJson(PortalMeDto instance) =>
    <String, dynamic>{
      'student': instance.student?.toJson(),
      'semester': instance.semester?.toJson(),
      'programs': instance.programs.map((e) => e.toJson()).toList(),
    };
