import '../../../domain/model/knowledge_block_progress.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graduation_block_progress_dto.g.dart';

@JsonSerializable()
class GraduationBlockProgressDto {
  const GraduationBlockProgressDto({
    required this.blockSymbol,
    required this.blockName,
    required this.earnedCredits,
    required this.compulsoryCredits,
    required this.electiveCredits,
    required this.catalogRequiredCredits,
    required this.advisoryGap,
  });

  factory GraduationBlockProgressDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationBlockProgressDtoFromJson(json);

  final String? blockSymbol;
  final String? blockName;
  final String earnedCredits;
  final String compulsoryCredits;
  final String electiveCredits;
  final String? catalogRequiredCredits;
  final String? advisoryGap;

  Map<String, dynamic> toJson() => _$GraduationBlockProgressDtoToJson(this);

  KnowledgeBlockProgress toDomain() => KnowledgeBlockProgress(
    blockSymbol: blockSymbol,
    blockName: blockName,
    earnedCredits: earnedCredits,
    compulsoryCredits: compulsoryCredits,
    electiveCredits: electiveCredits,
    catalogRequiredCredits: catalogRequiredCredits,
    advisoryGap: advisoryGap,
  );
}
