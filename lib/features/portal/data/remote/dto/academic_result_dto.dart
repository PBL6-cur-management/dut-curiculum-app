import '../../../domain/model/academic_result.dart';
import '../../../domain/model/result_status.dart';
import 'course_ref_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'semester_dto.dart';

part 'academic_result_dto.g.dart';

@JsonSerializable()
class AcademicResultDto {
  const AcademicResultDto({
    required this.id,
    required this.course,
    required this.semester,
    required this.score10,
    required this.score4,
    required this.letterGrade,
    required this.status,
  });

  factory AcademicResultDto.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultDtoFromJson(json);

  final String id;
  final CourseRefDto course;
  final SemesterDto semester;
  final String? score10;
  final String? score4;
  final String? letterGrade;
  final String status;

  Map<String, dynamic> toJson() => _$AcademicResultDtoToJson(this);

  AcademicResult toDomain() => AcademicResult(
    id: id,
    course: course.toDomain(),
    semester: semester.toDomain(),
    score10: score10,
    score4: score4,
    letterGrade: letterGrade,
    status: ResultStatus.parse(status),
  );
}
