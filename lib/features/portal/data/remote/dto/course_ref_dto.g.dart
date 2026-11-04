// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_ref_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRefDto _$CourseRefDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CourseRefDto', json, ($checkedConvert) {
      final val = CourseRefDto(
        id: $checkedConvert('id', (v) => v as String),
        courseCode: $checkedConvert('courseCode', (v) => v as String),
        courseName: $checkedConvert('courseName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CourseRefDtoToJson(CourseRefDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
    };
