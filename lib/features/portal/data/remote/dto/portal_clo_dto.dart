import '../../../domain/model/syllabus_clo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_clo_dto.g.dart';

@JsonSerializable()
class PortalCloDto {
  const PortalCloDto({required this.cloCode, required this.description});

  factory PortalCloDto.fromJson(Map<String, dynamic> json) =>
      _$PortalCloDtoFromJson(json);

  final String cloCode;
  final String description;

  Map<String, dynamic> toJson() => _$PortalCloDtoToJson(this);

  SyllabusClo toDomain() =>
      SyllabusClo(code: cloCode, description: description);
}
