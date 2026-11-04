import 'package:equatable/equatable.dart';
import 'enrollment_type.dart';

class PortalProgram extends Equatable {
  const PortalProgram({
    required this.programId,
    required this.programCode,
    required this.programName,
    required this.enrollmentType,
    required this.versionNumber,
    required this.decisionNumber,
  });

  final String programId;
  final String programCode;
  final String programName;
  final EnrollmentType enrollmentType;
  final String? versionNumber;
  final String? decisionNumber;

  @override
  List<Object?> get props => [
    programId,
    programCode,
    programName,
    enrollmentType,
    versionNumber,
    decisionNumber,
  ];
}
