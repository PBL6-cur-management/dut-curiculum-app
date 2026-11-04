import '../../../domain/model/portal_semester_ref.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_semester_dto.g.dart';

@JsonSerializable()
class PortalSemesterDto {
  const PortalSemesterDto({required this.id, required this.semesterCode});

  factory PortalSemesterDto.fromJson(Map<String, dynamic> json) =>
      _$PortalSemesterDtoFromJson(json);

  final String id;
  final String semesterCode;

  Map<String, dynamic> toJson() => _$PortalSemesterDtoToJson(this);

  PortalSemesterRef toDomain() => PortalSemesterRef(id: id, code: semesterCode);
}
