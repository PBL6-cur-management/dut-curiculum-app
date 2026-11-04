import '../../../../core/network/contract_exception.dart';

enum Eligibility {
  eligible,
  conditional,
  ineligible;

  static Eligibility parse(String wire) => switch (wire) {
    'ELIGIBLE' => eligible,
    'CONDITIONAL' => conditional,
    'INELIGIBLE' => ineligible,
    _ => throw ContractException(wire),
  };
}
