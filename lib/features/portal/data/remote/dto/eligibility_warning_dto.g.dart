// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_warning_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EligibilityWarningDto _$EligibilityWarningDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EligibilityWarningDto', json, ($checkedConvert) {
  final val = EligibilityWarningDto(
    code: $checkedConvert('code', (v) => v as String),
    message: $checkedConvert('message', (v) => v as String),
    course: $checkedConvert(
      'course',
      (v) => CourseRefDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$EligibilityWarningDtoToJson(
  EligibilityWarningDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'course': instance.course.toJson(),
};
