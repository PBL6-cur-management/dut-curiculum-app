import '../../../domain/model/elective_group_progress.dart';
import 'package:json_annotation/json_annotation.dart';

part 'graduation_group_progress_dto.g.dart';

@JsonSerializable()
class GraduationGroupProgressDto {
  const GraduationGroupProgressDto({
    required this.groupCode,
    required this.groupName,
    required this.requiredCredits,
    required this.earnedCredits,
    required this.missingCredits,
    required this.requiredCourses,
    required this.earnedCourses,
    required this.missingCourses,
  });

  factory GraduationGroupProgressDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationGroupProgressDtoFromJson(json);

  final String groupCode;
  final String groupName;
  final String? requiredCredits;
  final String earnedCredits;
  final String? missingCredits;
  final int? requiredCourses;
  final int earnedCourses;
  final int? missingCourses;

  Map<String, dynamic> toJson() => _$GraduationGroupProgressDtoToJson(this);

  ElectiveGroupProgress toDomain() => ElectiveGroupProgress(
    groupCode: groupCode,
    groupName: groupName,
    requiredCredits: requiredCredits,
    earnedCredits: earnedCredits,
    missingCredits: missingCredits,
    requiredCourses: requiredCourses,
    earnedCourses: earnedCourses,
    missingCourses: missingCourses,
  );
}
