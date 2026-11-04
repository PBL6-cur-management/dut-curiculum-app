// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EligibilityItemDto _$EligibilityItemDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EligibilityItemDto', json, ($checkedConvert) {
      final val = EligibilityItemDto(
        itemId: $checkedConvert('itemId', (v) => v as String),
        course: $checkedConvert(
          'course',
          (v) => CourseRefDto.fromJson(v as Map<String, dynamic>),
        ),
        credits: $checkedConvert('credits', (v) => v as String),
        catalogStatus: $checkedConvert('catalogStatus', (v) => v as String),
        plannedSemester: $checkedConvert(
          'plannedSemester',
          (v) => (v as num).toInt(),
        ),
        completed: $checkedConvert('completed', (v) => v as bool),
        eligibility: $checkedConvert('eligibility', (v) => v as String?),
        statusText: $checkedConvert('statusText', (v) => v as String),
        reasons: $checkedConvert(
          'reasons',
          (v) => (v as List<dynamic>)
              .map(
                (e) => EligibilityReasonDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        requiredConcurrentCourses: $checkedConvert(
          'requiredConcurrentCourses',
          (v) => (v as List<dynamic>)
              .map((e) => CourseRefDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EligibilityItemDtoToJson(EligibilityItemDto instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'course': instance.course.toJson(),
      'credits': instance.credits,
      'catalogStatus': instance.catalogStatus,
      'plannedSemester': instance.plannedSemester,
      'completed': instance.completed,
      'eligibility': instance.eligibility,
      'statusText': instance.statusText,
      'reasons': instance.reasons.map((e) => e.toJson()).toList(),
      'requiredConcurrentCourses': instance.requiredConcurrentCourses
          .map((e) => e.toJson())
          .toList(),
    };
