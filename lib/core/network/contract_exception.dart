class ContractException implements Exception {
  const ContractException(this.message);

  final String message;

  @override
  String toString() => message;
}
