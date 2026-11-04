import 'package:equatable/equatable.dart';
import 'portal_program.dart';
import 'portal_semester_ref.dart';
import 'portal_student.dart';

class PortalOverview extends Equatable {
  const PortalOverview({
    required this.student,
    required this.semester,
    required this.programs,
  });

  final PortalStudent? student;
  final PortalSemesterRef? semester;
  final List<PortalProgram> programs;

  @override
  List<Object?> get props => [student, semester, programs];
}
