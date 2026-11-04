import 'package:equatable/equatable.dart';
import 'course_state.dart';

class CurriculumCourse extends Equatable {
  const CurriculumCourse({
    required this.itemId,
    required this.courseCode,
    required this.courseName,
    required this.credits,
    required this.isElective,
    required this.groupName,
    required this.blockSymbol,
    required this.state,
    required this.attemptCount,
    required this.score10,
    required this.score4,
    required this.letterGrade,
    required this.hasSyllabus,
  });

  final String itemId;
  final String courseCode;
  final String courseName;
  final String credits;
  final bool isElective;
  final String? groupName;
  final String? blockSymbol;
  final CourseState state;
  final int attemptCount;
  final String? score10;
  final String? score4;
  final String? letterGrade;
  final bool hasSyllabus;

  @override
  List<Object?> get props => [
    itemId,
    courseCode,
    courseName,
    credits,
    isElective,
    groupName,
    blockSymbol,
    state,
    attemptCount,
    score10,
    score4,
    letterGrade,
    hasSyllabus,
  ];
}
