import '../../../domain/model/graduation_warning.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graduation_warning_dto.g.dart';

@JsonSerializable()
class GraduationWarningDto {
  const GraduationWarningDto({required this.code, required this.message});

  factory GraduationWarningDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationWarningDtoFromJson(json);

  final String code;
  final String message;

  Map<String, dynamic> toJson() => _$GraduationWarningDtoToJson(this);

  GraduationWarning toDomain() =>
      GraduationWarning(code: code, message: message);
}
