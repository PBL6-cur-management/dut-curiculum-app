// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_shortfall_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationShortfallDto _$GraduationShortfallDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationShortfallDto', json, ($checkedConvert) {
  final val = GraduationShortfallDto(
    code: $checkedConvert('code', (v) => v as String),
    category: $checkedConvert('category', (v) => v as String),
    message: $checkedConvert('message', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$GraduationShortfallDtoToJson(
  GraduationShortfallDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'category': instance.category,
  'message': instance.message,
};
