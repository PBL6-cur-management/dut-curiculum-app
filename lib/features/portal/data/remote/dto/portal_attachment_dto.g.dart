// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalAttachmentDto _$PortalAttachmentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PortalAttachmentDto', json, ($checkedConvert) {
      final val = PortalAttachmentDto(
        id: $checkedConvert('id', (v) => v as String),
        fileName: $checkedConvert('fileName', (v) => v as String),
        materialKind: $checkedConvert('materialKind', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PortalAttachmentDtoToJson(
  PortalAttachmentDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'materialKind': instance.materialKind,
  'sizeBytes': instance.sizeBytes,
};
