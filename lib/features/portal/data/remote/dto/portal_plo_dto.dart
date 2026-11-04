import '../../../domain/model/plo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_plo_dto.g.dart';

@JsonSerializable()
class PortalPloDto {
  const PortalPloDto({
    required this.ploCode,
    required this.description,
    required this.competencyGroup,
  });

  factory PortalPloDto.fromJson(Map<String, dynamic> json) =>
      _$PortalPloDtoFromJson(json);

  final String ploCode;
  final String description;
  final String? competencyGroup;

  Map<String, dynamic> toJson() => _$PortalPloDtoToJson(this);

  Plo toDomain() => Plo(
    code: ploCode,
    description: description,
    competencyGroup: competencyGroup,
  );
}
