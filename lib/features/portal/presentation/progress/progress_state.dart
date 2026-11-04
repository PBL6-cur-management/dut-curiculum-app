import 'package:equatable/equatable.dart';

import '../../domain/model/academic_result.dart';
import '../../domain/model/graduation_outcome.dart';

class ProgressState extends Equatable {
  const ProgressState({
    this.isLoading = true,
    this.isLoadingMore = false,
    this.resultsLoaded = false,
    this.graduation,
    this.results = const [],
    this.total = 0,
    this.nextPage = 1,
    this.fraction = 0,
    this.graduationError,
    this.resultsError,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool resultsLoaded;
  final GraduationOutcome? graduation;
  final List<AcademicResult> results;
  final int total;
  final int nextPage;
  final double fraction;
  final String? graduationError;
  final String? resultsError;

  bool get hasMore => resultsLoaded && results.length < total;
  String? get errorMessage {
    final messages = [?graduationError, ?resultsError];
    return messages.isEmpty ? null : messages.join('\n');
  }

  ProgressState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? resultsLoaded,
    GraduationOutcome? graduation,
    List<AcademicResult>? results,
    int? total,
    int? nextPage,
    double? fraction,
    String? graduationError,
    String? resultsError,
    bool clearResultsError = false,
  }) => ProgressState(
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    resultsLoaded: resultsLoaded ?? this.resultsLoaded,
    graduation: graduation ?? this.graduation,
    results: results ?? this.results,
    total: total ?? this.total,
    nextPage: nextPage ?? this.nextPage,
    fraction: fraction ?? this.fraction,
    graduationError: graduationError ?? this.graduationError,
    resultsError: clearResultsError ? null : resultsError ?? this.resultsError,
  );

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    resultsLoaded,
    graduation,
    results,
    total,
    nextPage,
    fraction,
    graduationError,
    resultsError,
  ];
}
