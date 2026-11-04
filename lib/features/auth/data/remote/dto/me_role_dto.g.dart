// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_role_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeRoleDto _$MeRoleDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MeRoleDto', json, ($checkedConvert) {
      final val = MeRoleDto(
        roleName: $checkedConvert('roleName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MeRoleDtoToJson(MeRoleDto instance) => <String, dynamic>{
  'roleName': instance.roleName,
};
