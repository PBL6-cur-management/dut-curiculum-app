import '../../../domain/model/course_state.dart';
import '../../../domain/model/curriculum_course.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_course_dto.g.dart';

@JsonSerializable()
class PortalCourseDto {
  const PortalCourseDto({
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

  factory PortalCourseDto.fromJson(Map<String, dynamic> json) =>
      _$PortalCourseDtoFromJson(json);

  final String itemId;
  final String courseCode;
  final String courseName;
  final String credits;
  final bool isElective;
  final String? groupName;
  final String? blockSymbol;
  final String state;
  final int attemptCount;
  final String? score10;
  final String? score4;
  final String? letterGrade;
  final bool hasSyllabus;

  Map<String, dynamic> toJson() => _$PortalCourseDtoToJson(this);

  CurriculumCourse toDomain() => CurriculumCourse(
    itemId: itemId,
    courseCode: courseCode,
    courseName: courseName,
    credits: credits,
    isElective: isElective,
    groupName: groupName,
    blockSymbol: blockSymbol,
    state: CourseState.parse(state),
    attemptCount: attemptCount,
    score10: score10,
    score4: score4,
    letterGrade: letterGrade,
    hasSyllabus: hasSyllabus,
  );
}
