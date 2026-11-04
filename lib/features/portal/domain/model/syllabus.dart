import 'package:equatable/equatable.dart';
import 'syllabus_assessment.dart';
import 'syllabus_attachment.dart';
import 'syllabus_clo.dart';
import 'syllabus_week.dart';

class Syllabus extends Equatable {
  const Syllabus({
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.revisionNumber,
    required this.publishedAtMs,
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

  final String courseCode;
  final String courseName;
  final String credits;
  final int revisionNumber;
  final int? publishedAtMs;
  final String? courseDescription;
  final String? objectives;
  final String? teachingMethods;
  final String? assessmentMethods;
  final String? references;
  final List<SyllabusClo> clos;
  final List<SyllabusWeek> weeks;
  final List<SyllabusAssessment> assessments;
  final List<SyllabusAttachment> attachments;

  @override
  List<Object?> get props => [
    courseCode,
    courseName,
    credits,
    revisionNumber,
    publishedAtMs,
    courseDescription,
    objectives,
    teachingMethods,
    assessmentMethods,
    references,
    clos,
    weeks,
    assessments,
    attachments,
  ];
}
