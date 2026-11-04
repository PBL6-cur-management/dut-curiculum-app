import '../../../../../common/extensions/date_parsing.dart';
import '../../../domain/model/syllabus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'portal_assessment_dto.dart';
import 'portal_attachment_dto.dart';
import 'portal_clo_dto.dart';
import 'portal_week_dto.dart';

part 'portal_syllabus_dto.g.dart';

@JsonSerializable()
class PortalSyllabusDto {
  const PortalSyllabusDto({
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.revisionNumber,
    required this.publishedAt,
    required this.courseDescription,
    required this.objectives,
    required this.teachingMethods,
    required this.assessmentMethods,
    required this.references,
    required this.clos,
    required this.weeks,
    required this.assessments,
    required this.attachments,
  });

  factory PortalSyllabusDto.fromJson(Map<String, dynamic> json) =>
      _$PortalSyllabusDtoFromJson(json);

  final String courseCode;
  final String courseName;
  final String credits;
  final int revisionNumber;
  final String? publishedAt;
  final String? courseDescription;
  final String? objectives;
  final String? teachingMethods;
  final String? assessmentMethods;
  final String? references;
  final List<PortalCloDto> clos;
  final List<PortalWeekDto> weeks;
  final List<PortalAssessmentDto> assessments;
  final List<PortalAttachmentDto> attachments;

  Map<String, dynamic> toJson() => _$PortalSyllabusDtoToJson(this);

  Syllabus toDomain() => Syllabus(
    courseCode: courseCode,
    courseName: courseName,
    credits: credits,
    revisionNumber: revisionNumber,
    publishedAtMs: publishedAt == null ? null : parseTimestamp(publishedAt!),
    courseDescription: courseDescription,
    objectives: objectives,
    teachingMethods: teachingMethods,
    assessmentMethods: assessmentMethods,
    references: references,
    clos: List.unmodifiable(clos.map((item) => item.toDomain())),
    weeks: List.unmodifiable(weeks.map((item) => item.toDomain())),
    assessments: List.unmodifiable(assessments.map((item) => item.toDomain())),
    attachments: List.unmodifiable(attachments.map((item) => item.toDomain())),
  );
}
