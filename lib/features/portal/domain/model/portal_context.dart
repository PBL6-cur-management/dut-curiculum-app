import 'package:equatable/equatable.dart';

class PortalContext extends Equatable {
  const PortalContext({
    required this.studentId,
    required this.programId,
    required this.semesterId,
  });

  final String studentId;
  final String programId;
  final String semesterId;

  @override
  List<Object?> get props => [studentId, programId, semesterId];
}
