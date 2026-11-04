import 'package:equatable/equatable.dart';
import 'eligibility_item.dart';
import 'eligibility_warning.dart';

class EligibilityReport extends Equatable {
  const EligibilityReport({
    required this.evaluatedAtMs,
    required this.items,
    required this.warnings,
  });

  final int evaluatedAtMs;
  final List<EligibilityItem> items;
  final List<EligibilityWarning> warnings;

  @override
  List<Object?> get props => [evaluatedAtMs, items, warnings];
}
