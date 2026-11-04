// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicResultDto _$AcademicResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AcademicResultDto', json, ($checkedConvert) {
      final val = AcademicResultDto(
        id: $checkedConvert('id', (v) => v as String),
        course: $checkedConvert(
          'course',
          (v) => CourseRefDto.fromJson(v as Map<String, dynamic>),
        ),
        semester: $checkedConvert(
          'semester',
          (v) => SemesterDto.fromJson(v as Map<String, dynamic>),
        ),
        score10: $checkedConvert('score10', (v) => v as String?),
        score4: $checkedConvert('score4', (v) => v as String?),
        letterGrade: $checkedConvert('letterGrade', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AcademicResultDtoToJson(AcademicResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course.toJson(),
      'semester': instance.semester.toJson(),
      'score10': instance.score10,
      'score4': instance.score4,
      'letterGrade': instance.letterGrade,
      'status': instance.status,
    };
