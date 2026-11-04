// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationResultDto _$GraduationResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationResultDto', json, ($checkedConvert) {
  final val = GraduationResultDto(
    schemaVersion: $checkedConvert('schemaVersion', (v) => (v as num).toInt()),
    evaluatedAt: $checkedConvert('evaluatedAt', (v) => v as String),
    context: $checkedConvert(
      'context',
      (v) => GraduationContextDto.fromJson(v as Map<String, dynamic>),
    ),
    conclusion: $checkedConvert('conclusion', (v) => v as String),
    credits: $checkedConvert(
      'credits',
      (v) => GraduationCreditsDto.fromJson(v as Map<String, dynamic>),
    ),
    shortfalls: $checkedConvert(
      'shortfalls',
      (v) => (v as List<dynamic>)
          .map(
            (e) => GraduationShortfallDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    warnings: $checkedConvert(
      'warnings',
      (v) => (v as List<dynamic>)
          .map((e) => GraduationWarningDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    electiveGroups: $checkedConvert(
      'electiveGroups',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                GraduationGroupProgressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    knowledgeBlocks: $checkedConvert(
      'knowledgeBlocks',
      (v) => (v as List<dynamic>)
          .map(
            (e) =>
                GraduationBlockProgressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$GraduationResultDtoToJson(
  GraduationResultDto instance,
) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'evaluatedAt': instance.evaluatedAt,
  'context': instance.context.toJson(),
  'conclusion': instance.conclusion,
  'credits': instance.credits.toJson(),
  'shortfalls': instance.shortfalls.map((e) => e.toJson()).toList(),
  'warnings': instance.warnings.map((e) => e.toJson()).toList(),
  'electiveGroups': instance.electiveGroups.map((e) => e.toJson()).toList(),
  'knowledgeBlocks': instance.knowledgeBlocks.map((e) => e.toJson()).toList(),
};
