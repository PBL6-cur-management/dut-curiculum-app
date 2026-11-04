import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../../common/extensions/date_parsing.dart';
import '../../../domain/model/student_warning_codes.dart';
import '../../../domain/model/graduation_conclusion.dart';
import '../../../domain/model/graduation_result.dart';
import 'graduation_block_progress_dto.dart';
import 'graduation_context_dto.dart';
import 'graduation_credits_dto.dart';
import 'graduation_group_progress_dto.dart';
import 'graduation_shortfall_dto.dart';
import 'graduation_warning_dto.dart';

part 'graduation_result_dto.g.dart';

@JsonSerializable()
class GraduationResultDto {
  const GraduationResultDto({
    required this.schemaVersion,
    required this.evaluatedAt,
    required this.context,
    required this.conclusion,
    required this.credits,
    required this.shortfalls,
    required this.warnings,
    required this.electiveGroups,
    required this.knowledgeBlocks,
  });

  factory GraduationResultDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationResultDtoFromJson(json);

  final int schemaVersion;
  final String evaluatedAt;
  final GraduationContextDto context;
  final String conclusion;
  final GraduationCreditsDto credits;
  final List<GraduationShortfallDto> shortfalls;
  final List<GraduationWarningDto> warnings;
  final List<GraduationGroupProgressDto> electiveGroups;
  final List<GraduationBlockProgressDto> knowledgeBlocks;

  Map<String, dynamic> toJson() => _$GraduationResultDtoToJson(this);

  GraduationResult toDomain(AppLocalizations strings) => GraduationResult(
    evaluatedAtMs: parseTimestamp(evaluatedAt),
    programCode: context.programCode,
    programName: context.programName,
    cohortCode: context.cohortCode,
    versionNumber: context.versionNumber,
    semesterCode: context.semesterCode,
    conclusion: GraduationConclusion.parse(conclusion),
    credits: credits.toDomain(),
    shortfalls: List.unmodifiable(
      shortfalls.map((item) => item.toDomain(strings)),
    ),
    warnings: List.unmodifiable(
      warnings
          .where((item) => studentGraduationWarningCodes.contains(item.code))
          .map((item) => item.toDomain()),
    ),
    electiveGroups: List.unmodifiable(
      electiveGroups.map((item) => item.toDomain()),
    ),
    knowledgeBlocks: List.unmodifiable(
      knowledgeBlocks.map((item) => item.toDomain()),
    ),
  );
}
