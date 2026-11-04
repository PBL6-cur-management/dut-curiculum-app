// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeDto _$MeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MeDto', json, ($checkedConvert) {
      final val = MeDto(
        id: $checkedConvert('id', (v) => v as String),
        username: $checkedConvert('username', (v) => v as String),
        userCode: $checkedConvert('userCode', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String?),
        mustChangePassword: $checkedConvert(
          'mustChangePassword',
          (v) => v as bool,
        ),
        roles: $checkedConvert(
          'roles',
          (v) => (v as List<dynamic>)
              .map((e) => MeRoleDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MeDtoToJson(MeDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'userCode': instance.userCode,
  'fullName': instance.fullName,
  'email': instance.email,
  'mustChangePassword': instance.mustChangePassword,
  'roles': instance.roles.map((e) => e.toJson()).toList(),
};
