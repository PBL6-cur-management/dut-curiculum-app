// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalCourseDto _$PortalCourseDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalCourseDto', json, ($checkedConvert) {
      final val = PortalCourseDto(
        itemId: $checkedConvert('itemId', (v) => v as String),
        courseCode: $checkedConvert('courseCode', (v) => v as String),
        courseName: $checkedConvert('courseName', (v) => v as String),
        credits: $checkedConvert('credits', (v) => v as String),
        isElective: $checkedConvert('isElective', (v) => v as bool),
        groupName: $checkedConvert('groupName', (v) => v as String?),
        blockSymbol: $checkedConvert('blockSymbol', (v) => v as String?),
        state: $checkedConvert('state', (v) => v as String),
        attemptCount: $checkedConvert(
          'attemptCount',
          (v) => (v as num).toInt(),
        ),
        score10: $checkedConvert('score10', (v) => v as String?),
        score4: $checkedConvert('score4', (v) => v as String?),
        letterGrade: $checkedConvert('letterGrade', (v) => v as String?),
        hasSyllabus: $checkedConvert('hasSyllabus', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PortalCourseDtoToJson(PortalCourseDto instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
      'credits': instance.credits,
      'isElective': instance.isElective,
      'groupName': instance.groupName,
      'blockSymbol': instance.blockSymbol,
      'state': instance.state,
      'attemptCount': instance.attemptCount,
      'score10': instance.score10,
      'score4': instance.score4,
      'letterGrade': instance.letterGrade,
      'hasSyllabus': instance.hasSyllabus,
    };
