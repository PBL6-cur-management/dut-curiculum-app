// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_clo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalCloDto _$PortalCloDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalCloDto', json, ($checkedConvert) {
      final val = PortalCloDto(
        cloCode: $checkedConvert('cloCode', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PortalCloDtoToJson(PortalCloDto instance) =>
    <String, dynamic>{
      'cloCode': instance.cloCode,
      'description': instance.description,
    };
