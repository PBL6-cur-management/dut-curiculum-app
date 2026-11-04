// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_warning_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationWarningDto _$GraduationWarningDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationWarningDto', json, ($checkedConvert) {
  final val = GraduationWarningDto(
    code: $checkedConvert('code', (v) => v as String),
    message: $checkedConvert('message', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$GraduationWarningDtoToJson(
  GraduationWarningDto instance,
) => <String, dynamic>{'code': instance.code, 'message': instance.message};
