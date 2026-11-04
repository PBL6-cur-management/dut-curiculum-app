import '../../../../core/network/contract_exception.dart';

enum GraduationConclusion {
  eligible,
  notEligible;

  static GraduationConclusion parse(String wire) => switch (wire) {
    'ELIGIBLE' => eligible,
    'NOT_ELIGIBLE' => notEligible,
    _ => throw ContractException(wire),
  };
}
