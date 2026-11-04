import 'package:equatable/equatable.dart';
import 'student_status.dart';

class PortalStudent extends Equatable {
  const PortalStudent({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.cohortCode,
    required this.major,
    required this.status,
  });

  final String id;
  final String studentCode;
  final String fullName;
  final String cohortCode;
  final String major;
  final StudentStatus status;

  @override
  List<Object?> get props => [
    id,
    studentCode,
    fullName,
    cohortCode,
    major,
    status,
  ];
}
