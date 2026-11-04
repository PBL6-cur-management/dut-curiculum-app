import '../../../domain/model/curriculum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'portal_term_dto.dart';

part 'portal_curriculum_dto.g.dart';

@JsonSerializable()
class PortalCurriculumDto {
  const PortalCurriculumDto({
    required this.programName,
    required this.versionNumber,
    required this.decisionNumber,
    required this.totalCredits,
    required this.terms,
  });

  factory PortalCurriculumDto.fromJson(Map<String, dynamic> json) =>
      _$PortalCurriculumDtoFromJson(json);

  final String programName;
  final String? versionNumber;
  final String? decisionNumber;
  final String totalCredits;
  final List<PortalTermDto> terms;

  Map<String, dynamic> toJson() => _$PortalCurriculumDtoToJson(this);

  Curriculum toDomain() => Curriculum(
    programName: programName,
    versionNumber: versionNumber,
    decisionNumber: decisionNumber,
    totalCredits: totalCredits,
    terms: List.unmodifiable(terms.map((item) => item.toDomain())),
  );
}
