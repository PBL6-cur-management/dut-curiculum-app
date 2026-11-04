import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dut_curriculum_app/l10n/app_localizations.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_paths.dart';
import '../../../../core/network/contract_exception.dart';
import '../../domain/model/curriculum.dart';
import '../../domain/model/eligibility_report.dart';
import '../../domain/model/graduation_outcome.dart';
import '../../domain/model/plo.dart';
import '../../domain/model/portal_context.dart';
import '../../domain/model/portal_overview.dart';
import '../../domain/model/result_page.dart';
import '../../domain/model/semester.dart';
import '../../domain/model/syllabus.dart';
import '../../domain/model/syllabus_attachment.dart';
import 'attachment_cache.dart';
import 'graduation_context_validator.dart';
import 'dto/academic_result_page_dto.dart';
import 'dto/graduation_outcome_dto.dart';
import 'dto/portal_curriculum_dto.dart';
import 'dto/portal_me_dto.dart';
import 'dto/portal_plo_dto.dart';
import 'dto/portal_syllabus_dto.dart';
import 'dto/registration_eligibility_dto.dart';
import 'dto/semester_dto.dart';

@singleton
class PortalApi {
  PortalApi(this._dio, this._strings, this._cache);

  final Dio _dio;
  final AppLocalizations _strings;
  final AttachmentCache _cache;

  Future<List<Semester>> semesters() => _get(
    ApiPaths.semesters,
    (body) => List.unmodifiable(
      _list(body).map((item) => SemesterDto.fromJson(_object(item)).toDomain()),
    ),
  );

  Future<PortalOverview> overview({String? semesterId}) => _get(
    ApiPaths.portalMe,
    (body) => PortalMeDto.fromJson(_object(body)).toDomain(),
    query: {'semesterId': ?semesterId},
  );

  Future<Curriculum> curriculum(PortalContext context) => _get(
    ApiPaths.portalCurriculum,
    (body) => PortalCurriculumDto.fromJson(_object(body)).toDomain(),
    query: _query(context),
  );

  Future<List<Plo>> plos(PortalContext context) => _get(
    ApiPaths.portalPlos,
    (body) => List.unmodifiable(
      _list(
        body,
      ).map((item) => PortalPloDto.fromJson(_object(item)).toDomain()),
    ),
    query: _query(context),
  );

  Future<Syllabus> syllabus(PortalContext context, String itemId) => _get(
    ApiPaths.portalSyllabus(itemId),
    (body) => PortalSyllabusDto.fromJson(_object(body)).toDomain(),
    query: _query(context),
  );

  Future<ResultPage> results(PortalContext context, {required int page}) =>
      _get(
        ApiPaths.studentResults(context.studentId),
        (body) => AcademicResultPageDto.fromJson(_object(body)).toDomain(),
        query: {
          ..._query(context),
          'page': page,
          'pageSize': ApiConfig.resultsPageSize,
        },
      );

  Future<EligibilityReport> eligibility(PortalContext context) => _get(
    ApiPaths.studentEligibility(context.studentId),
    (body) =>
        RegistrationEligibilityDto.fromJson(_object(body)).toDomain(_strings),
    query: _query(context),
  );

  Future<GraduationOutcome> graduation(PortalContext context) => _get(
    ApiPaths.studentGraduation(context.studentId),
    (body) => _decodeGraduation(_object(body), context),
    query: _query(context),
  );

  GraduationOutcome _decodeGraduation(
    Map<String, dynamic> body,
    PortalContext expected,
  ) {
    final envelope = GraduationOutcomeDto.fromJson(body);
    final outcome = envelope.toDomain(_strings);
    if (outcome is GraduationReviewed) {
      validateGraduationContext(envelope.result?['context'], expected);
    }
    return outcome;
  }

  Future<String> downloadAttachment(
    PortalContext context,
    String itemId,
    SyllabusAttachment attachment, {
    void Function(int received, int total)? onProgress,
  }) async {
    final path = await _cache.pathFor(attachment.id, attachment.fileName);
    try {
      await _dio.download(
        ApiPaths.portalAttachment(itemId, attachment.id),
        path,
        queryParameters: _query(context),
        onReceiveProgress: onProgress,
        deleteOnError: true,
      );
      return path;
    } on DioException catch (error) {
      throw ApiException.fromDio(error, networkMessage: _strings.networkError);
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(Object? body) decode, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<Object?>(path, queryParameters: query);
      return decode(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error, networkMessage: _strings.networkError);
    } on CheckedFromJsonException catch (error) {
      throw ContractException(_strings.invalidResponse(error.toString()));
    } on ContractException catch (error) {
      throw ContractException(_strings.invalidResponse(error.message));
    } on FormatException catch (error) {
      throw ContractException(_strings.invalidResponse(error.toString()));
    }
  }

  Map<String, dynamic> _query(PortalContext context) => {
    'programId': context.programId,
    'semesterId': context.semesterId,
  };

  Map<String, dynamic> _object(Object? body) {
    if (body is Map<String, dynamic>) {
      return body;
    }
    throw ContractException(body.runtimeType.toString());
  }

  List<dynamic> _list(Object? body) {
    if (body is List) {
      return body;
    }
    throw ContractException(body.runtimeType.toString());
  }
}
