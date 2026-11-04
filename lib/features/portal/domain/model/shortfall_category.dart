import '../../../../core/network/contract_exception.dart';

enum ShortfallCategory {
  mandatoryCourse,
  electiveGroup,
  conditionalCourse,
  totalCredits;

  static ShortfallCategory parse(String wire) => switch (wire) {
    'MANDATORY_COURSE' => mandatoryCourse,
    'ELECTIVE_GROUP' => electiveGroup,
    'CONDITIONAL_COURSE' => conditionalCourse,
    'TOTAL_CREDITS' => totalCredits,
    _ => throw ContractException(wire),
  };
}
