// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_syllabus_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalSyllabusDto _$PortalSyllabusDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PortalSyllabusDto', json, ($checkedConvert) {
  final val = PortalSyllabusDto(
    courseCode: $checkedConvert('courseCode', (v) => v as String),
    courseName: $checkedConvert('courseName', (v) => v as String),
    credits: $checkedConvert('credits', (v) => v as String),
    revisionNumber: $checkedConvert(
      'revisionNumber',
      (v) => (v as num).toInt(),
    ),
    publishedAt: $checkedConvert('publishedAt', (v) => v as String?),
    courseDescription: $checkedConvert(
      'courseDescription',
      (v) => v as String?,
    ),
    objectives: $checkedConvert('objectives', (v) => v as String?),
    teachingMethods: $checkedConvert('teachingMethods', (v) => v as String?),
    assessmentMethods: $checkedConvert(
      'assessmentMethods',
      (v) => v as String?,
    ),
    references: $checkedConvert('references', (v) => v as String?),
    clos: $checkedConvert(
      'clos',
      (v) => (v as List<dynamic>)
          .map((e) => PortalCloDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    weeks: $checkedConvert(
      'weeks',
      (v) => (v as List<dynamic>)
          .map((e) => PortalWeekDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    assessments: $checkedConvert(
      'assessments',
      (v) => (v as List<dynamic>)
          .map((e) => PortalAssessmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    attachments: $checkedConvert(
      'attachments',
      (v) => (v as List<dynamic>)
          .map((e) => PortalAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PortalSyllabusDtoToJson(PortalSyllabusDto instance) =>
    <String, dynamic>{
      'courseCode': instance.courseCode,
      'courseName': instance.courseName,
      'credits': instance.credits,
      'revisionNumber': instance.revisionNumber,
      'publishedAt': instance.publishedAt,
      'courseDescription': instance.courseDescription,
      'objectives': instance.objectives,
      'teachingMethods': instance.teachingMethods,
      'assessmentMethods': instance.assessmentMethods,
      'references': instance.references,
      'clos': instance.clos.map((e) => e.toJson()).toList(),
      'weeks': instance.weeks.map((e) => e.toJson()).toList(),
      'assessments': instance.assessments.map((e) => e.toJson()).toList(),
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
    };
