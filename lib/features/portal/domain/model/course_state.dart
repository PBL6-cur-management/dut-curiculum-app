import '../../../../core/network/contract_exception.dart';

enum CourseState {
  passed,
  passedEquivalent,
  inProgress,
  failed,
  notTaken;

  static CourseState parse(String wire) => switch (wire) {
    'PASSED' => passed,
    'PASSED_EQUIVALENT' => passedEquivalent,
    'IN_PROGRESS' => inProgress,
    'FAILED' => failed,
    'NOT_TAKEN' => notTaken,
    _ => throw ContractException(wire),
  };
}
