import '../../../../core/network/contract_exception.dart';

enum ResultStatus {
  passed,
  failed,
  inProgress,
  exempt;

  static ResultStatus parse(String wire) => switch (wire) {
    'PASSED' => passed,
    'FAILED' => failed,
    'IN_PROGRESS' => inProgress,
    'EXEMPT' => exempt,
    _ => throw ContractException(wire),
  };
}
