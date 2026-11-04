import 'package:equatable/equatable.dart';
import 'elective_group_progress.dart';
import 'graduation_conclusion.dart';
import 'graduation_credits.dart';
import 'graduation_shortfall.dart';
import 'graduation_warning.dart';
import 'knowledge_block_progress.dart';

class GraduationResult extends Equatable {
  const GraduationResult({
    required this.evaluatedAtMs,
    required this.programCode,
    required this.programName,
    required this.cohortCode,
    required this.versionNumber,
    required this.semesterCode,
    required this.conclusion,
    required this.credits,
    required this.shortfalls,
    required this.warnings,
    required this.electiveGroups,
    required this.knowledgeBlocks,
  });

  final int evaluatedAtMs;
  final String programCode;
  final String programName;
  final String cohortCode;
  final String versionNumber;
  final String semesterCode;
  final GraduationConclusion conclusion;
  final GraduationCredits credits;
  final List<GraduationShortfall> shortfalls;
  final List<GraduationWarning> warnings;
  final List<ElectiveGroupProgress> electiveGroups;
  final List<KnowledgeBlockProgress> knowledgeBlocks;

  @override
  List<Object?> get props => [
    evaluatedAtMs,
    programCode,
    programName,
    cohortCode,
    versionNumber,
    semesterCode,
    conclusion,
    credits,
    shortfalls,
    warnings,
    electiveGroups,
    knowledgeBlocks,
  ];
}
