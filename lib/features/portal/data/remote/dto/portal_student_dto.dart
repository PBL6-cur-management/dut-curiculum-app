import '../../../domain/model/portal_student.dart';
import '../../../domain/model/student_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_student_dto.g.dart';

@JsonSerializable()
class PortalStudentDto {
  const PortalStudentDto({
    required this.id,
    required this.studentCode,
    required this.fullName,
    required this.cohortCode,
    required this.major,
    required this.status,
  });

  factory PortalStudentDto.fromJson(Map<String, dynamic> json) =>
      _$PortalStudentDtoFromJson(json);

  final String id;
  final String studentCode;
  final String fullName;
  final String cohortCode;
  final String major;
  final String status;

  Map<String, dynamic> toJson() => _$PortalStudentDtoToJson(this);

  PortalStudent toDomain() => PortalStudent(
    id: id,
    studentCode: studentCode,
    fullName: fullName,
    cohortCode: cohortCode,
    major: major,
    status: StudentStatus.parse(status),
  );
}
