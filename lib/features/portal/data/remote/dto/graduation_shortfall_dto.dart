import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../../core/network/contract_exception.dart';
import '../../../domain/model/graduation_shortfall.dart';
import '../../../domain/model/shortfall_category.dart';

part 'graduation_shortfall_dto.g.dart';

@JsonSerializable()
class GraduationShortfallDto {
  const GraduationShortfallDto({
    required this.code,
    required this.category,
    required this.message,
  });

  factory GraduationShortfallDto.fromJson(Map<String, dynamic> json) =>
      _$GraduationShortfallDtoFromJson(json);

  final String code;
  final String category;
  final String message;

  Map<String, dynamic> toJson() => _$GraduationShortfallDtoToJson(this);

  GraduationShortfall toDomain(AppLocalizations strings) => GraduationShortfall(
    category: ShortfallCategory.parse(category),
    code: code,
    title: switch (code) {
      'MANDATORY_COURSE_MISSING' => strings.mandatoryCourseMissing,
      'CONDITIONAL_COURSE_MISSING' => strings.conditionalCourseMissing,
      'ELECTIVE_CREDITS_MISSING' => strings.electiveCreditsMissing,
      'ELECTIVE_COURSES_MISSING' => strings.electiveCoursesMissing,
      'TOTAL_CREDITS_MISSING' => strings.totalCreditsMissing,
      _ => throw ContractException(code),
    },
    message: message,
  );
}
