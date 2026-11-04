import 'package:equatable/equatable.dart';
import 'curriculum_term.dart';

class Curriculum extends Equatable {
  const Curriculum({
    required this.programName,
    required this.versionNumber,
    required this.decisionNumber,
    required this.totalCredits,
    required this.terms,
  });

  final String programName;
  final String? versionNumber;
  final String? decisionNumber;
  final String totalCredits;
  final List<CurriculumTerm> terms;

  @override
  List<Object?> get props => [
    programName,
    versionNumber,
    decisionNumber,
    totalCredits,
    terms,
  ];
}
