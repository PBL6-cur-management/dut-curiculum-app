// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_block_progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationBlockProgressDto _$GraduationBlockProgressDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationBlockProgressDto', json, ($checkedConvert) {
  final val = GraduationBlockProgressDto(
    blockSymbol: $checkedConvert('blockSymbol', (v) => v as String?),
    blockName: $checkedConvert('blockName', (v) => v as String?),
    earnedCredits: $checkedConvert('earnedCredits', (v) => v as String),
    compulsoryCredits: $checkedConvert('compulsoryCredits', (v) => v as String),
    electiveCredits: $checkedConvert('electiveCredits', (v) => v as String),
    catalogRequiredCredits: $checkedConvert(
      'catalogRequiredCredits',
      (v) => v as String?,
    ),
    advisoryGap: $checkedConvert('advisoryGap', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$GraduationBlockProgressDtoToJson(
  GraduationBlockProgressDto instance,
) => <String, dynamic>{
  'blockSymbol': instance.blockSymbol,
  'blockName': instance.blockName,
  'earnedCredits': instance.earnedCredits,
  'compulsoryCredits': instance.compulsoryCredits,
  'electiveCredits': instance.electiveCredits,
  'catalogRequiredCredits': instance.catalogRequiredCredits,
  'advisoryGap': instance.advisoryGap,
};
