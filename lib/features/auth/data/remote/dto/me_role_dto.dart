import 'package:json_annotation/json_annotation.dart';

part 'me_role_dto.g.dart';

@JsonSerializable()
class MeRoleDto {
  const MeRoleDto({required this.roleName});

  factory MeRoleDto.fromJson(Map<String, dynamic> json) =>
      _$MeRoleDtoFromJson(json);

  final String roleName;

  Map<String, dynamic> toJson() => _$MeRoleDtoToJson(this);
}
