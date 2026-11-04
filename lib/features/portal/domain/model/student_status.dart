import '../../../../core/network/contract_exception.dart';

enum StudentStatus {
  studying,
  onLeave,
  withdrawn,
  graduated;

  static StudentStatus parse(String wire) => switch (wire) {
    'STUDYING' => studying,
    'ON_LEAVE' => onLeave,
    'WITHDRAWN' => withdrawn,
    'GRADUATED' => graduated,
    _ => throw ContractException(wire),
  };
}
