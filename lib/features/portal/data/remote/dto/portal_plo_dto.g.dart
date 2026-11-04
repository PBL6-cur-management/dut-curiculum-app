// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_plo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalPloDto _$PortalPloDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalPloDto', json, ($checkedConvert) {
      final val = PortalPloDto(
        ploCode: $checkedConvert('ploCode', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        competencyGroup: $checkedConvert(
          'competencyGroup',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$PortalPloDtoToJson(PortalPloDto instance) =>
    <String, dynamic>{
      'ploCode': instance.ploCode,
      'description': instance.description,
      'competencyGroup': instance.competencyGroup,
    };
