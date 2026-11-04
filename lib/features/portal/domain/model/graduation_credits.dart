import 'package:equatable/equatable.dart';

class GraduationCredits extends Equatable {
  const GraduationCredits({
    required this.requiredTotal,
    required this.recognizedTotal,
    required this.missingTotal,
    required this.compulsory,
    required this.elective,
    required this.free,
  });

  final String requiredTotal;
  final String recognizedTotal;
  final String missingTotal;
  final String compulsory;
  final String elective;
  final String free;

  @override
  List<Object?> get props => [
    requiredTotal,
    recognizedTotal,
    missingTotal,
    compulsory,
    elective,
    free,
  ];
}
