import 'package:json_annotation/json_annotation.dart';

import '../../../domain/model/session_user.dart';
import 'me_role_dto.dart';

part 'me_dto.g.dart';

@JsonSerializable()
class MeDto {
  const MeDto({
    required this.id,
    required this.username,
    required this.userCode,
    required this.fullName,
    required this.email,
    required this.mustChangePassword,
    required this.roles,
  });

  factory MeDto.fromJson(Map<String, dynamic> json) => _$MeDtoFromJson(json);

  final String id;
  final String username;
  final String userCode;
  final String fullName;
  final String? email;
  final bool mustChangePassword;
  final List<MeRoleDto> roles;

  Map<String, dynamic> toJson() => _$MeDtoToJson(this);

  SessionUser toDomain() => SessionUser(
    id: id,
    username: username,
    userCode: userCode,
    fullName: fullName,
    email: email,
    mustChangePassword: mustChangePassword,
    roleNames: List.unmodifiable(roles.map((role) => role.roleName)),
  );
}
