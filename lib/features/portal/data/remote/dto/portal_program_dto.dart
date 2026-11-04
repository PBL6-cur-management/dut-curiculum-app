import '../../../domain/model/enrollment_type.dart';
import '../../../domain/model/portal_program.dart';
import 'package:json_annotation/json_annotation.dart';

part 'portal_program_dto.g.dart';

@JsonSerializable()
class PortalProgramDto {
  const PortalProgramDto({
    required this.programId,
    required this.programCode,
    required this.programName,
    required this.enrollmentType,
    required this.versionNumber,
    required this.decisionNumber,
  });

  factory PortalProgramDto.fromJson(Map<String, dynamic> json) =>
      _$PortalProgramDtoFromJson(json);

  final String programId;
  final String programCode;
  final String programName;
  final String enrollmentType;
  final String? versionNumber;
  final String? decisionNumber;

  Map<String, dynamic> toJson() => _$PortalProgramDtoToJson(this);

  PortalProgram toDomain() => PortalProgram(
    programId: programId,
    programCode: programCode,
    programName: programName,
    enrollmentType: EnrollmentType.parse(enrollmentType),
    versionNumber: versionNumber,
    decisionNumber: decisionNumber,
  );
}
