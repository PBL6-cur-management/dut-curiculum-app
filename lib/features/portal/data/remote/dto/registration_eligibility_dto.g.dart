// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_eligibility_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationEligibilityDto _$RegistrationEligibilityDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RegistrationEligibilityDto', json, ($checkedConvert) {
  final val = RegistrationEligibilityDto(
    contractVersion: $checkedConvert(
      'contractVersion',
      (v) => (v as num).toInt(),
    ),
    evaluatedAt: $checkedConvert('evaluatedAt', (v) => v as String),
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => EligibilityItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    warnings: $checkedConvert(
      'warnings',
      (v) => (v as List<dynamic>)
          .map((e) => EligibilityWarningDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$RegistrationEligibilityDtoToJson(
  RegistrationEligibilityDto instance,
) => <String, dynamic>{
  'contractVersion': instance.contractVersion,
  'evaluatedAt': instance.evaluatedAt,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'warnings': instance.warnings.map((e) => e.toJson()).toList(),
};
