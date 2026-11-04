// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_credits_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationCreditsDto _$GraduationCreditsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationCreditsDto', json, ($checkedConvert) {
  final val = GraduationCreditsDto(
    requiredTotal: $checkedConvert('requiredTotal', (v) => v as String),
    recognizedTotal: $checkedConvert('recognizedTotal', (v) => v as String),
    missingTotal: $checkedConvert('missingTotal', (v) => v as String),
    compulsory: $checkedConvert('compulsory', (v) => v as String),
    elective: $checkedConvert('elective', (v) => v as String),
    free: $checkedConvert('free', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$GraduationCreditsDtoToJson(
  GraduationCreditsDto instance,
) => <String, dynamic>{
  'requiredTotal': instance.requiredTotal,
  'recognizedTotal': instance.recognizedTotal,
  'missingTotal': instance.missingTotal,
  'compulsory': instance.compulsory,
  'elective': instance.elective,
  'free': instance.free,
};
