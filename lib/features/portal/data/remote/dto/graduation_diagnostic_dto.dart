import 'package:json_annotation/json_annotation.dart';

part 'graduation_diagnostic_dto.g.dart';

@JsonSerializable()
class GraduationDiagnosticDto {
  const GraduationDiagnosticDto({required this.message});

  factory GraduationDiagnosticDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationDiagnosticDtoFromJson(json);

  final String message;

  Map<String, dynamic> toJson() => _$GraduationDiagnosticDtoToJson(this);
}
