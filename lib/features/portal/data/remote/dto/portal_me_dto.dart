import '../../../domain/model/portal_overview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'portal_program_dto.dart';
import 'portal_semester_dto.dart';
import 'portal_student_dto.dart';

part 'portal_me_dto.g.dart';

@JsonSerializable()
class PortalMeDto {
  const PortalMeDto({
    required this.student,
    required this.semester,
    required this.programs,
  });

  factory PortalMeDto.fromJson(Map<String, dynamic> json) =>
      _$PortalMeDtoFromJson(json);

  final PortalStudentDto? student;
  final PortalSemesterDto? semester;
  final List<PortalProgramDto> programs;

  Map<String, dynamic> toJson() => _$PortalMeDtoToJson(this);

  PortalOverview toDomain() => PortalOverview(
    student: student?.toDomain(),
    semester: semester?.toDomain(),
    programs: List.unmodifiable(programs.map((item) => item.toDomain())),
  );
}
