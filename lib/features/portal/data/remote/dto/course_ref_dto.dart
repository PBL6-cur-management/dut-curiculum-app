import '../../../domain/model/course_ref.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_ref_dto.g.dart';

@JsonSerializable()
class CourseRefDto {
  const CourseRefDto({
    required this.id,
    required this.courseCode,
    required this.courseName,
  });

  factory CourseRefDto.fromJson(Map<String, dynamic> json) =>
      _$CourseRefDtoFromJson(json);

  final String id;
  final String courseCode;
  final String courseName;

  Map<String, dynamic> toJson() => _$CourseRefDtoToJson(this);

  CourseRef toDomain() => CourseRef(id: id, code: courseCode, name: courseName);
}
