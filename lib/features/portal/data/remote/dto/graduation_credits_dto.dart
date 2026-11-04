import '../../../domain/model/graduation_credits.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graduation_credits_dto.g.dart';

@JsonSerializable()
class GraduationCreditsDto {
  const GraduationCreditsDto({
    required this.requiredTotal,
    required this.recognizedTotal,
    required this.missingTotal,
    required this.compulsory,
    required this.elective,
    required this.free,
  });

  factory GraduationCreditsDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationCreditsDtoFromJson(json);

  final String requiredTotal;
  final String recognizedTotal;
  final String missingTotal;
  final String compulsory;
  final String elective;
  final String free;

  Map<String, dynamic> toJson() => _$GraduationCreditsDtoToJson(this);

  GraduationCredits toDomain() => GraduationCredits(
    requiredTotal: requiredTotal,
    recognizedTotal: recognizedTotal,
    missingTotal: missingTotal,
    compulsory: compulsory,
    elective: elective,
    free: free,
  );
}
