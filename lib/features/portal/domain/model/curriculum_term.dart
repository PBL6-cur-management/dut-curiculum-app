import 'package:equatable/equatable.dart';
import 'curriculum_course.dart';

class CurriculumTerm extends Equatable {
  const CurriculumTerm({
    required this.plannedSemester,
    required this.credits,
    required this.courses,
  });

  final int plannedSemester;
  final String credits;
  final List<CurriculumCourse> courses;

  @override
  List<Object?> get props => [plannedSemester, credits, courses];
}
