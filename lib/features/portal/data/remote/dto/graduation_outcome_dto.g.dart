// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_outcome_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationOutcomeDto _$GraduationOutcomeDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationOutcomeDto', json, ($checkedConvert) {
  final val = GraduationOutcomeDto(
    status: $checkedConvert('status', (v) => v as String),
    result: $checkedConvert('result', (v) => v as Map<String, dynamic>?),
    error: $checkedConvert(
      'error',
      (v) => v == null
          ? null
          : GraduationDiagnosticDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$GraduationOutcomeDtoToJson(
  GraduationOutcomeDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'result': instance.result,
  'error': instance.error?.toJson(),
};
