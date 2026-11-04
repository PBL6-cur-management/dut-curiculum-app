import 'package:equatable/equatable.dart';

import '../../domain/model/graduation_outcome.dart';

class GraduationState extends Equatable {
  const GraduationState({
    this.isLoading = true,
    this.outcome,
    this.fraction = 0,
    this.errorMessage,
  });

  final bool isLoading;
  final GraduationOutcome? outcome;
  final double fraction;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, outcome, fraction, errorMessage];
}
