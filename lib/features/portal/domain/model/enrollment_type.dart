import '../../../../core/network/contract_exception.dart';

enum EnrollmentType {
  primary,
  secondMajor;

  static EnrollmentType parse(String wire) => switch (wire) {
    'PRIMARY' => primary,
    'SECOND_MAJOR' => secondMajor,
    _ => throw ContractException(wire),
  };
}
