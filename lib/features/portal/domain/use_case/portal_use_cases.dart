import 'package:injectable/injectable.dart';

import '../model/curriculum.dart';
import '../model/eligibility_report.dart';
import '../model/graduation_outcome.dart';
import '../model/plo.dart';
import '../model/portal_context.dart';
import '../model/portal_overview.dart';
import '../model/result_page.dart';
import '../model/semester.dart';
import '../model/syllabus.dart';
import '../model/syllabus_attachment.dart';
import '../repository/portal_repository.dart';

@injectable
class PortalUseCases {
  PortalUseCases(this._repository);

  final PortalRepository _repository;

  Future<List<Semester>> startedSemesters() => _repository.startedSemesters();
  Future<PortalOverview> overview({String? semesterId}) =>
      _repository.overview(semesterId: semesterId);
  Future<Curriculum> curriculum(PortalContext context) =>
      _repository.curriculum(context);
  Future<List<Plo>> plos(PortalContext context) => _repository.plos(context);
  Future<Syllabus> syllabus(PortalContext context, String itemId) =>
      _repository.syllabus(context, itemId);
  Future<String> downloadAttachment(
    PortalContext context,
    String itemId,
    SyllabusAttachment attachment, {
    void Function(int received, int total)? onProgress,
  }) => _repository.downloadAttachment(
    context,
    itemId,
    attachment,
    onProgress: onProgress,
  );
  Future<ResultPage> results(PortalContext context, {required int page}) =>
      _repository.results(context, page: page);
  Future<EligibilityReport> eligibility(PortalContext context) =>
      _repository.eligibility(context);
  Future<GraduationOutcome> graduation(PortalContext context) =>
      _repository.graduation(context);
}
