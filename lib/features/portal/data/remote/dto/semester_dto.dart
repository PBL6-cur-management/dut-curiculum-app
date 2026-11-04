import '../../../../../common/extensions/date_parsing.dart';
import '../../../domain/model/semester.dart';
import 'package:json_annotation/json_annotation.dart';

part 'semester_dto.g.dart';

@JsonSerializable()
class SemesterDto {
  const SemesterDto({
    required this.id,
    required this.semesterCode,
    required this.academicYear,
    required this.termInYear,
    required this.startDate,
  });

  factory SemesterDto.fromJson(Map<String, dynamic> json) =>
      _$SemesterDtoFromJson(json);

  final String id;
  final String semesterCode;
  final String academicYear;
  final int termInYear;
  final String? startDate;

  Map<String, dynamic> toJson() => _$SemesterDtoToJson(this);

  Semester toDomain() => Semester(
    id: id,
    code: semesterCode,
    academicYear: academicYear,
    termInYear: termInYear,
    startDateMs: startDate == null ? null : parseDateOnly(startDate!),
  );
}
