double creditFraction(String recognized, String required) {
  final earned = double.parse(recognized);
  final target = double.parse(required);
  if (!earned.isFinite || !target.isFinite || earned < 0 || target < 0) {
    throw FormatException('$recognized/$required');
  }
  return target == 0 ? 0 : (earned / target).clamp(0.0, 1.0).toDouble();
}
