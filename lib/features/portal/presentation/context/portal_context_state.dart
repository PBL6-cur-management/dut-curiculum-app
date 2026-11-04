import 'package:equatable/equatable.dart';

import '../../domain/model/portal_context.dart';
import '../../domain/model/portal_overview.dart';
import '../../domain/model/portal_program.dart';
import '../../domain/model/semester.dart';

class PortalContextState extends Equatable {
  const PortalContextState({
    this.isLoading = true,
    this.semesters = const [],
    this.overview,
    this.selectedProgramId,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Semester> semesters;
  final PortalOverview? overview;
  final String? selectedProgramId;
  final String? errorMessage;

  PortalProgram? get selectedProgram {
    for (final program in overview?.programs ?? const <PortalProgram>[]) {
      if (program.programId == selectedProgramId) {
        return program;
      }
    }
    return null;
  }

  PortalContext? get context {
    final student = overview?.student;
    final semester = overview?.semester;
    final program = selectedProgram;
    if (student == null || semester == null || program == null) {
      return null;
    }
    return PortalContext(
      studentId: student.id,
      programId: program.programId,
      semesterId: semester.id,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    semesters,
    overview,
    selectedProgramId,
    errorMessage,
  ];
}
