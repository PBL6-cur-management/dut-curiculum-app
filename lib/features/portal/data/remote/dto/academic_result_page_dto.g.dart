// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_result_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicResultPageDto _$AcademicResultPageDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AcademicResultPageDto', json, ($checkedConvert) {
  final val = AcademicResultPageDto(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AcademicResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    total: $checkedConvert('total', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$AcademicResultPageDtoToJson(
  AcademicResultPageDto instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
