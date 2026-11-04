import '../../../domain/model/material_kind.dart';
import '../../../domain/model/syllabus_attachment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_attachment_dto.g.dart';

@JsonSerializable()
class PortalAttachmentDto {
  const PortalAttachmentDto({
    required this.id,
    required this.fileName,
    required this.materialKind,
    required this.sizeBytes,
  });

  factory PortalAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$PortalAttachmentDtoFromJson(json);

  final String id;
  final String fileName;
  final String materialKind;
  final int sizeBytes;

  Map<String, dynamic> toJson() => _$PortalAttachmentDtoToJson(this);

  SyllabusAttachment toDomain() => SyllabusAttachment(
    id: id,
    fileName: fileName,
    kind: MaterialKind.parse(materialKind),
    sizeBytes: sizeBytes,
  );
}
