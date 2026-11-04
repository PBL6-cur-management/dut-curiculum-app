// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_reason_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EligibilityReasonDto _$EligibilityReasonDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('EligibilityReasonDto', json, ($checkedConvert) {
  final val = EligibilityReasonDto(
    message: $checkedConvert('message', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String?),
    evidenceCourse: $checkedConvert(
      'evidenceCourse',
      (v) =>
          v == null ? null : CourseRefDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$EligibilityReasonDtoToJson(
  EligibilityReasonDto instance,
) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'evidenceCourse': instance.evidenceCourse?.toJson(),
};
