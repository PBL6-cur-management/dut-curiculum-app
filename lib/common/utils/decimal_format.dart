String formatDecimal(String value) => value.replaceAll('.', ',');

String formatCredits(num value) => formatDecimal(
  value == value.truncate()
      ? value.toInt().toString()
      : value.toStringAsFixed(1),
);
