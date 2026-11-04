import '../../../domain/model/result_page.dart';
import 'academic_result_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'academic_result_page_dto.g.dart';

@JsonSerializable()
class AcademicResultPageDto {
  const AcademicResultPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory AcademicResultPageDto.fromJson(Map<String, dynamic> json) =>
      _$AcademicResultPageDtoFromJson(json);

  final List<AcademicResultDto> items;
  final int total;
  final int page;
  final int pageSize;

  Map<String, dynamic> toJson() => _$AcademicResultPageDtoToJson(this);

  ResultPage toDomain() => ResultPage(
    items: List.unmodifiable(items.map((item) => item.toDomain())),
    total: total,
    page: page,
    pageSize: pageSize,
  );
}
