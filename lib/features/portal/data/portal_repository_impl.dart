import 'package:injectable/injectable.dart';

import '../domain/model/curriculum.dart';
import '../domain/model/eligibility_report.dart';
import '../domain/model/graduation_outcome.dart';
import '../domain/model/plo.dart';
import '../domain/model/portal_context.dart';
import '../domain/model/portal_overview.dart';
import '../domain/model/result_page.dart';
import '../domain/model/semester.dart';
import '../domain/model/syllabus.dart';
import '../domain/model/syllabus_attachment.dart';
import '../domain/repository/portal_repository.dart';
import 'remote/portal_api.dart';

@Singleton(as: PortalRepository)
class PortalRepositoryImpl implements PortalRepository {
  PortalRepositoryImpl(this._api);

  final PortalApi _api;

  @override
  Future<List<Semester>> startedSemesters() async {
    final semesters = (await _api.semesters())
        .where((semester) => semester.startDateMs != null)
        .toList();
    semesters.sort(
      (left, right) => right.startDateMs!.compareTo(left.startDateMs!),
    );
    return List.unmodifiable(semesters);
  }

  @override
  Future<PortalOverview> overview({String? semesterId}) =>
      _api.overview(semesterId: semesterId);
  @override
  Future<Curriculum> curriculum(PortalContext context) =>
      _api.curriculum(context);
  @override
  Future<List<Plo>> plos(PortalContext context) => _api.plos(context);
  @override
  Future<Syllabus> syllabus(PortalContext context, String itemId) =>
      _api.syllabus(context, itemId);
  @override
  Future<String> downloadAttachment(
    PortalContext context,
    String itemId,
    SyllabusAttachment attachment, {
    void Function(int received, int total)? onProgress,
  }) => _api.downloadAttachment(
    context,
    itemId,
    attachment,
    onProgress: onProgress,
  );
  @override
  Future<ResultPage> results(PortalContext context, {required int page}) =>
      _api.results(context, page: page);
  @override
  Future<EligibilityReport> eligibility(PortalContext context) =>
      _api.eligibility(context);
  @override
  Future<GraduationOutcome> graduation(PortalContext context) =>
      _api.graduation(context);
}
