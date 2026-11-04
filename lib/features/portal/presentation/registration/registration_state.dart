import 'package:equatable/equatable.dart';

import '../../domain/model/eligibility.dart';
import '../../domain/model/eligibility_item.dart';
import '../../domain/model/eligibility_report.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.isLoading = true,
    this.report,
    this.errorMessage,
  });

  final bool isLoading;
  final EligibilityReport? report;
  final String? errorMessage;

  List<EligibilityItem> get allowed => List.unmodifiable(
    (report?.items ?? const <EligibilityItem>[]).where(
      (item) =>
          !item.completed &&
          (item.eligibility == Eligibility.eligible ||
              item.eligibility == Eligibility.conditional),
    ),
  );

  List<EligibilityItem> get blocked => List.unmodifiable(
    (report?.items ?? const <EligibilityItem>[]).where(
      (item) => !item.completed && item.eligibility == Eligibility.ineligible,
    ),
  );

  List<EligibilityItem> get unknown => List.unmodifiable(
    (report?.items ?? const <EligibilityItem>[]).where(
      (item) => !item.completed && item.eligibility == null,
    ),
  );

  @override
  List<Object?> get props => [isLoading, report, errorMessage];
}
