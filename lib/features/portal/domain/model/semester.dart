import 'package:equatable/equatable.dart';

class Semester extends Equatable {
  const Semester({
    required this.id,
    required this.code,
    required this.academicYear,
    required this.termInYear,
    required this.startDateMs,
  });

  final String id;
  final String code;
  final String academicYear;
  final int termInYear;
  final int? startDateMs;

  @override
  List<Object?> get props => [id, code, academicYear, termInYear, startDateMs];
}
