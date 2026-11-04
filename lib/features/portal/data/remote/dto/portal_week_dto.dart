import '../../../domain/model/syllabus_week.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_week_dto.g.dart';

@JsonSerializable()
class PortalWeekDto {
  const PortalWeekDto({required this.weekLabel, required this.content});

  factory PortalWeekDto.fromJson(Map<String, dynamic> json) =>
      _$PortalWeekDtoFromJson(json);

  final String weekLabel;
  final String content;

  Map<String, dynamic> toJson() => _$PortalWeekDtoToJson(this);

  SyllabusWeek toDomain() => SyllabusWeek(label: weekLabel, content: content);
}
