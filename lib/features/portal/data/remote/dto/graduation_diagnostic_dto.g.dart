// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graduation_diagnostic_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraduationDiagnosticDto _$GraduationDiagnosticDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GraduationDiagnosticDto', json, ($checkedConvert) {
  final val = GraduationDiagnosticDto(
    message: $checkedConvert('message', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$GraduationDiagnosticDtoToJson(
  GraduationDiagnosticDto instance,
) => <String, dynamic>{'message': instance.message};
