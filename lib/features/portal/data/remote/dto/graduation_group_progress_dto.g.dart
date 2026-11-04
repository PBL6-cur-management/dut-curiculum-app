// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_group_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationGroupProgressDto _$GraduationGroupProgressDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationGroupProgressDto', json, ($checkedConvert) {
  final val = GraduationGroupProgressDto(
    groupCode: $checkedConvert('groupCode', (v) => v as String),
    groupName: $checkedConvert('groupName', (v) => v as String),
    requiredCredits: $checkedConvert('requiredCredits', (v) => v as String?),
    earnedCredits: $checkedConvert('earnedCredits', (v) => v as String),
    missingCredits: $checkedConvert('missingCredits', (v) => v as String?),
    requiredCourses: $checkedConvert(
      'requiredCourses',
      (v) => (v as num?)?.toInt(),
    ),
    earnedCourses: $checkedConvert('earnedCourses', (v) => (v as num).toInt()),
    missingCourses: $checkedConvert(
      'missingCourses',
      (v) => (v as num?)?.toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$GraduationGroupProgressDtoToJson(
  GraduationGroupProgressDto instance,
) => <String, dynamic>{
  'groupCode': instance.groupCode,
  'groupName': instance.groupName,
  'requiredCredits': instance.requiredCredits,
  'earnedCredits': instance.earnedCredits,
  'missingCredits': instance.missingCredits,
  'requiredCourses': instance.requiredCourses,
  'earnedCourses': instance.earnedCourses,
  'missingCourses': instance.missingCourses,
};
