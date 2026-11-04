import 'package:equatable/equatable.dart';
import 'course_ref.dart';
import 'result_status.dart';
import 'semester.dart';

class AcademicResult extends Equatable {
  const AcademicResult({
    required this.id,
    required this.course,
    required this.semester,
    required this.score10,
    required this.score4,
    required this.letterGrade,
    required this.status,
  });

  final String id;
  final CourseRef course;
  final Semester semester;
  final String? score10;
  final String? score4;
  final String? letterGrade;
  final ResultStatus status;

  @override
  List<Object?> get props => [
    id,
    course,
    semester,
    score10,
    score4,
    letterGrade,
    status,
  ];
}
