import '../../../../core/network/contract_exception.dart';

enum CatalogStatus {
  active,
  discontinued,
  cancelled;

  static CatalogStatus parse(String wire) => switch (wire) {
    'ACTIVE' => active,
    'DISCONTINUED' => discontinued,
    'CANCELLED' => cancelled,
    _ => throw ContractException(wire),
  };
}
