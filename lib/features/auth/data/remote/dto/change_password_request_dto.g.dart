// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestDto _$ChangePasswordRequestDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ChangePasswordRequestDto', json, ($checkedConvert) {
  final val = ChangePasswordRequestDto(
    currentPassword: $checkedConvert('currentPassword', (v) => v as String),
    newPassword: $checkedConvert('newPassword', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$ChangePasswordRequestDtoToJson(
  ChangePasswordRequestDto instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};
