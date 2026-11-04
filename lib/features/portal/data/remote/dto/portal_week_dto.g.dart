// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_week_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalWeekDto _$PortalWeekDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalWeekDto', json, ($checkedConvert) {
      final val = PortalWeekDto(
        weekLabel: $checkedConvert('weekLabel', (v) => v as String),
        content: $checkedConvert('content', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PortalWeekDtoToJson(PortalWeekDto instance) =>
    <String, dynamic>{
      'weekLabel': instance.weekLabel,
      'content': instance.content,
    };
